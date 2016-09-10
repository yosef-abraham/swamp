[![Version](https://img.shields.io/cocoapods/v/Swamp.svg?style=flat)](http://cocoapods.org/pods/Swamp)
[![License](https://img.shields.io/cocoapods/l/Swamp.svg?style=flat)](http://cocoapods.org/pods/Swamp)
[![Platform](https://img.shields.io/cocoapods/p/Swamp.svg?style=flat)](http://cocoapods.org/pods/Swamp)
## Swamp - Swift WAMP implementation

Swamp is a WAMP implementation in Swift.

It currently supports calling remote procedures, subscribing on topics, and publishing events. It also supports authentication using ticket & wampcra authentication.

Swamp `0.1.0` utilizes WebSockets as its only available transport, and JSON as its serialization method.

Contributions to support MessagePack & Raw Sockets will be merged gladly!

## Requirements
iOS 8.0 or OSX 10.9

## Installation
Swamp is available through cocoapods. Add

```ruby
pod "Swamp"
```

to your Podfile.

## Usage
#### Connect to router

```swift
import Swamp

let swampTransport = WebSocketSwampTransport(wsEndpoint:  NSURL(string: "ws://my-router.com:8080/ws")!)
let swampSession = SwampSession(realm: "router-defined-realm", transport: swampTransport)
// Set delegate for callbacks
// swampSession.delegate = <SwampSessionDelegate implementation>
swampSession.connect()
swampSession.disconnect()
```
##### SwampSession constructor parameters
* `realm` - which realm to join
* `transport` - a `SwampTransport` implementation
* `authmethods` `authid` `authrole` `authextra` - See your router's documentation and use accordingly

##### Connection/Disconnection
* `connect()` - Establish transport and perform authentication if configured.
* `disconnect()` - Opposite.

Now you should wait for your delegate's callbacks:

##### SwampSessionDelegate interface
Implement the following methods:

* `func swampSessionHandleChallenge(authMethod: String, extra: [String: AnyObject]) -> String`
  * Fired when a challenge request arrives.
  * You can `return SwampCraAuthHelper.sign("your-secret", extra["challenge"] as! String)` to support `wampcra` auth method.
* `func swampSessionConnected(session: SwampSession, sessionId: Int)`
 * Fired once the session has established and authenticated a session, and has joined the realm successfully. (AKA You may now call, subscribe & publish.)
* `func swampSessionEnded(reason: String)`
 * Fired once the connection has ended. 
 * `reason` is usually a WAMP-domain error, but it can also be a textual description of WTF just happened 

#### Let's get the shit started!
* **General note: Lots of callback functions receive args-kwargs pairs, check your other client implementaion to see which of them is utilized, and act accordingly.**

##### Calling remote procedures
Calling may fire two callbacks:

* `onSuccess` - if calling has completed without errors.
* `onError` - If the call has failed. (Either in router or in peer client.)

###### Signature
```swift
public func call(proc: String, options: [String: AnyObject]=[:], args: [AnyObject]?=nil, kwargs: [String: AnyObject]?=nil, onSuccess: CallCallback, onError: ErrorCallCallback)
```

###### Simple use case:
```swift
session.call("wamp.procedure", args: [1, "argument1"],
    onSuccess: { details, results, kwResults in
        // Usually result is in results[0], but do a manual check in your infrastructure
    },
    onError: { details, error, args, kwargs in
        // Handle your error here (You can ignore args kwargs in most cases)
    })
```

###### Full use case:
```swift
session.call("wamp.procedure", options: ["disclose_me": true], args: [1, "argument1"], kwargs: ["arg1": 1, "arg2": "argument2"], 
    onSuccess: { details, results, kwResults in
        // Usually result is in results[0], but do a manual check in your infrastructure
    },
    onError: { details, error, args, kwargs in
        // Handle your error here (You can ignore args kwargs in most cases)
    })
```

##### Subscribing on topics
Subscribing may fire three callbacks:

* `onSuccess` - if subscription has succeeded.
* `onError` - if it has not.
* `onFire` - if it succeeded, this is fired when the actual event was published.

###### Signature
```swift
public func subscribe(topic: String, options: [String: AnyObject]=[:], onSuccess: SubscribeCallback, onError: ErrorSubscribeCallback, onEvent: EventCallback)
```

###### Simple use case:
```swift
session.subscribe("wamp.topic", onSuccess: { subscription in 
    // subscription can be stored for subscription.cancel()
    }, onError: { details, error in
                                
    }, onEvent: { details, results, kwResults in
        // Event data is usually in results, but manually check blabla yadayada
    })
```

###### Full use case:
```swift
session.subscribe("wamp.topic", options: ["disclose_me": true], 
    onSuccess: { subscription in 
        // subscription can be stored for subscription.cancel()
    }, onError: { details, error in
        // handle error                        
    }, onEvent: { details, results, kwResults in
        // Event data is usually in results, but manually check blabla yadayada
    })
```

##### Publishing events
Publishing may either be called without callbacks (AKA unacknowledged) or with the following two callbacks:

* `onSuccess` - if publishing has succeeded.
* `onError` - if it has not.

###### Signature
```swift
// without acknowledging
public func publish(topic: String, options: [String: AnyObject]=[:], args: [AnyObject]?=nil, kwargs: [String: AnyObject]?=nil)
// with acknowledging
public func publish(topic: String, options: [String: AnyObject]=[:], args: [AnyObject]?=nil, kwargs: [String: AnyObject]?=nil, onSuccess: PublishCallback, onError: ErrorPublishCallback) {
```

###### Simple use case:
```swift
session.publish("wamp.topic", args: [1, "argument2"])
```
###### Full use case:
```swift
session.publish("wamp.topic", options: ["disclose_me": true],  args: [1, "argument2"], kwargs: ["arg1": 1, "arg2": "argument2"],
    onSuccess: {
        // Publication has been published!
    }, onError: { details, error in
        // Handle error (What can it be except wamp.error.not_authorized?)
    })
```

## Testing
For now, only integration tests against crossbar exist. I plan to add unit tests in the future.

In order to run the tests:

1. Install [Docker for Mac](https://docs.docker.com/engine/installation/mac/) (Easy Peasy)
2. Open `Example/Swamp.xcworkspace` with XCode
3. Select `Swamp_Test-iOS` or `Swamp_Test-OSX`
4. Run the tests! (`Product -> Test` or ⌘U)

### Troubleshooting
If for some reason the tests fail, make sure:

* You have docker installed and available at `/usr/local/bin/docker`
* You have an available port 8080 on your machine

You can also inspect `Example/swamp-crossbar-instance.log` to find out what happened with the crossbar instance while the tests were executing.

## Roadmap
1. MessagePack & Raw Sockets
2. Callee role
3. More robust codebase and error handling
4. More generic and comfortable API
5. Advanced profile features

## Authors

- Yossi Abraham, yo.ab@outlook.com.
- You?

## License

I don't care, MIT because it's `pod lib create` default and I'm too lazy to [tldrlegal](https://tldrlegal.com).
