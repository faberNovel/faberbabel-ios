//
//  TodayViewController.swift
//  Widget
//
//  Created by Jean Haberer on 15/07/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import NotificationCenter
import Faberbabel

class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet private var label: UILabel!
    @IBOutlet private var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = URL(string: "base_url") else { return }
        Faberbabel.configure(
            projectId: "project_id",
            baseURL: url,
            appGroupIdentifier: "group.faberbabel.com"
        )
    }

    @IBAction private func localize() {
        label.text = "hello_world_title".fb_translation
        button.setTitle("localize_button".fb_translation, for: .normal)
    }

}
