//
//  StoryThumbView.swift
//  JoinStoriesSDK
//
//  Created by JOIN on 07/11/2020.
//

import Foundation
import UIKit

public class StoryThumbView: UIView {
        
    var isInit = false
    
    var thumbDimension = 0
    var labelDimension = 0
    
    var fontName: String!
    
    var labelColor: UIColor!
    var withLabel: Bool!
    
    var loaderInnerViewColor: [UIColor]!
    var loaderColors: [UIColor]!
    
    var loaderInnerViewWidth: Int!
    var loaderWidth: Int!
    
    var storyViewedIndicatorColor: UIColor!
    var storyViewedIndicatorAlpha: Float!
    var thumbViewOverlayColor: UIColor!
    
    var displayType: DisplayType!
    
    var story: StoryValue?

    var animator: UIViewPropertyAnimator?
        
    lazy var contentView: UIImageView = {
        let contentView = UIImageView(frame: self.frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    lazy var labelView: UILabel = {
        let labelView = UILabel(frame: self.frame)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.adjustsFontSizeToFitWidth = false
        labelView.lineBreakMode = .byWordWrapping
        labelView.numberOfLines = 2
        labelView.textAlignment = .center
        labelView.textColor = self.labelColor
        labelView.font = UIFont(name: self.fontName, size: CGFloat(labelDimension / 3))
        return labelView
    }()
    
    private var overlayView = UIView()
    
    private let rotateAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: KeyPath.rotation)
        animation.fromValue = 0
        animation.toValue = 2 * Double.pi
        animation.speed = 0.0
        animation.repeatCount = .infinity
        return animation
    }()
    
    private var foregroundLayer: CAShapeLayer!

    private var progressLayer: CAGradientLayer!
    
    private var seenIndicatorLayer: CAShapeLayer!
        
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public init(
        thumbDimension: Int,
        labelDimension: Int,
        loaderInnerViewColor: [UIColor]?,
        loaderColors: [UIColor]?,
        loaderInnerViewWidth: Int?,
        loaderWidth: Int?,
        fontName: String?,
        labelColor: UIColor?,
        withLabel: Bool?,
        storyViewedIndicatorColor: UIColor?,
        storyViewedIndicatorAlpha: Float?,
        thumbViewOverlayColor: UIColor?,
        displayType: DisplayType
    ) {
        super.init(frame: CGRect.zero)
        self.thumbDimension = thumbDimension
        self.labelDimension = labelDimension
        
        self.loaderInnerViewColor = loaderInnerViewColor ?? StoryViewConfigDefault.shared.loaderInnerViewColor
        self.loaderColors = loaderColors ?? StoryViewConfigDefault.shared.loaderColors
        self.loaderInnerViewWidth = loaderInnerViewWidth ?? StoryViewConfigDefault.shared.loaderInnerViewWidth
        self.loaderWidth = loaderWidth ?? StoryViewConfigDefault.shared.loaderWidth
        
        self.fontName = fontName ?? StoryViewConfigDefault.shared.fontName
        self.labelColor = labelColor ?? StoryViewConfigDefault.shared.labelColor
        self.withLabel = withLabel ?? StoryViewConfigDefault.shared.withLabel
        
        self.storyViewedIndicatorColor = storyViewedIndicatorColor ?? StoryViewConfigDefault.shared.storyViewedIndicatorColor
        self.storyViewedIndicatorAlpha = storyViewedIndicatorAlpha ?? StoryViewConfigDefault.shared.storyViewedIndicatorAlpha
        self.thumbViewOverlayColor = thumbViewOverlayColor ?? StoryViewConfigDefault.shared.thumbViewOverlayColor
        self.displayType = displayType
        setupView()
    }
    
    private func setupView() {
        addSubview(contentView)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(storyPlayerDidStartLoading),
                                               name: .storyPlayerStartedLoading,
                                               object: nil
        )
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(storyPlayerDidStopLoading),
                                               name: .storyPlayerStoppedLoading,
                                               object: nil
        )

        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: CGFloat(thumbDimension)),
            contentView.heightAnchor.constraint(equalToConstant: CGFloat(thumbDimension))
        ])
        
        if withLabel {
            addSubview(labelView)
            labelView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                labelView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4),
                labelView.widthAnchor.constraint(equalTo: widthAnchor),
                labelView.heightAnchor.constraint(equalToConstant: CGFloat(labelDimension - 4)),
            ])
        }

    }
    
    private func addLayers() {
        let trueLoaderInnerViewWidth: Int = (self.loaderInnerViewWidth > 0 && self.loaderInnerViewColor.count > 0) ? self.loaderInnerViewWidth : 0;
        let trueLoaderWidth: Int = (self.loaderWidth > 0 && self.loaderColors.count > 0) ? self.loaderWidth : 0;
        // Inner
        foregroundLayer = contentView.circleBorder(
            withLineWidth: CGFloat(trueLoaderInnerViewWidth + trueLoaderWidth), strokeColor: loaderInnerViewColor.first?.cgColor ?? UIColor.black.cgColor
        )
        contentView.layer.addSublayer(foregroundLayer)
        
        // Outer
        switch displayType {
        case .seen:
            seenIndicatorLayer = contentView.circleBorder(withLineWidth: 1, strokeColor: storyViewedIndicatorColor.cgColor, opacity: storyViewedIndicatorAlpha)
            contentView.layer.addSublayer(seenIndicatorLayer)
        case .unseen:
            progressLayer = contentView.circleGradientBorder(
                withLineWidth: CGFloat(trueLoaderWidth),
                andColors: loaderColors.map { $0.cgColor }
            )
            contentView.layer.addSublayer(progressLayer)
        default:
            break
        }
    }
    
    public func reset() {
        labelView.text = nil
        overlayView.isHidden = true
        contentView.image = nil
    }
    
    func showAnimationLoader(speed: Float = 0.2, alpha: CGFloat = 0.7) {
        startLayerAnimations(speed: speed, alpha: alpha)
        showOverlayView()
    }
    
    func removeOverlayAndSpinner() {
        stopLayerAnimations()
        hideOverlayView()
    }
    
    public func addOverlay(color: UIColor) {
        overlayView.frame = contentView.bounds
        overlayView.clipsToBounds = true
        overlayView.backgroundColor = color
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        overlayView.isHidden = true
        contentView.addSubview(overlayView)
    }
    
    public func showOverlayView() {
        overlayView.isHidden = false
    }
    
    public func hideOverlayView() {
        overlayView.isHidden = true
    }
    
    public override func layoutSubviews() {
        self.contentView.frame = CGRect(x: 0, y: 0, width: thumbDimension, height: thumbDimension)
        self.contentView.bounds = CGRect(x: 0, y: 0, width: thumbDimension, height: thumbDimension)
        addOverlay(color: thumbViewOverlayColor)
        addLayers()
    }
    
    public func loadStory(story: StoryValue) {
        self.story = story
        self.labelView.text = story.title
        self.setImage(story.thumbnail)
    }
    
    func setImage(_ imageSource: String) {
        guard let uri = URL(string: imageSource) else {
            return
        }

        ImageLoader.shared.loadImage(from: uri) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.showImage(image: image)
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.showImage(image: UIImage(named: "placeholder"))
                }
            }
        }
    }

    private func showImage(image: UIImage?) {
        animator?.stopAnimation(false)
        animator?.finishAnimation(at: .current)
        contentView.image = image
        animator = UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
            delay: 0,
            options: .transitionCrossDissolve,
            animations: {}
        )
    }
    
    // MARK: Notifications
    
    @objc private func storyPlayerDidStartLoading(_ notification: Notification) {
        if let storyObject = notification.object as? StoryValue {
            if let story = self.story, story == storyObject {
                showAnimationLoader()
            }
        }
    }
    
    @objc private func storyPlayerDidStopLoading(_ notification: Notification) {
        if let storyObject = notification.object as? StoryValue {
            if let story = self.story, story == storyObject {
                removeOverlayAndSpinner()
            }
        }
    }
    
}

public extension StoryThumbView {
    
    func startLayerAnimations(speed: Float = 0.2, alpha: CGFloat = 0.7) {
        rotateAnimation.speed = speed
        switch displayType {
        case .seen:
            seenIndicatorLayer.add(animation: rotateAnimation)
        case .unseen:
            progressLayer.add(animation: rotateAnimation)
        default: break
        }
    }
    
    func stopLayerAnimations() {
        switch displayType {
        case .seen:
            seenIndicatorLayer.removeAllAnimations()
        case .unseen:
            progressLayer.removeAllAnimations()
        default: break
        }
        contentView.alpha = 1.0
    }
}
