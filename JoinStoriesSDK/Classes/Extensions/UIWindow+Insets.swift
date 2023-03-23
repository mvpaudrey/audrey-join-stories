//
//  UIWindow+Insets.swift
//  JoinStoriesSDK
//
//  Created by JOIN on 12/02/2021.
//

import Foundation
import UIKit

extension UIApplication {
    public func topAreaInset() -> CGFloat {
        let window = windows.first { $0.isKeyWindow }
        if #available(iOS 11.0, *) {
            let safeAreaInsets = window?.safeAreaInsets
            if let top = safeAreaInsets?.top {
                return top
            }
        }
        
        return 0
    }
}
