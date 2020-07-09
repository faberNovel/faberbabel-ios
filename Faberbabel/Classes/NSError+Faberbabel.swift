//
//  NSError+Faberbabel.swift
//  Faberbabel
//
//  Created by Jean Haberer on 24/06/2020.
//

import Foundation

extension NSError {
    static var unknownLanguage: NSError {
        return NSError(domain: "Faberbabel", code: 0, userInfo: ["description":"Unknown Language Code"])
    }
    static var unreachableServerError: NSError {
        return NSError(domain: "Faberbabel", code: 0, userInfo: ["description":"Unable to reach the server"])
    }
    static var unaccessibleBundle: NSError {
        return NSError(domain: "Faberbabel", code: 0, userInfo: ["description":"Unaccessible Bundle"])
    }
    static var sdkNotSetUp: NSError {
        return NSError(domain: "Faberbabel", code: 0, userInfo: [
            "description":"The SDK wasn't setup, please add Bundle.fb_setup(...) in your App Delegate for example"
            ]
        )
    }
}
