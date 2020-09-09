//
//  Faberbabel+Translation.swift
//  Faberbabel
//
//  Created by Pierre Felgines on 08/09/2020.
//

import Foundation

extension Faberbabel {

    func translation(forKey key: String,
                     lang: String) -> String {
        var localized = value(forKey: key, lang: lang)
        if localized == key {
            let event = Event(type: .missingKey, key: key)
            logger.log(event)
            if lang != "en" {
                localized = value(forKey: key, lang: "en")
            }
        }
        return localized
    }

    private func value(forKey key: String,
                       lang: String) -> String {
        let url = localizableDirectoryUrl?.appendingPathComponent("\(lang).lproj")
        guard
            let directoryUrl = url,
            let bundle = Bundle(path: directoryUrl.path) else {
                return NSLocalizedString(key, comment: "")
        }
        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }
}
