//
//  PranaSingle.swift
//  PranaHeart
//
//  Created by Pavel Mosunov on 4/3/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseFirestore.FIRSetOptions
import FirebaseFirestore.FIRQuerySnapshot
import FirebaseFirestore.FIRDocumentReference
import SwiftyJSON

class ExecutorSingle: ExecutorFirestoreEntity {
    
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
        return Single.create(subscribe: { [unowned self] (single) in
            
            guard let collection = self.collectionString, !collection.isEmpty else {
                single(.error(ExecutorError.emptyOrNilParametr(ErrorStrings.emptyOrNilParametr)))
                return Disposables.create()
            }
            
            let colRef = self.db.collection(collection)
            colRef.getDocuments(completion: { [weak self] (snapshot, error) in
                self?.onError(single, error: error)
                
                guard !((self?.isEmpty(snapshotDocs: snapshot?.documents)) ?? true) else {
                    self?.onError(single, error: ExecutorError.emptySnapshotData(.emptySnapshotData))
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
        return Single.create(subscribe: { [unowned self] (single) in
            
            guard self.isEmpty(document: queryFilter) == false else {
                single(.error(ExecutorError.emptyKeyValue(ErrorStrings.emptyKeyValue)))
                return Disposables.create()
            }
            
            guard self.isEmpty(document: param) == false else {
                single(.error(ExecutorError.emptyKeyValue(ErrorStrings.emptyKeyValue)))
                return Disposables.create()
            }
            
            guard let collection = self.collectionString, !collection.isEmpty else {
                single(.error(ExecutorError.emptyOrNilParametr(ErrorStrings.emptyOrNilParametr)))
                return Disposables.create()
            }
            
            let colRef = self.db.collection(collection)
            colRef.whereField(queryFilter, isEqualTo:param)
                .getDocuments(completion: { [weak self] (snapshot, error) in
                    self?.onError(single, error: error)
                    
                    guard !((self?.isEmpty(snapshotDocs: snapshot?.documents)) ?? true) else {
                        self?.onError(single, error: ExecutorError.emptySnapshotData(.emptySnapshotData))
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
    
    private func load(singleDoc: String) -> Single<Any> {
        return Single.create(subscribe: { [unowned self] (single) in
            
            guard let collection = self.collectionString, !collection.isEmpty else {
                single(.error(ExecutorError.emptyOrNilParametr(ErrorStrings.emptyOrNilParametr)))
                return Disposables.create()
            }
            
            guard singleDoc != "" else {
                single(.error(ExecutorError.emptyOrNilParametr(ErrorStrings.emptyOrNilParametr)))
                return Disposables.create()
            }
            
            let colRef = self.db.collection(collection)
            colRef.document(singleDoc).getDocument(completion: { [weak self] (snapshot, error) in
                self?.onError(single, error: error)
                
                guard !((self?.isEmpty(snapshotData: snapshot?.data())) ?? true) else {
                    self?.onError(single, error: ExecutorError.emptySnapshotData(.emptySnapshotData))
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
        
        return Single.create(subscribe: { [unowned self] (single) in
            
            guard let collection = self.collectionString, !collection.isEmpty else {
                single(.error(ExecutorError.emptyOrNilParametr(ErrorStrings.emptyOrNilParametr)))
                return Disposables.create()
            }
            
            let colRef = self.db.collection(collection)
            
            guard argTrain.count < 1 else {
                single(.error(ExecutorError.emptyOrNilParametr(ErrorStrings.emptyOrNilParametr)))
                return Disposables.create()
            }
            
            var query = colRef.whereField((argTrain.first?.0)!, isEqualTo: (argTrain.first?.1)!)
            
            self.create(query: &query, argTrain: argTrain)
            self.orderQuery(&query)
            
            query.getDocuments(completion: { [weak self] (snapshot, error) in
                self?.onError(single, error: error)
                
                guard !((self?.isEmpty(snapshotDocs: snapshot?.documents)) ?? true) else {
                    self?.onError(single, error: ExecutorError.emptySnapshotData(.emptySnapshotData))
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
        return Single.create(subscribe: { [unowned self] (single) in
            
            guard let collection = self.collectionString, !collection.isEmpty else {
                single(.error(ExecutorError.emptyOrNilParametr(ErrorStrings.emptyOrNilParametr)))
                return Disposables.create()
            }
            
            guard docID != nil else {
                single(.error(ExecutorError.insufficientArguments(ErrorStrings.insufficientArguments)))
                return Disposables.create()
            }
            
            guard self.isEmpty(document: docID) == false else {
                single(.error(ExecutorError.emptyKeyValue(ErrorStrings.emptyKeyValue)))
                return Disposables.create()
            }
            
            // checking key is not empty, value will always be true or false
            guard let keys = dataDict?.keys, keys.first(where: { (string) -> Bool in
                return string == ""
            }) == nil else {
                single(.error(ExecutorError.emptyDataSet(ErrorStrings.emptyDataSet)))
                return Disposables.create()
            }
            
            let docRef = self.db.collection(collection).document(docID!)
            docRef.setData(dataDict!, options: .merge(), completion: { [weak self] (error) in
                self?.onError(single, error: error)
                
                single(.success(true))
            })
            
            return Disposables.create()
        })
    }
    
    
    
}
