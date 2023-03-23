import UIKit

open class StoryCollectionViewCell: UICollectionViewCell {
    
    public static let reuseIdentifier = "StoryCollectionViewCell"
    
    /// Default config
    public var config = StoryViewConfig()

    public var thumbConfig: JoinStoriesThumbConfig?
    
    public var storyPersistence: StoryPersistable = StoryPersistence()
    
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

    var story: StoryValue?
    
    var thumbStory: StoryThumbView?
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: UI

    @available(*, deprecated, message: "This will be removed. Use `setupCell(storyValue:storyConfig:ratio:)` for api requests")
    public func setupCell(storyValue: StoryValue, with storyConfig: StoryViewConfig,
                          ratio: Double) {
        updateConfig(storyConfig: storyConfig)
        story = storyValue
        let (thumbDimension, labelDimension) = storyConfig.getThumbAndLabelDimensions(ratio: ratio)
        thumbStory = StoryThumbView(
            thumbDimension: thumbDimension,
            labelDimension: labelDimension,
            loaderInnerViewColor: self.config.loaderInnerViewColor,
            loaderColors: self.config.loaderColors,
            loaderInnerViewWidth: self.config.loaderInnerViewWidth,
            loaderWidth: self.config.loaderWidth,
            fontName: self.config.fontName,
            labelColor: self.config.labelColor,
            withLabel: self.config.withLabel,
            storyViewedIndicatorColor: self.config.storyViewedIndicatorColor,
            storyViewedIndicatorAlpha: self.config.storyViewedIndicatorAlpha,
            thumbViewOverlayColor: self.config.thumbViewOverlayColor,
            displayType: displayType(for: storyValue)
        )
        guard let story = story else {
            return
        }

        if let thumbStory = thumbStory {
            thumbStory.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                thumbStory.widthAnchor.constraint(equalToConstant: CGFloat(thumbDimension)),
                thumbStory.heightAnchor.constraint(equalToConstant: CGFloat(self.config.containerDimension))
            ])
        }
        
        thumbStory?.reset()
        thumbStory?.animator?.stopAnimation(true)
        thumbStory?.animator?.finishAnimation(at: .current)
        thumbStory?.loadStory(story: story)
        if let thumbStory = thumbStory {
            addSubview(thumbStory)
        }
    }

    public func setupCell(
        storyValue: StoryValue,
        with storyConfig: JoinStoriesThumbConfig, ratio: Double) {
            self.thumbConfig = storyConfig
            story = storyValue
            let (thumbDimension, labelDimension) = storyConfig.getThumbAndLabelDimensions(ratio: ratio)
            thumbStory = StoryThumbView(
                thumbDimension: thumbDimension,
                labelDimension: labelDimension,
                loaderInnerViewColor: storyConfig.loaderInnerViewColor,
                loaderColors: storyConfig.loaderColors,
                loaderInnerViewWidth: storyConfig.loaderInnerViewWidth,
                loaderWidth: storyConfig.loaderWidth,
                fontName: storyConfig.fontName,
                labelColor: storyConfig.labelColor,
                withLabel: storyConfig.withLabel,
                storyViewedIndicatorColor: storyConfig.storyViewedIndicatorColor,
                storyViewedIndicatorAlpha: storyConfig.storyViewedIndicatorAlpha,
                thumbViewOverlayColor: storyConfig.thumbViewOverlayColor,
                displayType: displayType(for: storyValue)
            )
            guard let story = story else {
                return
            }

            if let thumbStory = thumbStory {
                thumbStory.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    thumbStory.widthAnchor.constraint(equalToConstant: CGFloat(thumbDimension)),
                    thumbStory.heightAnchor.constraint(equalToConstant: CGFloat(self.config.containerDimension))
                ])
            }

            thumbStory?.reset()
            thumbStory?.animator?.stopAnimation(true)
            thumbStory?.animator?.finishAnimation(at: .current)
            thumbStory?.loadStory(story: story)
            if let thumbStory = thumbStory {
                addSubview(thumbStory)
            }
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        thumbStory?.reset()
    }
    
    // MARK: Private methods
    
    private func displayType(for story: StoryValue) -> DisplayType {
        storyPersistence.storyIsSeen(id: story.id) ? .seen : .unseen
    }

    /// To remove soon
    private func updateConfig(storyConfig: StoryViewConfig) {
        config = storyConfig
    }

}
