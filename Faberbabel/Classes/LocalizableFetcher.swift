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
                    \"hello_world_title\" = \"Hello Updated World\";
                    \"hello_world_description\" = \"This is the updated description of Hello World.\";
                    \"refresh_button\" = \"Refresh (already up to date)\";
                    \"localize_button\" = \"updated localize\";
                    """
                )
            )
        } else if lang == "fr" {
            completion(
                .success(
                    """
                    \"hello_world_title\" = \"Bonjour Monde à jour\";
                    \"hello_world_description\" = \"Voici la description à jour de bonjour monde.\";
                    \"refresh_button\" = \"Actualiser (dejà à jour)\";
                    \"localize_button\" = \"Localiser à jour\";
                    """
                )
            )
        } else {
            completion(.failure(NSError.unknownLanguage))
        }
    }
}
