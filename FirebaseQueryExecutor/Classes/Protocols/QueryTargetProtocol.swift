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

public protocol QueryTargetProtocol: QueryExecutorProtocol {
    
    // NOTE: collection define documents for search. Example: collection = "users"
    var collection: CollectionRef { get }
    
    // NOTE: to get single document
    var singleDocument: SingleDocument { get }
    
    // NOTE: fieldName is needed to filter data on DB. Actually it takes field name
    // Might be nil if we do not need query. Example: expectedValue = "Email"
    var params: TraitList { get }
    
    // NOTE: To update data on backend fill data dictionary for a specific case.
    // documentID is requeired for data
    var data: UpdateableData { get }
    
    // TODO: (pavel.mosunov) modify to use nested collections through nested documents in nested collections.
    // NOTE: Nested Collection define collection nested into the document
    var nestedCollection: NestedCollection { get }
    
    // NOTE: @param orPair - defines query condition for element
    // @param firstConstraint @param secondConstraint defines != condition which is equal to logical OR.
    // e.g. - constraint1.fieldName > constraint1.expectedValue + constraint2.fieldName < constraint1.expectedValue
    var orPair: ConditionPair { get }
    
    // NOTE: @param orderString - defines param in document we ordering by
    // @param isOrderSpecified - defines useage of next argument. On True isAscending will be taken into account
    // @param isAscending - defines order as Descending or Not.
    var order: OrderTrait { get }
}
