//
//  LocalizableMerger.swift
//  Faberbabel
//
//  Created by Jean Haberer on 24/06/2020.
//

import Foundation

class LocalizableMerger {
    func merge(localStrings: Localizations, with remoteStrings: Localizations, options: [MergingOption] = []) -> Localizations {
        var result = localStrings
        for remoteLocalizable in remoteStrings {
            if let local = result[remoteLocalizable.key] {
                if canMerge(local: local, remote: remoteLocalizable.value, key: remoteLocalizable.key, options: options) {
                    result[remoteLocalizable.key] = remoteLocalizable.value
                }
            } else {
                result[remoteLocalizable.key] = remoteLocalizable.value
            }
        }
        return result
    }

    // MARK: - Private
    private func canMerge(local: String, remote: String, key: String, options: [MergingOption]) -> Bool {
        if !options.contains(.allowRemoteEmptyString),
            remote == "" {
            print("WARNING:\nWon't merge key `\(key)` : Remote string is empty")
            return false
        }
        let localAttributesCount = local.countInstances(of: "$@") + local.countInstances(of: "%@")
        let remoteAttributesCount = remote.countInstances(of: "$@") + remote.countInstances(of: "%@")
        if !options.contains(.allowAttributeNumberMismatch),
            remoteAttributesCount != localAttributesCount {
            print(
                "WARNING:"
                    + "\nWon't merge remote key `\(key)` : "
                    + "\nRemote string does not match the parameter's number of the local string "
                    + "(remote: \(remoteAttributesCount), local: \(localAttributesCount))"
            )
            return false
        }
        return true
    }
}
