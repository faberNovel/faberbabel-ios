//
//  String+Translation.swift
//  Faberbabel
//
//  Created by Jean Haberer on 25/06/2020.
//

import Foundation

extension String {

    public var fb_translation: String {
        let lang = Locale.current.languageCode ?? "en"
        return Faberbabel.translation(forKey: self, lang: lang)
    }
}
