# Faberbabel

![](https://github.com/faberNovel/faberbabel-ios/workflows/CI/badge.svg)
[![Version](https://img.shields.io/cocoapods/v/Faberbabel.svg?style=flat)](https://cocoapods.org/pods/Faberbabel)
[![License](https://img.shields.io/cocoapods/l/Faberbabel.svg?style=flat)](https://cocoapods.org/pods/Faberbabel)
[![Platform](https://img.shields.io/cocoapods/p/Faberbabel.svg?style=flat)](https://cocoapods.org/pods/Faberbabel)

This library is an iOS SDK to update the app wording dynamically. The new wording is downloaded from a remote source and merged with the old one. The main advantage is to not redeploy the app to update the wording.

- [Features](#features)
- [Example](#example)
- [How to use](#how-to-use)
- [Requirements](#requirements)
- [Installation](#installation)
- [Communication](#communication)
- [Credits](#credits)
- [License](#license)

## Features

- [x] Update the app wording dynamically from a remote source
- [x] Avoid reploying the app
- [x] Localize a key with the updated wording
- [x] Log events when an error occurs (key missing / merge error)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## How to use

### Default setup

Setup the library with your credentials in the `AppDelegate.swift` for example.

```swift
Faberbabel.configure(
    projectId: "xxx-xxx-xxx",
    baseURL: URL(string: "https://xxx.com")!
)
```

If you are using extensions, you might want to share one wording for all of your targets. For this, add an `App Group Identifier` in the capabilities of your targets, then pass the identifier in the `configure` method:

```swift
Faberbabel.configure(
    projectId: "xxx-xxx-xxx",
    baseURL: URL(string: "https://xxx.com")!,
    appGroupIdentifier: "group.xxx.com"
)
```

### Custom setup

Instead of using the default `configure` method you can control all the dependencies:
- how the wording is fetched
- how error events are handled
- where the fetched wording is located

```swift
Faberbabel.configure(
    fetcher: MyCustomFetcher(),
    logger: MyCustomLogger(),
    localizableDirectoryUrl: myCustomLocation
)
```

#### Fetch wording from custom source

You can fetch the wording from a custom source. For this, create an object conforming to the `LocalizableFetcher` protocol:

```swift
class MyCustomFetcher: LocalizableFetcher {

    // MARK: - LocalizableFetcher

    func fetch(for lang: String,
               completion: @escaping (Result<Localizations, Error>) -> Void) {
        let result: Localizations = ["key": "value"]
        completion(result)
    }
}
```

#### Log events

When errors occur, events are created and sent to an `EventLogger`.

By default some loggers already exists:
- `ConsoleEventLogger` that prints events to the console
- `EmptyLogger` that does nothing
- `CompoundEventLogger` that aggregate multiple loggers

You can create your own event logger by conforming to the `EventLogger` protocol. For instance:

```swift
class RemoteEventLogger: EventLogger {

    // MARK: - EventLogger

    func log(_ events: [Event]) {
        // send events to remote server
    }
}
```

#### Localizable directory url

By default the new `Localizable.strings` downloaded from the remote source is stored either in the user library directory if no `appGroupIdentifier` is passed, either in the location in the file system of the app group's shared directory.

You can create your custom url and have full control of the location of the localizable directory.

### Update the wording

To fetch a new wording from the remote source, simply call the `updateWording` method like so:

```swift
let wordingRequest = UpdateWordingRequest(
    language: .languageCode("fr") , // Optional: Default is '.current'
    mergingOptions: [] // Optional: Default is []
    // If you want the merge to allow big changes in your wording such as a number of attributes mismatch,
    // you can for example use the following :
    // mergingOptions: [.allowRemoteEmptyString, .allowAttributeNumberMismatch]
)

Faberbabel.updateWording(
    request: wordingRequest,
    bundle: .main
) { result in
    switch result {
    case .success:
        // Update UI
    case let .failure(error):
        // Handle error
    }
}
```

### Localize a key with the updated wording

To get the localized version of a key, do not use `NSLocalizedString` that will only search for translations in the main bundle, but use the `fb_translation` method on `String`:

```swift
"key".fb_translation // returns the localized string in the current language
```

You can also fetch a translation for a specific language:

```swift
"key".fb_translate(to: "fr")
```

If a value is not found in specified language, the system will fallback to english.

## Requirements

- iOS 8.0+
- Swift 5.0

## Installation

Faberbabel is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Faberbabel'
```

## Communication

- If you **need help**, use [Twitter](https://twitter.com/Fabernovel).
- If you'd like to **ask a general question**, use [Twitter](https://www.fabernovel.com/).
- If you'd like to **apply for a job**, visit https://careers.fabernovel.com/.
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Credits

Faberbabel is owned and maintained by [Fabernovel](https://www.fabernovel.com/). You can follow us on Twitter at [@Fabernovel](https://twitter.com/FabernovelTech).

## License

Faberbabel is available under the MIT license. See the LICENSE file for more info.
