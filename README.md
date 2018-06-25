## Requirements

xCode: 9.2
Swift: 4.0

## Installation

FirebaseQueryExecutor is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RxFirestoreExecutor'
```

## Usage


Create enum confirms protocol QueryTargetProtocol
This will play role of your requests

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
```

Handle request/observe with RxSwift .subscribe/.observe

That's all! You do not need to unsubscribe from Firebase Listener on executor's observe - on object death it will be
removed automatically.


## Author

Pavel Mosunov, pavel.mosunov@anoda.mobi

## License

FirebaseQueryExecutor is available under the MIT license. See the LICENSE file for more info.
