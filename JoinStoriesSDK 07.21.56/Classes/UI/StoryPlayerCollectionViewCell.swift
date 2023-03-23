import UIKit
import WebKit

class StoryPlayerCollectionViewCell: UICollectionViewCell {

    private let heightConstraintRatio: CGFloat = 1.91
    
    static let reuseIdentifier = "StoryPlayerCollectionViewCell"
    
    var storyPlayer: StoryPlayer = StoryPlayer()
    
    public func setupCell(storyValue: StoryValue, anchor: PlayerVerticalAnchor?, delegate: StoryWebViewDelegate) {
        storyPlayer = StoryPlayer(frame: contentView.frame)
        storyPlayer.navigationDelegate = delegate
        storyPlayer.addDelegate(delegate)
        storyPlayer.loadStory(story: storyValue)
        // Screen should take the lower part of the screen and
        let screenHeight = UIScreen.main.bounds.size.height
        var maxHeight: CGFloat = contentView.frame.size.width * heightConstraintRatio
        if screenHeight < maxHeight {
            maxHeight = screenHeight
        }
        addSubview(storyPlayer)
        storyPlayer.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintIgnoringSafeArea = storyPlayer.topAnchor.constraint(equalTo: topAnchor)
        let topConstraintWithSafeArea = storyPlayer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        let bottomConstraint = storyPlayer.bottomAnchor.constraint(equalTo: bottomAnchor)

        // Update content position based on config
        // Bottom by default
        if let anchor = anchor {
            switch anchor {
            case .topIgnoringSafeArea:
                NSLayoutConstraint.activate([
                    storyPlayer.heightAnchor.constraint(equalToConstant: maxHeight),
                    storyPlayer.widthAnchor.constraint(equalTo: widthAnchor),
                    topConstraintIgnoringSafeArea
                ])
            case .topWithSafeArea:
                NSLayoutConstraint.activate([
                    storyPlayer.heightAnchor.constraint(equalToConstant: maxHeight),
                    storyPlayer.widthAnchor.constraint(equalTo: widthAnchor),
                    topConstraintWithSafeArea
                ])
            case .bottom:
                NSLayoutConstraint.activate([
                    storyPlayer.heightAnchor.constraint(equalToConstant: maxHeight),
                    storyPlayer.widthAnchor.constraint(equalTo: widthAnchor),
                    bottomConstraint
                ])
            }
        } else {
            NSLayoutConstraint.activate([
                storyPlayer.heightAnchor.constraint(equalToConstant: maxHeight),
                storyPlayer.widthAnchor.constraint(equalTo: widthAnchor),
                anchor == .bottom ? bottomConstraint : topConstraintIgnoringSafeArea,
            ])
        }

    }
    
}
