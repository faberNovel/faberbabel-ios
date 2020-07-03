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
            let directoryUrl = Bundle.updatedLocalizablesBundle?.localizableDirectoryUrl,
            let bundle = Bundle(path: directoryUrl.path)
            else {
                return NSLocalizedString(self, comment: "")
            }
        return bundle.localizedString(forKey: self, value: nil, table: nil)
    }
}
