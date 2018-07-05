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

open class BaseModel:  QueryExecutorProtocol {
    
    public init() {}
    
    var objectID = ""
    
    open var collection: CollectionRef = ""
    
    //Success or error
    open func push(_ object: Any) -> Single<Any> {
        let single = ExecutorSingle()
        
        return single.pushObject(col: collection, docID: objectID, data: map(item: object as AnyObject))
    }
    
    open func pull() {
        
    }
    
    open func observe() {
        
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
    
    public func mapTo<T>(item: T.Type) -> Single<T> {
        
        return Single.create(subscribe: { (single) in
            
            return Disposables.create()
        })
    }
}
