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

public protocol BaseTypeProtocol {
    
    var collection: String { get set }
    var itemID: String { get set }
}

public protocol SelfExecutable {
    associatedtype ObjectType
    
    typealias ErrorBlock = (_ error: Error)->()
    typealias UpdateBlock = ()->()
    
    // Update block needed to make action whenever model updated, or to make sync when several model updated at a same time.
    //Error block is needed in case update was done with errors. In this case we will still work with old model.
    func pullObject(updated: @escaping UpdateBlock, _ errorBlock: @escaping ErrorBlock)
    func pushObject(updated: @escaping UpdateBlock, _ errorBlock: @escaping ErrorBlock)
    func observe(updated: @escaping UpdateBlock, _ errorBlock: @escaping ErrorBlock)
    
    //Conditional pulls
    func pullObject(traits: QueryTargetProtocol.TraitList,
                    _ updated: @escaping UpdateBlock,
                    _ errorBlock: @escaping ErrorBlock)
    
    func pullObject(trait: QueryTargetProtocol.Trait,
                    _ updated: @escaping UpdateBlock,
                    _ errorBlock: @escaping ErrorBlock)
    
    //Conditional pushes
    func pushObject(subObjects: [FEObject],
                    _ updated: @escaping UpdateBlock,
                    _ errorBlock: @escaping ErrorBlock)
}
