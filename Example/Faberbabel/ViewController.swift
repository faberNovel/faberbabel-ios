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
        let wordingRequest = UpdateWordingRequest(
            language: .current,
            mergingOptions: [.allowRemoteEmptyString]
        )
        Bundle.main.fb_updateWording(request: wordingRequest) { [weak self] result in
            self?.refreshButton.isEnabled = true
            self?.localizeButton.isEnabled = true
            switch result {
            case .success:
                print("Success updating wording")
            case let .failure(error):
                print("Error updating wording: \(error)")
            }
        }
    }

    @IBAction private func localize() {
        label1.text = "hello_world_title".fb_translation
        label2.text = "hello_world_description".fb_translation
        refreshButton.setTitle("refresh_button".fb_translation, for: .normal)
        localizeButton.setTitle("localize_button".fb_translation, for: .normal)
    }

}
