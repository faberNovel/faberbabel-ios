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
    static var unaccessibleBundle: NSError {
        return NSError(domain: "Faberbabel", code: 0, userInfo: ["description":"Unaccessible Bundle"])
    }
}
