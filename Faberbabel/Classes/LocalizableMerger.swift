//
//  LocalizableMerger.swift
//  Faberbabel
//
//  Created by Jean Haberer on 24/06/2020.
//

import Foundation

class LocalizableMerger {
    func merge(localStrings: Localizations, with remoteStrings: Localizations, options: [MergingOption] = []) -> Localizations {
        return localStrings.merging(remoteStrings) { canMerge(local: $0, remote: $1, options: options) ? $1 : $0 }
    }

    // MARK: - Private

    private func canMerge(local: String, remote: String, options: [MergingOption]) -> Bool {
        if !options.contains(.allowRemoteEmptyString),
            remote == "" {
            print("WARNING:\nWon't merge remote `\(remote)` : Remote string is empty")
            return false
        }
        let localAttributesCount = local.countInstances(of: "$@") + local.countInstances(of: "%@")
        let remoteAttributesCount = remote.countInstances(of: "$@") + remote.countInstances(of: "%@")
        if !options.contains(.allowAttributeNumberMismatch),
            remoteAttributesCount != localAttributesCount {
            print(
                "WARNING:"
                    + "\nWon't merge remote string `\(remote)` : "
                    + "\nRemote string does not match the parameter's number of the local string "
                    + "(remote: \(remoteAttributesCount), local: \(localAttributesCount))"
            )
            return false
        }
        return true
    }
}
