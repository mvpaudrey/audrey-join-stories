//
//  JoinStoriesConfig.swift
//  JoinStoriesSDK
//
//  Created by Audrey SOBGOU ZEBAZE on 09/10/2022.
//

import UIKit

@objc
public enum PlayerVerticalAnchor: Int, Equatable {
    /// Anchor is expanded out of its safe area.
    case topIgnoringSafeArea
    /// Anchor is considering its safe area.
    case topWithSafeArea
    case bottom

}

@objc
public protocol JoinStoriesConfig {

    var alias: String { get set }
    var requestTimeoutInterval: TimeInterval { get set }
    var playerBackgroundColor: UIColor { get set }
    var playerVerticalAnchor: PlayerVerticalAnchor { get set }
}
