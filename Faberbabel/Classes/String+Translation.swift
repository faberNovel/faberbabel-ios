//
//  String+Translation.swift
//  Faberbabel
//
//  Created by Jean Haberer on 25/06/2020.
//

import Foundation

extension String {
    public var translation: String {
        return translate(to: Locale.current.languageCode ?? "en")
    }

    public func translate(to lang: String) -> String {
        guard
            let path = Bundle.updatedLocalizationsBundle?
                .path(forResource: lang, ofType: "lproj"),
            let bundle = Bundle(path: path) else {
                return NSLocalizedString(self, comment: "")
        }
        return bundle.localizedString(forKey: self, value: nil, table: nil)
    }
}
