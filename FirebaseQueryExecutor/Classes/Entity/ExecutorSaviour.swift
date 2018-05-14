//
//  ExecutorSaviour.swift
//  BoringSSL
//
//  Created by Pavel Mosunov on 5/14/18.
//

import Foundation
import RxSwift
import FirebaseFirestore

// Inspired by Rise Against - Saviour
typealias Savior = ExecutorSaviour

class ExecutorSaviour: ExecutorFirestoreEntity {
    
    func saveSingle(collection: String?) throws {
        guard !(collection?.isEmpty ?? false) else {
            throw ExecutorError.emptyOrNilParametr(ErrorStrings.emptyOrNilParametr)
        }
    }
    
    func saveQuery(filterParams:(field: String, value: String), collection: String?) throws {
        
        do {
            try self.saveSingle(collection: collection)
        }
        guard self.isEmpty(document: filterParams.field) == false else {
            throw ExecutorError.emptyKeyValue(.emptyKeyValue)
        }
        guard self.isEmpty(document: filterParams.value) == false else {
            throw ExecutorError.emptyKeyValue(.emptyKeyValue)
        }
    }
    
    
    func saveSingleDoc(collection: String?, singleDoc: SingleDocument) throws {
        do {
            try self.saveSingle(collection: collection)
        }
        guard self.isEmpty(document: singleDoc) == false else {
            throw ExecutorError.emptyOrNilParametr(.emptyOrNilParametr)
        }
    }
    
    func saveArgTrain(traitList: TraitList, collection: String?) throws {
        
        do {
            try self.saveSingle(collection: collection)
        }
        
        guard traitList != nil else {
            throw ExecutorError.emptyOrNilParametr(.emptyOrNilParametr)
        }
        
        guard self.isEmpty(argTrain: traitList) == false else {
            throw ExecutorError.insufficientArguments(.insufficientArguments)
        }
    }
    
    func saveUploadData(data: [String: Any]?, docRef: SingleDocument, collection: String?) throws {
        do {
            try self.saveSingle(collection: collection)
        }
        
        guard self.isEmpty(document: docRef) else {
            throw ExecutorError.insufficientArguments(.insufficientArguments)
        }
        
        guard self.isEmpty(uploadData: data) else {
            throw ExecutorError.insufficientArguments(.insufficientArguments)
        }
        
        guard let keys = data?.keys, keys.first(where: { (string) -> Bool in
            return string == ""
        }) == nil else {
            throw ExecutorError.emptyDataSet(.emptyDataSet)
        }
    }
    
    func saveNested(collection: String?, parentDoc: SingleDocument, nestedCollection: CollectionRef) throws {
        do {
            try self.saveSingleDoc(collection: collection, singleDoc: parentDoc)
        }
        
        do {
            try self.saveSingle(collection: nestedCollection)
        }
    }
    
    func saveSnapshotData(snapshot: DocumentSnapshot?) throws {
        guard self.isEmpty(snapshotData: snapshot?.data()) == false else {
            throw ExecutorError.emptySnapshotData(.emptySnapshotData)
        }
    }
    
    func saveSnapshotDocuments(documents: [DocumentSnapshot]?) throws {
        guard self.isEmpty(snapshotDocs: documents) == false else {
            throw ExecutorError.emptySnapshotData(.emptySnapshotData)
        }
    }
}
