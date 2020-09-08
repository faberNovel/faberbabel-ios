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
        var localized = fb_localize(to: lang)
        if localized == self {
            // TODO: (Pierre Felgines) 08/09/2020 Log event
//            let event = Event(type: .missingKey, key: self)
//            RemoteEventLogger.shared?.log(event)
            if lang != "en" {
                localized = fb_localize(to: "en")
            }
        }
        return localized
    }

    func fb_localize(to lang: String) -> String {
        // TODO: (Pierre Felgines) 08/09/2020 Return correct string
        return self
//        let url = Bundle.updatedLocalizablesBundle?.localizableDirectoryUrl?.appendingPathComponent("\(lang).lproj")
//        guard
//            let directoryUrl = url,
//            let bundle = Bundle(path: directoryUrl.path) else {
//                return NSLocalizedString(self, comment: "")
//        }
//        return bundle.localizedString(forKey: self, value: nil, table: nil)
    }
}
