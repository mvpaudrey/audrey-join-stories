//
//  UIViewController+Alert.swift
//  JoinStoriesSDK
//
//  Created by JOIN on 07/11/2020.
//

import Foundation
import UIKit

extension UIViewController {
    public func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
