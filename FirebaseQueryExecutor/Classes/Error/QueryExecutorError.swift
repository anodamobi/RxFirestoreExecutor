//
//  QueryExecutorError.swift
//  PranaHeart
//
//  Created by Pavel Mosunov on 4/4/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation

public enum ErrorStrings: String {
    case insufficientArguments = "Insufficien Arguments in call methods. ExecutorError: 0"
    case emptyOrNilParametr = "Nil or Empty parametr disallowed. ExecutorError: 1"
    case emptyDataSet = "Data set is empty. ExecutorError: 2"
    case emptyKeyValue = "Sent parametr or Object ID is empty. ExecutorError: 3"
    
    case emptySnapshotData = "Snapshot data is empty! ExecutorError: 5"
}

public enum ExecutorError: Error {
    case insufficientArguments(ErrorStrings)
    case emptyOrNilParametr(ErrorStrings)
    case emptyDataSet(ErrorStrings)
    case emptyKeyValue(ErrorStrings)
    
    case emptySnapshotData(ErrorStrings)
    
    case undefined
}

extension ExecutorError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .emptyDataSet(let empty): return empty.rawValue
        case .emptyKeyValue(let keyValue): return keyValue.rawValue
        case .emptyOrNilParametr(let nilParam): return nilParam.rawValue
        case .insufficientArguments(let insufParams): return insufParams.rawValue
            
        case .emptySnapshotData(let emptyData): return emptyData.rawValue
        default:
            return "Undefined error!"
        }
    }
}
