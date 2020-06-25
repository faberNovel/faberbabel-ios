//
//  ViewController.swift
//  Faberbabel
//
//  Created by Jean Haberer on 06/24/2020.
//  Copyright (c) 2020 Jean Haberer. All rights reserved.
//

import UIKit
import Faberbabel

class ViewController: UIViewController {

    @IBOutlet private var label1: UILabel!
    @IBOutlet private var label2: UILabel!
    @IBOutlet private var refreshButton: UIButton!
    @IBOutlet private var localizeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        label1.text = "hello_world_title"
        label2.text = "hello_world_description"
        refreshButton.setTitle("refresh_button", for: .normal)
        localizeButton.setTitle("localize_button", for: .normal)
    }

    @IBAction private func refresh() {
        refreshButton.isEnabled = false
        localizeButton.isEnabled = false
        Bundle.main.updateCurrentWording { result in
            refreshButton.isEnabled = true
            localizeButton.isEnabled = true
            switch result {
            case .sucess:
                print("Success updating wording")
            case let .failure(error):
                print("Error updating wording: \(error.localizedDescription)")
            }
        }
    }

    @IBAction private func localize() {
        label1.text = NSLocalizedString("hello_world_title", comment: "")
        label2.text = NSLocalizedString("hello_world_description", comment: "")
        refreshButton.setTitle(NSLocalizedString("refresh_button", comment: ""), for: .normal)
        localizeButton.setTitle(NSLocalizedString("localize_button", comment: ""), for: .normal)
    }

}
