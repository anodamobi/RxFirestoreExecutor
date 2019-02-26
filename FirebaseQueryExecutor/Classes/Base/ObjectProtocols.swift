//
//  ObjectProtocols.swift
//  BoringSSL
//
//  Created by Pavel Mosunov on 10/3/18.
//

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
    func pushObject(_ object: ObjectType, updated: @escaping UpdateBlock, _ errorBlock: @escaping ErrorBlock)
    func observe(updated: @escaping UpdateBlock, _ errorBlock: @escaping ErrorBlock)
}
