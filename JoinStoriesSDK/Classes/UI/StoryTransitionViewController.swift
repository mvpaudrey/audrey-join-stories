import UIKit

/// Used for custom transition
/// Implement UIViewControllerTransitioningDelegate`
/// See https://developer.apple.com/documentation/uikit/animation_and_haptics/view_controller_transitions
@objc
open class StoryTransitionViewController: UIViewController {
    
    /// Stories array to display
    @objc open var stories: [StoryValue] = []
    
    /// Transition when displaying stories
    /// Implement animations for our class
    /// Conforms to `UIViewControllerAnimatedTransitioning` protocol
    /// See https://developer.apple.com/documentation/uikit/uiviewcontrolleranimatedtransitioning
    @objc open var transition = StoryCircularTransition()
    
    /// Interactive Transition when displaying stories
    /// Inherits from `UIPercentDrivenInteractiveTransition`
    /// See https://developer.apple.com/documentation/uikit/uipercentdriveninteractivetransition
    @objc open var interactiveTransition = StoryCircularInteractiveTransition()
    
    /// StartingPoint from where the transition begins
    /// With CollectionView, startingPoint correspond to center of the `collectionViewCell`
    @objc open var startingPoint: CGPoint = .zero
    
    /// CollectionView used to display thumbnails
    /// Init CollectionView with `collectionViewLayout` and register to `StoryCollectionViewCell`
    /// Should implement `UICollectionViewDelegate`
    @objc open var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: StoryCollectionViewCell.reuseIdentifier)
        return cv
    }()
    
    @objc override open func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        // collectionView dataSource is handled by child classes
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44) .isActive = true
        collectionView.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo:view.trailingAnchor,
                                                 constant: -20) .isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }

}

// MARK: - ScrollNavigation

extension StoryTransitionViewController: StoryNavigationDelegate {
    
    public func storyItemShown(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? StoryCollectionViewCell else {
            return
        }
        
        guard let storyAtIndex = stories[safe: indexPath.row] else { return }
        
        cell.storyPersistence.markAsSeen(id: storyAtIndex.id)
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - UICollectionViewDelegate

extension StoryTransitionViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        if let rect = cell?.frame {
            let centerInRootView = collectionView.convert(rect.center, to: view)
            self.startingPoint = centerInRootView
        }
        presentStoryPlayerController(stories: stories, at: indexPath, animated: true)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension StoryTransitionViewController: UIViewControllerTransitioningDelegate {
    
    @objc public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = self.startingPoint
        if let color = self.view.backgroundColor {
            transition.circleColor = color
        }
        return transition
    }
    
    @objc public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = self.startingPoint
        if let color = self.view.backgroundColor {
            transition.circleColor = color
        }
        return transition
    }
    
    @objc public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
      return interactiveTransition
    }
}
