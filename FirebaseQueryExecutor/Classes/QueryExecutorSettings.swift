//
//  QueryExecutorSettings.swift
//  BoringSSL
//
//  Created by Pavel Mosunov on 5/4/18.
//

import Foundation

//NOTE: to simplify calls
typealias ExecutorSettings = QueryExecutorSettings

public class QueryExecutorSettings {
    static let shared: QueryExecutorSettings = QueryExecutorSettings()
    
    //NOTE: Set this to false to reload all documents on doc changes. Call this on app start.
    var shouldObserveOnlyDiffs: Bool = true
}
