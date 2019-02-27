/*
 The MIT License (MIT)
 Copyright (c) 2018 ANODA Mobile Development Agency. http://anoda.mobi <info@anoda.mobi>
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import Foundation
import RxSwift

@objcMembers
open class FEObject: NSObject, QueryExecutorProtocol, BaseTypeProtocol {
    
    dynamic open var itemID = ""
    dynamic open var collection: CollectionRef = ""
    
    let observer = ExecutorObserveable()
    
    required override public init() {
        super.init()
    }
    
    //Push
    internal func push<BaseType>(_ object: BaseType) -> Single<[String: Any]> {
        let single = ExecutorSingle()
        
        return single.pushObject(col: collection,
                                 docID: itemID,
                                 data: map(item: object as AnyObject))
            .flatMap({ (id) -> Single<[String: Any]> in
                
                self.itemID = id
                return self.pull()
            })
    }
    
    //pull
    internal func pull() -> Single<[String:Any]> {
        let single = ExecutorSingle()
        
        return single.loadSingleDoc(docID: itemID, collection: collection)
            .flatMap { (data) -> Single<[String: Any]> in
                
                return Single.just(data)
        }
    }
    
    //Observe
    internal func observe() -> Observable<[String:Any]> {
        
        return observer.observeSingle(documentID: itemID, collection: collection)
            .flatMap({ (data) -> Observable<[String: Any]> in
                
                return Observable.just(data)
            })
    }
    
}

enum ModelError: Error {
    case failedToConvertToDict
}

extension ModelError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .failedToConvertToDict:
            return "Cannot convert received data to Dict :'("
        }
    }
    
}

extension FEObject {
    
    public func map(item: AnyObject) -> [String: Any] {
        
        var result: [String:Any] = [:]
        let mirrorObject = Mirror(reflecting: item)
        
        for (name, value) in mirrorObject.children {
            guard let name = name else { continue }
            
            var innerValue: Any?
            if value is FEObject {
                innerValue = map(item: value as AnyObject)
            } else {
                innerValue = value
            }
            if let val = innerValue {
                result[name] = val
            }
        }
        return result
    }
}
