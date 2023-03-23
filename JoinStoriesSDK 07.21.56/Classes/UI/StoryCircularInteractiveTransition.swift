import UIKit

public enum CircularInteractiveTransitionSwipeDirection: CGFloat {
    case up = -1
    case down = 1
}

open class StoryCircularInteractiveTransition: UIPercentDrivenInteractiveTransition {
    fileprivate var interactionStarted = false
    fileprivate var interactionShouldFinish = false
    fileprivate var controller: UIViewController?
    
    /// The threshold that grants the dismissal of the controller. Values from 0 to 1
    open var interactionThreshold: CGFloat = 0.3
    
    /// The swipe direction
    open var swipeDirection: CircularInteractiveTransitionSwipeDirection = .down
    
    /// Attach the swipe gesture to a controller
    ///
    /// - Parameter to: the target controller
    open func attach(to: UIViewController) {
        controller = to
        wantsInteractiveStart = false
    }
        
}
