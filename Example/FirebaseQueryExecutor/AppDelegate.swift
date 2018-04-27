//
//  AppDelegate.swift
//  FirebaseQueryExecutor
//
//  Created by Pavel Mosunov on 04/27/2018.
//  Copyright (c) 2018 Pavel Mosunov. All rights reserved.
//

import UIKit
import FirebaseQueryExecutor



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var executor = QueryExecutor<Target>()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        executor.request(.test)
        return true
    }



}

enum Target {
    case test
}

extension Target: QueryTargetProtocol {
    var collection: CollectionRef {
        return "collection"
    }
    
    var singleDocument: SingleDocument {
        return nil
    }
    
    var params: TraitList {
        return nil
    }
    
    var data: UpdateableData {
        return (nil, nil)
    }
    
    var nestedCollection: NestedCollection {
        return nil
    }
    
    var orPair: ConditionPair {
        return nil
    }
    
    var order: OrderTrait {
        return nil
    }
    
    
}
