//
//  WordingUpdateResult.swift
//  Faberbabel
//
//  Created by Jean Haberer on 24/06/2020.
//

import Foundation

public enum WordingUpdateResult {
    case success
    case failure(_ error: WordingUpdateError)
}
