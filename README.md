[![Version](https://img.shields.io/cocoapods/v/Swamp.svg?style=flat)](http://cocoapods.org/pods/Swamp)
[![License](https://img.shields.io/cocoapods/l/Swamp.svg?style=flat)](http://cocoapods.org/pods/Swamp)
[![Platform](https://img.shields.io/cocoapods/p/Swamp.svg?style=flat)](http://cocoapods.org/pods/Swamp)
## Swamp - Swift WAMP implementation

Swamp is a WAMP implementation in Swift.

It currently supports calling remote procedures, subscribing on topics, and publishing events. It also supports challenge-response authentication using tickets & CRA authentication.

Swamp `0.1.0` utilizes WebSockets as it's only available transport, and JSON as it's serialization method.

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
Will be documented soon, check the [CrossbarIntegrationTests.swift](Example/Tests/CrossbarIntegrationTests.swift) file you lazy dog.

## Testing
For now, only integration tests against crossbar exists. I am planning to add unit tests in the future.

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
