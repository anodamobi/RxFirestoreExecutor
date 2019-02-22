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

open class FEObject: NSObject, QueryExecutorProtocol, Initializable, BaseTypeProtocol {
    
    open var itemID = ""
    open var collection: CollectionRef = ""
    
    let observer = ExecutorObserveable()
    
    convenience public override init() {
        self.init([:])
    }
    
    required public init(_ result: [String: Any]) {
        super.init()
        itemID = result["itemID"] as? String ?? ""
    }


    ///Move to background!
    
    //Push
    public func push<BaseType: Initializable>(_ object: BaseType) -> Single<BaseType> {
        let single = ExecutorSingle()
        
        return single.pushObject(col: collection,
                                 docID: itemID,
                                 data: map(item: object as AnyObject))
            .flatMap({ (id) -> Single<BaseType> in
                
                self.itemID = id
                return self.pull()
        })
    }
    
    //pull
    public func pull<BaseType: Initializable>() -> Single<BaseType> {
        let single = ExecutorSingle()
        
        return single.loadSingleDoc(docID: itemID, collection: collection)
            .flatMap { (data) -> Single<BaseType> in

                return Single.just(BaseType.init(data))
        }
    }
    
    //Observe
    public func observe<BaseType: Initializable>() -> Observable<BaseType> {
        
        return observer.observeSingle(documentID: itemID, collection: collection)
            .flatMap({ (data) -> Observable<BaseType> in
            return Observable<BaseType>.just(BaseType.init(data))
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
    
    public func map(item: AnyObject) -> [String:Any] {
        
        var result: [String:Any] = [:]
        let mirrorObject = Mirror(reflecting: item)
        for (name, value) in mirrorObject.children {
            guard let name = name else { continue }
            print(name)
            result[name] = value
        }
        return result
    }
}
