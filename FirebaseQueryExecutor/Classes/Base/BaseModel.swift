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

public protocol BaseType {
    
    init(dict: [String: Any])
}

open class BaseModel:  QueryExecutorProtocol, BaseType {
    
    public init() {}
    
    required public init(dict: [String: Any]) {
        itemID = dict["itemID"] as? String ?? ""
    }
    
    open var itemID = ""
    open var collection: CollectionRef = ""
    ///Move to background!
    
    //Push
    open func push<Type: BaseType>(_ object: Type) -> Single<Type> {
        let single = ExecutorSingle()
        
        return single.pushObject(col: collection,
                                 docID: itemID,
                                 data: map(item: object as AnyObject))
            .flatMap({ (id) -> PrimitiveSequence<SingleTrait, Type> in
                
                self.itemID = id
                return self.pull()
        })
    }
    

    //Pull
    open func pull<Type: BaseType>() -> Single<Type> {
        let single = ExecutorSingle()
        
        return single.loadSingleDoc(docID: itemID, collection: collection)
            .flatMap { (data) -> PrimitiveSequence<SingleTrait, Type> in
                return Single.just(Type.init(dict: data))
        }
    }
    
    //Observe
    open func observe<Type: BaseType>() -> Observable<Type> {
        let observer = ExecutorObserveable()
        
        return observer.observeSingle(documentID: itemID, collection: collection).flatMap({ (data) -> Observable<Type> in
            return Observable<Type>.just(Type.init(dict: data))
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

extension BaseModel {
    
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
