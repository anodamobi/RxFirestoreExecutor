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

import UIKit
import RxFirestoreExecutor
import RxSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let executor = QueryExecutor<Target>()
    let bag = DisposeBag()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        executor.request(.test).subscribe(onSuccess: { (_) in
        }) { (error) in

            if let err = error as? ExecutorError {
                switch err {
                case .emptyDataSet:
                    break
                default:
                    break
                }
            }
            print(error)
        }.disposed(by: bag)
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
