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
