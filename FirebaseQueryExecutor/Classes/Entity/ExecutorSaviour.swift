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
import FirebaseFirestore

// Inspired by Rise Against - Saviour
typealias Validator = ExecutorSaviour

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
        
        guard self.isEmpty(document: docRef) == false else {
            throw ExecutorError.insufficientArguments(.insufficientArguments)
        }
        
        guard self.isEmpty(uploadData: data) == false else {
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
