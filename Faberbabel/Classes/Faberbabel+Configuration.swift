//
//  Faberbabel+Configuration.swift
//  Pods
//
//  Created by Pierre Felgines on 08/09/2020.
//

import Foundation

extension Faberbabel {

    static var shared: Faberbabel?

    public static func configure(projectId: String,
                                 baseURL: URL,
                                 appGroupIdentifier: String? = nil) {
        let fetcher = RemoteLocalizableFetcher(
            projectId: projectId,
            baseURL: baseURL
        )
        let remoteLogger = RemoteEventLogger(
            projectId: projectId,
            baseURL: baseURL
        )
        let consoleLogger = ConsoleEventLogger()
        let logger = CompoundEventLogger(
            loggers: [remoteLogger, consoleLogger]
        )
        self.configure(
            fetcher: fetcher,
            logger: logger,
            appGroupIdentifier: appGroupIdentifier
        )
    }

    public static func configure(fetcher: LocalizableFetcher,
                                 logger: EventLogger,
                                 appGroupIdentifier: String? = nil) {
        Faberbabel.shared = Faberbabel(
            fetcher: fetcher,
            logger: logger,
            appGroupIdentifier: appGroupIdentifier
        )
    }

    public static func updateWording(request: UpdateWordingRequest,
                                     bundle: Bundle,
                                     completion: @escaping (WordingUpdateResult) -> Void) {
        guard let instance = Faberbabel.shared else {
            preconditionFailure("The SDK wasn't setup. Follow the README instructions.")
        }
        instance.updateWording(
            request: request,
            bundle: bundle,
            completion: completion
        )
    }

    public static func translation(forKey key: String,
                                   lang: String) -> String {
        guard let instance = Faberbabel.shared else {
            preconditionFailure("The SDK wasn't setup. Follow the README instructions.")
        }
        return instance.translation(forKey: key, lang: lang)
    }
}
