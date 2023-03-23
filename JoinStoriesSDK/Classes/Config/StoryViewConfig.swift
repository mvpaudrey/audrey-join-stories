//
//  StoryViewConfig.swift
//  JoinStoriesSDK
//
//  Created by JOIN on 27/03/2021.
//

import Foundation
import UIKit

@objc
public class StoryViewConfig: NSObject {
    var requestTimeoutInterval: TimeInterval
    public var containerDimension: Int
    var fontName: String
    var labelColor: UIColor
    var thumbViewSpacing: Int
    var withLabel: Bool
    
    var loaderInnerViewColor: [UIColor]
    var loaderColors: [UIColor]
    var loaderInnerViewWidth: Int
    var loaderWidth: Int
    
    var storyViewedIndicatorColor: UIColor
    var storyViewedIndicatorAlpha: Float
    var thumbViewOverlayColor: UIColor
    let playerBackgroundColor: UIColor

    @objc
    public init(
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
        playerBackgroundColor: UIColor = StoryViewConfigDefault.shared.playerBackgroundColor

    ) {
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

    }
    
    // MARK: Getters
    public func getThumbViewSpacing() -> Int {
        thumbViewSpacing
    }
    
}

// MARK: - StoryComponentsConfigurable

extension StoryViewConfig: StoryComponentsConfigurable {

    public func getThumbAndLabelDimensions(ratio: Double = 0.7) -> (thumbWidth: Int, labelWidth: Int) {
        // Set dimensions according to containerDimension
        let thumbDimension: Double = withLabel ? Double(containerDimension) * ratio : Double(containerDimension)
        let labelDimension = Double(containerDimension) - thumbDimension
        return (Int(thumbDimension), Int(labelDimension))
    }

}
