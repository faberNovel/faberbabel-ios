//
//  Faberbabel.swift
//  Pods
//
//  Created by Pierre Felgines on 08/09/2020.
//

import Foundation

public enum Faberbabel {

    static var manager: LocalizableManager?

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
        do {
            Faberbabel.manager = try LocalizableManager(
                fetcher: fetcher,
                logger: logger,
                appGroupIdentifier: appGroupIdentifier
            )
        } catch {
            assertionFailure("Error configuring Faberbabel \(error)")
        }
    }

    public static func updateWording(request: UpdateWordingRequest,
                                     bundle: Bundle,
                                     completion: @escaping (WordingUpdateResult) -> Void) {
        guard let manager = Faberbabel.manager else {
            preconditionFailure("The SDK wasn't setup. Follow the README instructions.")
        }
        manager.updateWording(
            request: request,
            bundle: bundle,
            completion: completion
        )
    }

    public static func translation(forKey key: String,
                                   lang: String) -> String {
        guard let manager = Faberbabel.manager else {
            preconditionFailure("The SDK wasn't setup. Follow the README instructions.")
        }
        return manager.translation(forKey: key, lang: lang)
    }
}
