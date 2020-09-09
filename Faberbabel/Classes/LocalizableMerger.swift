//
//  LocalizableMerger.swift
//  Faberbabel
//
//  Created by Jean Haberer on 24/06/2020.
//

import Foundation

class LocalizableMerger {

    private let eventLogger: EventLogger?

    init(eventLogger: EventLogger?) {
        self.eventLogger = eventLogger
    }

    func merge(localStrings: Localizations,
               with remoteStrings: Localizations,
               options: [MergingOption] = []) -> Localizations {
        var result = localStrings
        var exceptions: [Event] = []
        for remoteLocalizable in remoteStrings {
            if let local = result[remoteLocalizable.key] {
                if let exception = exceptionFromMerging(
                    local: local,
                    remote: remoteLocalizable.value,
                    key: remoteLocalizable.key,
                    options: options
                ) {
                    exceptions.append(exception)
                } else {
                    result[remoteLocalizable.key] = remoteLocalizable.value
                }
            } else {
                result[remoteLocalizable.key] = remoteLocalizable.value
            }
        }
        eventLogger?.log(exceptions)
        return result
    }

    // MARK: - Private

    private func exceptionFromMerging(local: String,
                                      remote: String,
                                      key: String,
                                      options: [MergingOption]) -> Event? {
        if !options.contains(.allowRemoteEmptyString), remote.isEmpty {
            return Event(type: .emptyValue, key: key)
        }
        let localAttributesCount = local.countInstances(of: "$@") + local.countInstances(of: "%@")
        let remoteAttributesCount = remote.countInstances(of: "$@") + remote.countInstances(of: "%@")
        if !options.contains(.allowAttributeNumberMismatch),
            remoteAttributesCount != localAttributesCount {
            return Event(type: .mismatchAttributes, key: key)
        }
        return nil
    }
}
