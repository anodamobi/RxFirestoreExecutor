## Requirements

xCode: 9.2
Swift: 4.0

## Installation

```ruby
pod 'RxFirestoreExecutor'
```

## Description

RxFirestoreExecutor is a MOYA style library that allows you to use Firebase/Firestore Query via Rx same as usual network request.
The usage is similar to MOYA, so you can access your firestore database same way as a network request via moya.

## Usage

Create enum confirms protocol QueryTargetProtocol
This will play role of your requests

``` Swift

enum QueryService {

case updateData(id: String)
}

extension QueryService: QueryTargetProtocol {
  //Only  collection is not optional.
  
  var collection: CollectionRef {
    switch self {
    case .updateData:
      return "myCollection"
    }
  }
  
  var singleDocument: SingleDocument {
    switch self {
      case .updateData(let id):
        return id
    }
  }
  
  // everything else should return nil if not used.
}
```

Create Extension for your enum to implement query data type for a specific request.
```
import RxFirestoreExecutor into a class.
import RxSwift

create property of class QueryExecutor<Target>()
```
Where Target: QueryTargetProtocol

User request for a single load and observe to create Firebase Listener for data observing and dynamic changing.
As an argument to your request/observe you will use a value from a target enum type
```
E.G. executor.request(.loadUser(userID))

executor.request(.updateData(id: uid))
            .mapTo(object: YourObject.self)
            .subscribe(onSuccess: { model in
              //Handle result
        })  { error in
                //Handle error
            }.disposed(by: bag)
```

Handle request/observe with RxSwift .subscribe/.observe

UPD: branche base-class (WIP) can simplify working with document.

Small how-to:
```
class Example: RxObject {
    dynamic var varableString: String = ""
    dynamic var variableFloat: Float = 0.0
    dynamic var varableInt: Int = 10
    dynamic var varableDouble: Double = 0.0
    
    required init() {
        super.init()
        collection = "firebase_collection"
    }
}
```
Beside this you can use other `RXObjects` as property.

```
class Example: RxObject {
    dynamic var varableString: String = ""
    dynamic var variableFloat: Float = 0.0
    dynamic var varableInt: Int = 10
    dynamic var varableDouble: Double = 0.0
    dynamic var nestedObject = NestedExample()
    
    required init() {
        super.init()
        collection = "firebase_collection"
    }
}

class NestedExample: RxObject {
    dynamic var varableString: String = ""
    dynamic var variableFloat: Float = 0.0
    dynamic var varableInt: Int = 10
    dynamic var varableDouble: Double = 0.0
    
    required init() {
        //in this case, collection property can be empty.
        super.init()
    }
}
```
So last thing left is to read/write or listen to objectes stored on Firebase.

```
    let item = Example()
    item.push()
    
    item.pull()
    
    item.(updated: {
        // observed udates
    }) { (error) in
        //handle errors.
    }
    
    item.delete { (error) in
        //handle error
    }
```
Updated closure and Error closure are available at pull/push options as well.

That's all! You do not need to unsubscribe from Firebase Listener on executor's observe - on object death it will be
removed automatically.


## Author

Pavel Mosunov, pavel.mosunov@anoda.mobi

## License

RxFirestoreExecutor is available under the MIT license. See the LICENSE file for more info.
