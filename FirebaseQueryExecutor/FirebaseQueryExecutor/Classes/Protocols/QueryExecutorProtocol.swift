//
//  RequestTypeProtocol.swift
//  PranaHeart
//
//  Created by Pavel Mosunov on 4/3/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation

public protocol QueryExecutorProtocol {

    typealias NestedCollection = (document:String, collection:String)?
    typealias NestedCollectionList = [(document:String, collection: String)]?
    typealias UpdateableData = (String?, [String: Any]?)
    typealias SingleDocument = String?
    typealias TraitList = [Trait]?
    typealias CollectionRef = String
    typealias ConditionPair = (firstConstraint:Trait, secondConstraint:Trait)?
    typealias Trait = (fieldName: String, expectedValue: String)
    typealias OrderTrait = (orderString:String, isOrderSpecified: Bool, isAscending:Bool)?
}
