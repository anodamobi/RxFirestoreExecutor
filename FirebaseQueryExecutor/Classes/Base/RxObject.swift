//
//  RxObject.swift
//  BoringSSL
//
//  Created by Pavel Mosunov on 10/3/18.
//

import Foundation
import RxSwift

@objcMembers
open class RxObject: FEObject, SelfExecutable {
    
    let bag = DisposeBag()
    
    public typealias ObjectType = RxObject
    
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
    
    public func pushObject(_ object: RxObject,
                           updated: @escaping UpdateBlock,
                           _ errorBlock: @escaping ErrorBlock) {
        
        super.push(object)
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
    
    //Self mapping from dictionary to Object
    //This will work only if variables are Dynamic
    func map(_ result: [String: Any]) {
        let keys = result.keys
        for key in keys {
            
            if result[key] is [String: Any] {
                if let dict = result[key] as? [String: Any] {
                    if let value = value(forKey: key) as? RxObject {
                        value.map(dict)
                    } else {
                        setValue(result[key], forKey: key)
                    }
                }
            } else {
                setValue(result[key], forKey: key)
            }
        }
    }
}
