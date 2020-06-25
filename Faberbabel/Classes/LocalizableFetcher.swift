//
//  LocalizableFetcher.swift
//  Faberbabel
//
//  Created by Jean Haberer on 24/06/2020.
//

import Foundation

class LocalizableFetcher {
    init() {}

    func fetch(for lang: String, completion: (Result<String, Error>) -> Void) {
        if lang == "en" {
            completion(
                .success(
                    """
                    \"hello_world_title\" = \"Hello Truche\";
                    \"hello_world_description\" = \"This is the description of Hello Truche.\";
                    \"refresh_button\" = \"Refresh (already up to date)\";
                    \"localize_button\" = \"Localize (but better)\";
                    """
                )
            )
        } else if lang == "fr" {
            completion(
                .success(
                    """
                    \"hello_world_title\" = \"Bonjour Nal\";
                    \"hello_world_description\" = \"Voici la description de bonjour nal.\";
                    \"refresh_button\" = \"Actualiser (dejà à jour)\";
                    \"localize_button\" = \"Localiser (mais en mieux)\";
                    """
                )
            )
        } else {
            completion(.failure(NSError.unknownLanguage))
        }
    }
}
