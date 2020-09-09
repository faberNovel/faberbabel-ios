//
//  Result+Error.swift
//  Faberbabel
//
//  Created by Jean Haberer on 29/06/2020.
//

import Foundation

extension Result where Failure == Error {

    func mapThrow<NewSuccess>(_ transform: (Success) throws -> NewSuccess) -> Result<NewSuccess, Failure> {
        return flatMap { value in
            Result<NewSuccess, Failure> {
                try transform(value)
            }
        }
    }
}
