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
        completion(.success("hello = \"cacahuetes\";"))
    }
}
