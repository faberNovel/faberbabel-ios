# Faberbabel

![](https://github.com/faberNovel/faberbabel-ios/workflows/CI/badge.svg)
[![Version](https://img.shields.io/cocoapods/v/Faberbabel.svg?style=flat)](https://cocoapods.org/pods/Faberbabel)
[![License](https://img.shields.io/cocoapods/l/Faberbabel.svg?style=flat)](https://cocoapods.org/pods/Faberbabel)
[![Platform](https://img.shields.io/cocoapods/p/Faberbabel.svg?style=flat)](https://cocoapods.org/pods/Faberbabel)

This library is an iOS SDK to easily implement Faberbabel in you app. Faberbabel helps you deploy a new wording remotely into you apps.

- [Features](#features)
- [Example](#example)
- [How to use](#how-to-use)
- [Requirements](#requirements)
- [Installation](#installation)
- [Communication](#communication)
- [Credits](#credits)
- [License](#license)

## Features

- [x] Update the app wording remotely
- [x] Localize a key with the updated wording
- [x] Notify the back when an error occurs (key missing / merge error)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## How to use 

### Setup

Setup the library with your credentials in the `AppDelegate.swift`for example.

```swift
Bundle.fb_setup(
	projectId: "xxx-xxx-xxx",
	baseURL: "https://xxx.com"
)
```

If you are using extensions, you might want to share your only one wording for all of your targets. You can achieve that simply by adding this line with a valid `App Group Identifier` before using the library in all your wanted targets. Remember to add this `App Group Identifier` in the capabilities of your targets.

```swift
Bundle.fb_addAppGroupIdentifier("APP_GROUP_IDENTIFIER")
```

### Update the wording

```swift
let wordingRequest = UpdateWordingRequest(
  language: .languageCode("fr") , // Optional: Default is '.current'
  mergingOptions: [] // Optional: Default is []
  // If you want the merge to allow big changes in your wording such as a number of attributes mismatch, 
  // you can for example use the following :
  // mergingOptions: [.allowRemoteEmptyString, .allowAttributeNumberMismatch]
)

Bundle.main.fb_updateWording(request: wordingRequest) { result in
   switch result {
   case .success:
      // Update UI
   case let .failure(error):
      // Handle error
   }
}
```

### Localize a key with the updated wording

```swift
"key".fb_translation // returns the localized string in the current language
// OR
"key".fb_translate(to: "en") // returns the localized string in english (if it exists)
```

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
