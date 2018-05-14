# FirebaseQueryExecutor

[![CI Status](https://img.shields.io/travis/Pavel Mosunov/FirebaseQueryExecutor.svg?style=flat)](https://travis-ci.org/Pavel Mosunov/FirebaseQueryExecutor)
[![Version](https://img.shields.io/cocoapods/v/FirebaseQueryExecutor.svg?style=flat)](https://cocoapods.org/pods/FirebaseQueryExecutor)
[![License](https://img.shields.io/cocoapods/l/FirebaseQueryExecutor.svg?style=flat)](https://cocoapods.org/pods/FirebaseQueryExecutor)
[![Platform](https://img.shields.io/cocoapods/p/FirebaseQueryExecutor.svg?style=flat)](https://cocoapods.org/pods/FirebaseQueryExecutor)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

FirebaseQueryExecutor is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FirebaseQueryExecutor'
```

## Usage


Create File with enum confirms protocol QueryTargetProtocol
This will play role of your requests

Create Extension for your enum to implement query data type for a specific request.
```
import FirebaseQueryExecutor into a class.

create property of class QueryExecutor<Target>()
```

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
