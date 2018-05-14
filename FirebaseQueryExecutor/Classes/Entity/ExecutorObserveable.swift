//
//  Observeable.swift
//  PranaHeart
//
//  Created by Pavel Mosunov on 4/3/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import FirebaseFirestore

class ExecutorObserveable: ExecutorFirestoreEntity {
    
    let savior: Savior = Savior()
    
    override init() {
        super.init()
    }
    
    func observableSubscription(_ singleDoc: SingleDocument = nil,
                                _ argTrain: TraitList = nil,
                                _ nestedCollection: NestedCollection = nil) -> Observable<Any> {
        
        if let docID = singleDoc {
            return observeSingleDoc(documentID: docID)
        }
        if let traits = nestedCollection {
            return observeNestedCollection(documentID: traits.document,
                                           nestedCollection: traits.collection)
        }
        if argTrain != nil {
            return observeDoc(argTrain: argTrain)
        }
        return observeCollection()
        
    }
    
    private func observeCollection() -> Observable<Any> {
        return Observable.create({ [unowned self] (observe) in
            
            do {
                try self.savior.saveSingle(collection: self.collectionString ?? "")
            } catch {
                observe.onError(error)
                return Disposables.create()
            }
            
            
            let colRef = self.db.collection(self.collectionString!)
            let listener = colRef.addSnapshotListener({ [weak self] (snapshot, error) in
                self?.onError(observe, error: error)
                
                do {
                    try self?.savior.saveSnapshotDocuments(documents: snapshot?.documents)
                } catch {
                    self?.onError(observe, error: error)
                    return
                }
                
                if let objects = snapshot?.documents.map({ (obj) -> JSON in
                    return JSON(self?.composeObject(document: obj) ?? [:])
                }) {
                    observe.onNext(objects)
                }
            })
            
            return Disposables.create {
                listener.remove()
            }
        })
    }
    
    private func observeSingleDoc(documentID: String) -> Observable<Any> {
        
        return Observable.create({ [unowned self] (observe) in

            let collection = self.collectionString
            do {
                try self.savior.saveSingleDoc(collection: collection, singleDoc: documentID)
            } catch {
                observe.onError(error)
                return Disposables.create()
            }
            
            
            let colRef = self.db.collection(collection ?? "").document(documentID)
            
            let listener = colRef.addSnapshotListener({ [weak self] (snapshot, error) in
                self?.onError(observe, error: error)
                
                do {
                    try self?.savior.saveSnapshotData(snapshot: snapshot)
                } catch {
                    self?.onError(observe, error: error)
                    return
                }
                
                if var object: [String:Any] = snapshot?.data() {
                    object["uid"] = snapshot?.documentID
                    object["id"] =  snapshot?.documentID
                    observe.onNext(object)
                }
                
            })
            
            return Disposables.create {
                listener.remove()
            }
        })
    }
    
    private func observeDoc(argTrain: TraitList) -> Observable<Any> {
        
        return Observable.create({ [unowned self] (observe) -> Disposable in
            
            let collection = self.collectionString
            do {
                try self.savior.saveArgTrain(traitList: argTrain, collection: collection)
            } catch {
                observe.onError(error)
                return Disposables.create()
            }
            
            let colRef = self.db.collection(collection ?? "")
            var query = colRef.whereField((argTrain?.first?.0) ?? "", isEqualTo: (argTrain?.first?.1) ?? "")
            
            self.create(query: &query, argTrain: argTrain)
            self.orderQuery(&query)
            
            let listener = query.addSnapshotListener({ [weak self] (snapshot, error) in
                self?.onError(observe, error: error)
                
                do {
                    try self?.savior.saveSnapshotDocuments(documents: snapshot?.documents)
                } catch {
                    self?.onError(observe, error: error)
                    return
                }
                
                var objects: [[String: Any]]?
                if ExecutorSettings.shared.shouldObserveOnlyDiffs {
                    objects = self?.singleDiffs(snapshot: snapshot)
                } else {
                    objects = self?.allDocuments(snapshot: snapshot)
                }
                
                observe.onNext(objects as Any)
            })
            
            return Disposables.create {
                listener.remove()
            }
        })
    }
    
    private func singleDiffs(snapshot: QuerySnapshot?) -> [[String: Any]]? {
        return snapshot?.documentChanges.map({ (diff) -> [String: Any] in
            return self.composeObject(document: diff.document)
        })
    }
    
    private func allDocuments(snapshot: QuerySnapshot?) -> [[String: Any]]? {
        return snapshot?.documents.map({ (doc) -> [String:Any] in
            return self.composeObject(document: doc)
        })
    }
    
    
    private func observeNestedCollection(documentID: String, nestedCollection:String) -> Observable<Any> {
        return Observable.create({ [unowned self] (observe) in
            
            let collection = self.collectionString
            do {
                try self.savior.saveNested(collection: collection, parentDoc: documentID, nestedCollection: nestedCollection)
            } catch {
                observe.onError(error)
                return Disposables.create()
            }
            
            let colRef = self.db.collection(collection ?? "").document(documentID).collection(nestedCollection)
            
            let listener = colRef.addSnapshotListener({ [weak self] (snapshot, error) in
                self?.onError(observe, error: error)
                
                let objects = snapshot?.documentChanges.map({ (diff) -> [String: Any] in
                    
                    return self?.composeObject(document: diff.document) ?? [:]
                })
                
                observe.onNext(objects as Any)
            })
            
            return Disposables.create {
                listener.remove()
            }
        })
    }
}
