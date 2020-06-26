//
//  LocalizableMerger.swift
//  Faberbabel
//
//  Created by Jean Haberer on 24/06/2020.
//

import Foundation

class LocalizableMerger {
    init() {}

    func merge(localStrings: NSDictionary, with remoteStrings: NSDictionary) -> NSDictionary {
        let mergeResult = NSMutableDictionary(dictionary: localStrings)
        for remoteLocalizable in remoteStrings {
            if let localString = localStrings[remoteLocalizable.key] as? String,
                let remoteString = remoteLocalizable.value as? String,
                canMerge(local: localString, remote: remoteString) {
                mergeResult[remoteLocalizable.key] = remoteLocalizable.value
            } else if localStrings[remoteLocalizable.key] == nil {
                mergeResult[remoteLocalizable.key] = remoteLocalizable.value
            }
        }
        return mergeResult
    }

    // MARK: - Private

    private func canMerge(local: String, remote: String) -> Bool {
        let localAttributesCount = local.countInstances(of: "$@") + local.countInstances(of: "%@")
        let remoteAttributesCount = remote.countInstances(of: "$@") + remote.countInstances(of: "%@")
        return (remoteAttributesCount == localAttributesCount) && (remote != "")
    }
}
