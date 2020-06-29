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
        if let dictionary = Bundle.updatedLocalizables[lang],
            let localized = dictionary[self] {
            return localized
        } else if
            let url = Bundle.localizableFileUrl(forLanguage: lang),
            let dictionary = NSDictionary(contentsOfFile: url.path) as? Localizations,
            let localized = dictionary[self] {
            Bundle.updatedLocalizables[lang] = dictionary
            return localized
        }
        return NSLocalizedString(self, comment: "")
    }
}
