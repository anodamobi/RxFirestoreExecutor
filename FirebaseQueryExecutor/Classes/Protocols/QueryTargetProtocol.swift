//
//  QueryTargetProtocol.swift
//  PranaHEart
//
//  Created by Pavel Mosunov on 4/4/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation

public protocol QueryTargetProtocol: QueryExecutorProtocol {
    
    // NOTE: collection define documents for search. Example: collection = "users"
    var collection: CollectionRef { get }
    
    // NOTE: to get single document
    var singleDocument: SingleDocument { get }
    
    // NOTE: fieldName is needed to filter data on DB. Actually it takes field name
    // Might be nil if we do not need query. Example: expectedValue = "Email"
    var params: TraitList { get }
    
    // NOTE: To update data on backend fill data dictionary for a specific case.
    // documentID is requeired for data
    var data: UpdateableData { get }
    
    // TODO: (pavel.mosunov) modify to use nested collections through nested documents in nested collections.
    // NOTE: Nested Collection define collection nested into the document
    var nestedCollection: NestedCollection { get }
    
    // NOTE: @param orPair - defines query condition for element
    // @param firstConstraint @param secondConstraint defines != condition which is equal to logical OR.
    // e.g. - constraint1.fieldName > constraint1.expectedValue + constraint2.fieldName < constraint1.expectedValue
    var orPair: ConditionPair { get }
    
    // NOTE: @param orderString - defines param in document we ordering by
    // @param isOrderSpecified - defines useage of next argument. On True isAscending will be taken into account
    // @param isAscending - defines order as Descending or Not.
    var order: OrderTrait { get }
}
