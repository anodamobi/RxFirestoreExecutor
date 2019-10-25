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

extension RxObject: SelfExecutable {
    
    public func pullObject(updated: @escaping UpdateBlock,
                    _ errorBlock: @escaping ErrorBlock) {
        
        super.pull()
            .subscribe(onSuccess: { [weak self] (data) in
                guard let `self` = self else {
                    updated()
                    return
                }
                
                self.map(data)
                updated()
                
            }) { (error) in
                errorBlock(error)
            }.disposed(by: bag)
    }
    
    public func pullObject(traits: QueryTargetProtocol.TraitList,
                           _ updated: @escaping UpdateBlock,
                           _ errorBlock: @escaping ErrorBlock) {
        super.pull(traits)
            .subscribe(onSuccess: { [weak self] (data) in
            guard let `self` = self else {
                updated()
                return
            }
            self.map(data)
            updated()
        }) { (error) in
            errorBlock(error)
        }.disposed(by: bag)
        
    }
    
    public func pullObject(trait: QueryTargetProtocol.Trait,
                           _ updated: @escaping UpdateBlock,
                           _ errorBlock: @escaping ErrorBlock) {
        super.pull([trait]).subscribe(onSuccess: { [weak self] (data) in
            guard let `self` = self else {
                updated()
                return
            }
            self.map(data)
            updated()
        }) { (error) in
            errorBlock(error)
        }.disposed(by: bag)
    }
    
    
    //TODO: To test
    //in completion can be returned initial collection
    public func pullFrom(object: FEObject) {
        collection = "\(object.collection)/\(object.itemID)/\(collection)"
        pullObject(updated: { }) { (error) in }
    }
    
    //MARK: Push
    
    
    //TODO: Tot test
    public func pushTo(object: FEObject) {
        collection = "\(object.collection)/\(object.itemID)/\(collection)"
        pushObject(updated: { }) { (error) in }
    }
    
    
    public func pushObject(updated: @escaping UpdateBlock,
                           _ errorBlock: @escaping ErrorBlock) {
        
        super.push(self)
            .subscribe(onSuccess: { [weak self] (data) in
                guard let `self` = self else {
                    updated()
                    return
                }
                
                self.map(data)
                updated()
                
            }) { (error) in
                errorBlock(error)
            }.disposed(by: bag)
    }
    
    public func pushObject(subObjects: [FEObject],
                           _ updated: @escaping UpdateBlock,
                           _ errorBlock: @escaping ErrorBlock) {
        //TODO: Is necessary?
    }
    
    public func pullObject(with subCollection: String,
                           _ updated: @escaping RxObject.UpdateBlock,
                           _ errorBlock: @escaping RxObject.ErrorBlock) {
        //TODO:
    }
    
    //MARK Observe
    
    public func observe(updated: @escaping UpdateBlock,
                        _ errorBlock: @escaping ErrorBlock) {
        
        super.observe()
            .subscribe(onNext: { [weak self] (data) in
                guard let `self` = self else {
                    updated()
                    return
                }
                
                self.map(data)
                updated()
                
                }, onError: { (error) in
                    errorBlock(error)
            }).disposed(by: bag)
    }
    
    public func delete(_ errorBlock: @escaping ErrorBlock) {
        super.delete().asCompletable().subscribe(onCompleted: {
            
        }) { (error) in
            errorBlock(error)
        }.disposed(by: bag)
    }
}
