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
        Bundle.fb_addAppGroupIdentifier("group.faberbabel.com")
        // Do any additional setup after loading the view.
    }

    @IBAction private func localize() {
        label.text = "hello_world_title".fb_translation
        button.setTitle("localize_button".fb_translation, for: .normal)
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
    }

}
