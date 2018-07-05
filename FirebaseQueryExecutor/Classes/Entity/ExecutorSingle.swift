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
import FirebaseFirestore.FIRSetOptions
import FirebaseFirestore.FIRQuerySnapshot
import FirebaseFirestore.FIRDocumentReference
import SwiftyJSON

class ExecutorSingle: ExecutorFirestoreEntity {
    
    let validator: Validator = Validator()
    
    override init() {
        super.init()
    }
    
    func singleTrait(_ singleDocument: SingleDocument = nil,
                     _ params: TraitList = nil,
                     _ data: UpdateableData = (nil,nil),
                     _ nestedCollection: NestedCollection = nil,
                     _ orParam: ConditionPair = nil) -> Single<Any> {
        
        if let traitList = params, traitList.count == 1 {
            
            return load(queryFilter: traitList.first!.0, param: traitList.first!.1)
        }
        else if singleDocument != nil {
            
            return load(singleDoc: singleDocument!)
        } else if let argArray = params, argArray.count > 1 {
            
            return load(argTrain: argArray)
        } else if (data.1 != nil) {
            return updateDocument(dataDict: data.1, docID: data.0)
        }
        return loadCollection()
    }
    
    
    private func loadCollection() -> Single<Any> {
            return Single.create(subscribe: { (single) in
                
                let collection = self.collectionString
                do {
                    try self.validator.saveSingle(collection: collection)
                } catch {
                    single(.error(error))
                    return Disposables.create()
                }
                
                
                let colRef = self.db.collection(collection ?? "")
                colRef.getDocuments(completion: { [weak self] (snapshot, error) in
                    self?.onError(single, error: error)
                    
                    do {
                        try self?.validator.saveSnapshotDocuments(documents: snapshot?.documents)
                    } catch {
                        self?.onError(single, error: error)
                        return
                    }
                    
                    if let objects = snapshot?.documents.map({ (single) -> JSON in
                        return JSON(self?.composeObject(document: single) ?? [:])
                    }) {
                        single(.success(objects))
                    }
                })
                
                return Disposables.create()
            })
    }
    
    private func load(queryFilter: String, param: String) -> Single<Any> {
            return Single.create(subscribe: { (single) in
                
                let collection = self.collectionString
                do {
                    try self.validator.saveQuery(filterParams: (queryFilter, param), collection: collection)
                } catch {
                    single(.error(error))
                    return Disposables.create()
                }
                
                
                let colRef = self.db.collection(collection ?? "")
                colRef.whereField(queryFilter, isEqualTo:param)
                    .getDocuments(completion: { [weak self] (snapshot, error) in
                        self?.onError(single, error: error)
                        
                        do {
                            try self?.validator.saveSnapshotDocuments(documents: snapshot?.documents)
                        } catch {
                            self?.onError(single, error: error)
                            return
                        }
                        
                        if let objects = snapshot?.documents.map({ (single) -> [String: Any] in
                            return self?.composeObject(document: single) ?? [:]
                        }) {
                            single(.success(objects))
                        }
                    })
                return Disposables.create()
        })
    }
    
    func load(singleDoc: String) -> Single<Any> {
            return Single.create(subscribe: { (single) in
                
                let collection = self.collectionString
                
                do {
                    try self.validator.saveSingleDoc(collection: collection, singleDoc: singleDoc)
                } catch {
                    single(.error(error))
                    return Disposables.create()
                }
                
                let colRef = self.db.collection(collection ?? "")
                colRef.document(singleDoc).getDocument(completion: { [weak self] (snapshot, error) in
                    self?.onError(single, error: error)
                    
                    do {
                        try self?.validator.saveSnapshotData(snapshot: snapshot)
                    } catch {
                        self?.onError(single, error: error)
                        return
                    }
                    
                    if var object: [String:Any] = snapshot?.data() {
                        
                        object["uid"] = snapshot?.documentID
                        object["id"] =  snapshot?.documentID
                        return single(.success(object))
                    }
                })
                return Disposables.create()
            })
    }
    
    private func load(argTrain: [(String, String)]) -> Single<Any> {
            return Single.create(subscribe: { (single) in
                let collection = self.collectionString
                
                do {
                    try self.validator.saveArgTrain(traitList: argTrain, collection: collection)
                } catch {
                    single(.error(error))
                    return Disposables.create()
                }
                
                
                let colRef = self.db.collection(collection ?? "")
                var query = colRef.whereField((argTrain.first?.0)!, isEqualTo: (argTrain.first?.1)!)
                
                self.create(query: &query, argTrain: argTrain)
                self.orderQuery(&query)
                
                query.getDocuments(completion: { [weak self] (snapshot, error) in
                    self?.onError(single, error: error)
                    
                    do {
                        try self?.validator.saveSnapshotDocuments(documents: snapshot?.documents)
                    } catch {
                        self?.onError(single, error: error)
                        return
                    }
                    
                    if let objects = snapshot?.documents.map({ (document) -> JSON in
                        return JSON(self?.composeObject(document: document) ?? [:])
                    }) {
                        single(.success(objects))
                    }
                })
                return Disposables.create()
            })
    }
    
    private func updateDocument(dataDict: [String: Any]?, docID: String?) -> Single<Any> {
            return Single.create(subscribe: { (single) in
                
                let collection = self.collectionString
                do {
                    try self.validator.saveUploadData(data: dataDict, docRef: docID, collection: collection)
                } catch {
                    single(.error(error))
                    return Disposables.create()
                }
                
                
                let docRef = self.db.collection(collection ?? "").document(docID ?? "")
                docRef.setData(dataDict ?? [:], options: .merge(), completion: { [weak self] (error) in
                    self?.onError(single, error: error)
                    
                    single(.success(true))
                })
                
                return Disposables.create()
            })
    }
    
    
    //TODO: Pavel: Prichesat' proverit'
    func pushObject(col: String, docID: String, data: [String: Any]) -> Single<Any> {
        
        return Single.create(subscribe: { (single) in
            
            if !docID.isEmpty {
                
                let docRef = self.db.collection(col).document(docID)
                docRef.setData(data, completion: { [weak self] (error) in
                    self?.onError(single, error: error)
                    
                    single(.success(docID))
                })
            } else {
                
               let id = self.db.collection(col).addDocument(data: data, completion: { (error) in
//                    if error == nil {
//                        single(.success(true))
//                    } else {
                        if let err = error {
                            single(.error(err))
                        }
//                    }
                }).documentID
                if !id.isEmpty {
                    single(.success(id))
                }
            }
            
            return Disposables.create()
        })
    }
}
