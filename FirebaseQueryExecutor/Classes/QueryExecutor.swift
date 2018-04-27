//
//  QueryExecutor.swift
//  ShiftMe
//
//  Created by Pavel Mosunov on 3/7/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import RxSwift

public class QueryExecutor<Target> where Target: QueryTargetProtocol {
    private var single = ExecutorSingle()
    private var observeable = ExecutorObserveable()
    
    public init() {}
    
    public func request(_ token: Target, condition: QueryConditions = .and) -> Single<Any> {
        single.create(collectionRef: token.collection)
        single.condition = condition
        
        return single.singleTrait(token.singleDocument,
                                  token.params,
                                  token.data)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .utility))
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .utility))
    }
    
    public func subscribe(_ token: Target, condition: QueryConditions = .and) -> Observable<Any> {
        observeable.create(collectionRef: token.collection)
        observeable.condition = condition
        
        return observeable.observableSubscription(token.singleDocument,
                                                  token.params,
                                                  token.nestedCollection)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .utility))
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .utility))
    }
}


