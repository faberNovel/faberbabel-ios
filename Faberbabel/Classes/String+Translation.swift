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
            let event = Event(type: .missingKey, key: self)
            RemoteEventNotifier.shared?.notify(event: event)
            if lang != "en" {
                localized = fb_localize(to: "en")
            }
        }
        return localized
    }

    func fb_localize(to lang: String) -> String {
        let url = Bundle.updatedLocalizablesBundle?.localizableDirectoryUrl?.appendingPathComponent("\(lang).lproj")
        guard
            let directoryUrl = url,
            let bundle = Bundle(path: directoryUrl.path) else {
                return NSLocalizedString(self, comment: "")
        }
        return bundle.localizedString(forKey: self, value: nil, table: nil)
    }
}
