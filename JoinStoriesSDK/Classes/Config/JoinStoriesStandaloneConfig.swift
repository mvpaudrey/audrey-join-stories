//
//  JoinStoriesStandaloneConfig.swift
//  JoinStoriesSDK
//
//  Created by Audrey SOBGOU ZEBAZE on 09/10/2022.
//

import Foundation
import UIKit

@objc
public enum PlayerStandaloneAnimationOrigin: Int {
    case `default`
    case top
    case topLeft
    case topRight
    case bottom
    case bottomLeft
    case bottomRight
}

@objc
public class JoinStoriesStandaloneDefaultConfig: NSObject {

    @objc public static let shared = JoinStoriesStandaloneDefaultConfig()

    public var requestTimeoutInterval: TimeInterval = 60
    public var playerBackgroundColor: UIColor = .black
    public var playerStandaloneAnimationOrigin: PlayerStandaloneAnimationOrigin = .default
    public var playerVerticalAnchor: PlayerVerticalAnchor = .bottom

    private override init() {
        // private constructor
    }
}

@objc
public class JoinStoriesStandaloneConfig: NSObject, JoinStoriesConfig {

    @objc
    public var alias: String

    @objc
    public var requestTimeoutInterval: TimeInterval

    @objc
    public var playerBackgroundColor: UIColor

    @objc
    public var playerVerticalAnchor: PlayerVerticalAnchor

    @objc
    var playerStandaloneAnimationOrigin: PlayerStandaloneAnimationOrigin

    @objc public init(
        alias: String,
        requestTimeoutInterval: TimeInterval = JoinStoriesStandaloneDefaultConfig.shared.requestTimeoutInterval,
        playerBackgroundColor: UIColor = JoinStoriesStandaloneDefaultConfig.shared.playerBackgroundColor,
        playerStandaloneAnimationOrigin: PlayerStandaloneAnimationOrigin = JoinStoriesStandaloneDefaultConfig.shared.playerStandaloneAnimationOrigin,
        playerVerticalAnchor: PlayerVerticalAnchor = JoinStoriesStandaloneDefaultConfig.shared.playerVerticalAnchor
    ) {
        self.alias = alias
        self.requestTimeoutInterval = requestTimeoutInterval
        self.playerBackgroundColor = playerBackgroundColor
        self.playerStandaloneAnimationOrigin = playerStandaloneAnimationOrigin
        self.playerVerticalAnchor = playerVerticalAnchor
    }

}
