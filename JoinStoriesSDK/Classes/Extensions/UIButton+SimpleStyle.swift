//
//  UIButton+SimpleStyle.swift
//  JoinStoriesSDK
//
//  Created by JOIN on 09/01/2021.
//

import Foundation
import UIKit

extension UIButton {
    public func applySimpleStyle() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 2
        self.setTitleColor(.black, for: .normal)
    }
}
