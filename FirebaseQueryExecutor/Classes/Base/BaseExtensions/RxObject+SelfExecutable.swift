//
//  RxObject+SelfExecutable.swift
//  BoringSSL-GRPC
//
//  Created by Pavel Mosunov on 10/25/19.
//

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
    
    //MARK: Push
    
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
