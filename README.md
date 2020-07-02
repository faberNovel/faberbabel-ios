# Faberbabel

[![CI Status](https://img.shields.io/travis/Jean Haberer/Faberbabel.svg?style=flat)](https://travis-ci.org/Jean Haberer/Faberbabel)
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

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## How to use 

### Update the wording

```swift
let wordingRequest = FBUpdateWordingRequest(
	baseURL: FABERBABEL_BASE_URL,
	projectId: FABERBABEL_PROJECT_ID,
	language: .current // you can also set it manually specifying .languageCode("en")
)

Bundle.main.fb_updateWording(request: wordingRequest) { [weak self] result in
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
