//
//  LocalizableMerger.swift
//  Faberbabel
//
//  Created by Jean Haberer on 24/06/2020.
//

import Foundation

class LocalizableMerger {
    func merge(localStrings: Localizations, with remoteStrings: Localizations) -> Localizations {
        return localStrings.merging(remoteStrings) { canMerge(local: $0, remote: $1) ? $1 : $0 }
    }

    // MARK: - Private

    private func canMerge(local: String, remote: String) -> Bool {
        let localAttributesCount = local.countInstances(of: "$@") + local.countInstances(of: "%@")
        let remoteAttributesCount = remote.countInstances(of: "$@") + remote.countInstances(of: "%@")
        return (remoteAttributesCount == localAttributesCount) && (remote != "")
    }
}
