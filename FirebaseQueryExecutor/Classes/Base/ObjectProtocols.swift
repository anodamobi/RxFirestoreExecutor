//
//  ObjectProtocols.swift
//  BoringSSL
//
//  Created by Pavel Mosunov on 10/3/18.
//

import Foundation
import RxSwift

public protocol Initializabel {
    init(_ dict: [String: Any])
}

public protocol BaseTypeProtocol {
    
    var collection: String { get set }
    var itemID: String { get set }
}

public protocol SelfExecutable {
    
    associatedtype ObjectType
    
    func pull() -> Single<ObjectType>
    func push(_ object: ObjectType) -> Single<ObjectType>
    func observe() -> Observable<ObjectType>
}
