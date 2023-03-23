//
//  JoinStoriesThumbConfig.swift
//  JoinStoriesSDK
//
//  Created by Audrey SOBGOU ZEBAZE on 09/10/2022.
//

import Foundation
import UIKit

@objc
public class StoryViewConfigDefault: NSObject {
    @objc public static let shared = StoryViewConfigDefault()

    private override init() {
        // private constructor
    }
    /// The default timeout for each request is 60 seconds.
    @objc public let requestTimeoutInterval: TimeInterval = 60
    @objc public let containerDimension = 150

    @objc public let fontName = "HelveticaNeue-Bold"
    @objc public let labelColor = UIColor.black
    @objc public let thumbViewSpacing = 32
    @objc public let withLabel = true

    @objc public let loaderInnerViewColor = [UIColor.black]
    @objc public let loaderColors = [UIColor.red, UIColor.blue]
    @objc public let loaderInnerViewWidth = 2
    @objc public let loaderWidth = 3

    @objc public let storyViewedIndicatorColor = UIColor.gray
    @objc public let storyViewedIndicatorAlpha: Float = 0.8
    @objc public let thumbViewOverlayColor = UIColor(hex8: 0x4C4C4CBB)
    @objc public let playerBackgroundColor: UIColor = .black

}

@objc
public class JoinStoriesThumbConfig: NSObject, JoinStoriesConfig {

    @objc public var alias: String
    @objc public var requestTimeoutInterval: TimeInterval
    @objc public var playerBackgroundColor: UIColor
    @objc public var playerVerticalAnchor: PlayerVerticalAnchor

    @objc var containerDimension: Int
    @objc var fontName: String
    @objc var labelColor: UIColor
    @objc var thumbViewSpacing: Int
    @objc var withLabel: Bool

    @objc var loaderInnerViewWidth: Int
    @objc var loaderInnerViewColor: [UIColor]
    @objc var loaderColors: [UIColor]
    @objc var loaderWidth: Int

    @objc var storyViewedIndicatorColor: UIColor
    @objc var storyViewedIndicatorAlpha: Float
    @objc var thumbViewOverlayColor: UIColor

    @objc
    public init(
        alias: String,
        requestTimeoutInterval: TimeInterval = StoryViewConfigDefault.shared.requestTimeoutInterval,
        containerDimension: Int = StoryViewConfigDefault.shared.containerDimension,
        fontName: String = StoryViewConfigDefault.shared.fontName,
        labelColor: UIColor = StoryViewConfigDefault.shared.labelColor,
        thumbViewSpacing: Int = StoryViewConfigDefault.shared.thumbViewSpacing,
        withLabel: Bool = StoryViewConfigDefault.shared.withLabel,
        loaderInnerViewColor: [UIColor] = StoryViewConfigDefault.shared.loaderInnerViewColor,
        loaderColors: [UIColor] = StoryViewConfigDefault.shared.loaderColors,
        loaderInnerViewWidth: Int = StoryViewConfigDefault.shared.loaderInnerViewWidth,
        loaderWidth: Int = StoryViewConfigDefault.shared.loaderWidth,
        storyViewedIndicatorColor: UIColor = StoryViewConfigDefault.shared.storyViewedIndicatorColor,
        storyViewedIndicatorAlpha: Float = StoryViewConfigDefault.shared.storyViewedIndicatorAlpha,
        thumbViewOverlayColor: UIColor = StoryViewConfigDefault.shared.thumbViewOverlayColor,
        playerBackgroundColor: UIColor = StoryViewConfigDefault.shared.playerBackgroundColor,
        playerVerticalAnchor: PlayerVerticalAnchor = .bottom
    ) {
        self.alias = alias
        self.requestTimeoutInterval = requestTimeoutInterval
        self.containerDimension = containerDimension
        self.fontName = fontName
        self.labelColor = labelColor
        self.thumbViewSpacing = thumbViewSpacing
        self.withLabel = withLabel
        self.loaderInnerViewColor = loaderInnerViewColor
        self.loaderColors = loaderColors
        self.loaderInnerViewWidth = loaderInnerViewWidth
        self.loaderWidth = loaderWidth
        self.storyViewedIndicatorColor = storyViewedIndicatorColor
        self.storyViewedIndicatorAlpha = storyViewedIndicatorAlpha
        self.thumbViewOverlayColor = thumbViewOverlayColor
        self.playerBackgroundColor = playerBackgroundColor
        self.playerVerticalAnchor = playerVerticalAnchor
    }

    // MARK: Getters
    public func getThumbViewSpacing() -> Int {
        thumbViewSpacing
    }

}


// MARK: - StoryComponentsConfigurable

extension JoinStoriesThumbConfig: StoryComponentsConfigurable {
    
    public func getThumbAndLabelDimensions(ratio: Double) -> (thumbWidth: Int, labelWidth: Int) {
        let thumbDimension: Double = withLabel ? Double(containerDimension) * ratio : Double(containerDimension)
        let labelDimension = Double(containerDimension) - thumbDimension
        return (Int(thumbDimension), Int(labelDimension))
    }
}
