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
import RxSwift
import SwiftyJSON
import FirebaseFirestore

class ExecutorObserveable: ExecutorFirestoreEntity {
    
    let validator: Validator = Validator()
    
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
    
    func observeCollection() -> Observable<Any> {
        return Observable.create({ (observe) in
            
            do {
                try self.validator.saveSingle(collection: self.collectionString ?? "")
            } catch {
                observe.onError(error)
                return Disposables.create()
            }
            
            
            let colRef = self.db.collection(self.collectionString!)
            let listener = colRef.addSnapshotListener({ [weak self] (snapshot, error) in
                self?.onError(observe, error: error)
                
                do {
                    try self?.validator.saveSnapshotDocuments(documents: snapshot?.documents)
                } catch {
                    self?.onError(observe, error: error)
                    return
                }
                
                if let objects = snapshot?.documents.map({ (obj) -> [String:Any] in
                    return self?.composeObject(document: obj) ?? [:]
                }) {
                    observe.onNext(objects)
                }
            })
            return Disposables.create {
                listener.remove()
            }
        })
    }
    
    func observeSingleDoc(documentID: String) -> Observable<Any> {
        return Observable.create({ (observe) in
            
            let collection = self.collectionString
            do {
                try self.validator.saveSingleDoc(collection: collection, singleDoc: documentID)
            } catch {
                observe.onError(error)
                return Disposables.create()
            }
            
            
            let colRef = self.db.collection(collection ?? "").document(documentID)
            
            let listener = colRef.addSnapshotListener({ [weak self] (snapshot, error) in
                self?.onError(observe, error: error)
                
                do {
                    try self?.validator.saveSnapshotData(snapshot: snapshot)
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
    
    func observeDoc(argTrain: TraitList) -> Observable<Any> {
        return Observable.create({ (observe) -> Disposable in
            
            let collection = self.collectionString
            do {
                try self.validator.saveArgTrain(traitList: argTrain, collection: collection)
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
                    try self?.validator.saveSnapshotDocuments(documents: snapshot?.documents)
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
        return Observable.create({ (observe) in
            let collection = self.collectionString
            do {
                try self.validator.saveNested(collection: collection, parentDoc: documentID, nestedCollection: nestedCollection)
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
    
//    MARK: self-observing methods
    
    func observeSingle(documentID: String, collection: String) -> Observable<[String: Any]> {
        return Observable.create({ (observe) in
            
            let collection = self.collectionString
            do {
                try self.validator.saveSingleDoc(collection: collection, singleDoc: documentID)
            } catch {
                observe.onError(error)
                return Disposables.create()
            }
            
            
            let colRef = self.db.collection(collection ?? "").document(documentID)
            
            let listener = colRef.addSnapshotListener({ [weak self] (snapshot, error) in
                
                if let err = error {
                    observe.onError(err)
                }
                
                do {
                    try self?.validator.saveSnapshotData(snapshot: snapshot)
                } catch {
                    observe.onError(error)
                    return
                }
                
                if var object: [String:Any] = snapshot?.data() {
                    object["itemID"] =  snapshot?.documentID
                    observe.onNext(object)
                }
                
            })
            return Disposables.create {
                listener.remove()
            }
        })
    }
}
