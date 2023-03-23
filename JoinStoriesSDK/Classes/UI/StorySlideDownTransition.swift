//
//  StoryDropDownTransition.swift
//  JoinStoriesSDK
//
//  Created by Audrey SOBGOU ZEBAZE on 01/09/2022.
//

import UIKit

/// This class will inherit from NSObject and will implement the
/// UIViewControllerAnimatedTransitioning protocol for the transition from top to bottom
public class StorySlideDownTransition: NSObject, StoryAnimatable {

    public var startingPoint = CGPoint.zero

    public var circle = UIView()

    public var transitionMode: TransitionMode = .present

    public var circleColor: UIColor = .white

    var isPresenting: Bool = true

    var duration = 0.5

}

extension StorySlideDownTransition: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Retrieve the view controllers participating in the current transition from the context.
        guard let toView = transitionContext.viewController(forKey: .to)?.view,
              let fromView = transitionContext.viewController(forKey: .from)?.view else { return }

        let topDownView = (transitionMode == .present) ? toView : fromView

         if transitionMode == .present {
             // Any presented views must be part of the container view's hierarchy
             transitionContext.containerView.addSubview(topDownView)
         }

         /***** Animation *****/

         let topDownSize = CGSize(
             width: UIScreen.main.bounds.size.width,
             height: UIScreen.main.bounds.size.height)

         let offScreenFrame = CGRect(origin: CGPoint(x: 0, y: topDownSize.height * -1), size: topDownSize)
         let onScreenFrame = CGRect(origin: .zero, size: topDownSize)

         topDownView.frame = (transitionMode == .present) ? offScreenFrame : onScreenFrame

         let animationDuration = transitionDuration(using: transitionContext)

         UIView.animate(withDuration: animationDuration, animations: {
             topDownView.frame = (self.transitionMode == .present) ? onScreenFrame : offScreenFrame
         }, completion: { [weak self] (success) in
             guard let self = self else { return }
             // Cleanup view hierarchy
             if !(self.transitionMode == .present) {
                 topDownView.removeFromSuperview()
             }

             // IMPORTANT: Notify UIKit that the transition is complete.
             transitionContext.completeTransition(success)
         })
    }

}
