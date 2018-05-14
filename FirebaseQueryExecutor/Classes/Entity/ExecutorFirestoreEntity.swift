//
//  FirestoreEntity.swift
//  PranaHeart
//
//  Created by Pavel Mosunov on 4/3/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import FirebaseFirestore
import RxSwift

public struct QueryConditions: OptionSet {
    public var rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static let and = QueryConditions(rawValue: 1 << 0)
    public static let or = QueryConditions(rawValue: 1 << 1)
    
    public static let all: [QueryConditions] = [.and, .or]
}

class ExecutorFirestoreEntity: QueryExecutorProtocol {
    
    var db: Firestore
    var collectionString: String?
    var condition: QueryConditions = .and
    var order: OrderTrait
    
    init() {
        db = Firestore.firestore()
    }
    
    func create(collectionRef: String) {
        collectionString = collectionRef
    }
    
    func composeObject(document: QueryDocumentSnapshot) -> [String : Any] {
        var doc = document.data()
        doc["id"] = document.documentID
        doc["uid"] = document.documentID
        return doc
    }
    
    func orderQuery(_ query: inout Query) {
        if let order = self.order {
            if order.isOrderSpecified {
                query.order(by: order.orderString, descending: order.isAscending)
            } else {
                query.order(by: order.orderString)
            }
        }
    }
    
    func create(query: inout Query, argTrain: TraitList) {
        
        switch condition {
        case .and:
            if  let amount = argTrain?.count, amount > 1 {
                for index in 1..<amount {
                    if let fieldName: String = argTrain?[index].fieldName {
                        if let expectedValue: String = argTrain?[index].expectedValue {
                            query = query.whereField(fieldName, isEqualTo: expectedValue)
                        }
                    }
                    
                }
            }
        case .or: //TODO: pavel -Will be used little bit later
            if  let amount = argTrain?.count, amount > 1 {
                for var index in 1..<amount {
                    query = query.whereField(argTrain![index].fieldName, isGreaterThan: argTrain![index].expectedValue)
                    query = query.whereField(argTrain![index + 1].fieldName, isGreaterThan: argTrain![index + 1].expectedValue)
                    index += 1
                }
            }
        default: break
        }
    }
    
    func onError(_ observe: AnyObserver<Any>?, error: Error?) {
        if let err = error {
            if let thread = observe {
                thread.onError(err)
            }
        }
    }
    
    func onError (_ single: ((SingleEvent<Any>) -> ())?, error: Error?) {
        if let err = error {
            if let thread = single {
                thread(.error(err))
            }
        }
    }
    
    
//    MARK: safety check
    
    func isEmpty(document: SingleDocument) -> Bool {
        return document == "" || document == nil
    }
    
    // will return false if at least single point of data will be empty.
    func isEmpty(argTrain: TraitList) -> Bool {
        if argTrain == nil {
            return true
        }
        let trait = argTrain?.first(where: { (trait) -> Bool in
            return trait.expectedValue == "" || trait.fieldName == ""
        })
        return trait != nil
    }
    
    func isEmpty(nestedCollection: NestedCollection) -> Bool {
        return nestedCollection == nil ||
            (nestedCollection?.collection == "" || nestedCollection?.document == "")
    }
    
    func isEmpty(collection: CollectionRef) -> Bool {
        return collection == ""
    }
    
    func isEmptyUpdateableData(data: UpdateableData) -> Bool {
        if data.0 == nil {
            return true
        }
        if let dict = data.1, dict.keys.count < 1 {
            return true
        }
        return false
    }
    
    func isEmpty(snapshotData: [String:Any]?) -> Bool {
        return snapshotData == nil
    }
    
    func isEmpty(snapshotDocs: [DocumentSnapshot]?) -> Bool {
        
        if (snapshotDocs?.count) ?? -1 >= 0 {
            return false
        } else {
            return true
        }
    }
    
    private func isEmpty(snapshotDoc: DocumentSnapshot) -> Bool {
        return isEmpty(snapshotData: snapshotDoc.data())
    }
}
