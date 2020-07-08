//
//  String+Translation.swift
//  Faberbabel
//
//  Created by Jean Haberer on 25/06/2020.
//

import Foundation

extension String {
    public var fb_translation: String {
        return fb_translate(to: Locale.current.languageCode ?? "en")
    }

    public func fb_translate(to lang: String) -> String {
        guard
            let directoryUrl = Bundle.updatedLocalizablesBundle?.localizableDirectoryUrl?.appendingPathComponent("\(lang).lproj"),
            let bundle = Bundle(path: directoryUrl.path)
            else {
                return NSLocalizedString(self, comment: "")
            }
        var localized = bundle.localizedString(forKey: self, value: nil, table: nil)
        if localized == self {
            print("ERROR:\nKey not found for language code '\(lang)': '\(self)'")
            if lang != "en" {
                localized = fb_translate(to: "en")
            }
        }
        return localized
    }
}
