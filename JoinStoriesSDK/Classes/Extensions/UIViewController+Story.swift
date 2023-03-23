//
//  UIViewController+StorySheet.swift
//  JoinStoriesSDK
//
//  Created by JOIN on 09/01/2021.
//

import Foundation
import SafariServices

extension UIViewController {
    public func presentStorySheet(story: StoryValue, animated: Bool) {
        if let url = URL(string: story.url) {
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
            present(safariViewController, animated: animated)
        }
    }
    
    /// Present a ViewController with a Standalone configuration
    public func presentStoryPlayer(
        stories: [StoryValue],
        beginningAt indexPath: IndexPath? = nil,
        animated: Bool,
        onDismiss: (() -> Void)? = nil) {
            DispatchQueue.main.async {
                let storyPlayerViewController = StoryPlayerViewController()
                storyPlayerViewController.configType = .standalone
                storyPlayerViewController.stories = stories
                if let indexPath = indexPath {
                    storyPlayerViewController.scrollIndexPath = indexPath
                }
                storyPlayerViewController.modalPresentationStyle = .custom
                storyPlayerViewController.transitioningDelegate = storyPlayerViewController
                storyPlayerViewController.view.frame = self.view.bounds
                let interactiveTransition = StoryCircularInteractiveTransition()
                storyPlayerViewController.interactiveTransition = interactiveTransition
                interactiveTransition.attach(to: storyPlayerViewController)
                storyPlayerViewController.presentPlayer(viewController: self, animated: animated, onDismiss: onDismiss)
            }
        }

}

extension StoryTransitionViewController {
    
    /// Present a StoryTransitionViewController with a ThumbView configuration
    func presentStoryPlayerController(
        stories: [StoryValue],
        at indexPath: IndexPath,
        animated: Bool) {
            let storyPlayerViewController = StoryPlayerViewController()
            storyPlayerViewController.configType = .thumbview
            storyPlayerViewController.interactiveTransition = interactiveTransition
            storyPlayerViewController.stories = stories
            storyPlayerViewController.scrollIndexPath = indexPath
            storyPlayerViewController.view.frame = view.bounds
            storyPlayerViewController.modalPresentationStyle = .custom
            storyPlayerViewController.transitioningDelegate = self
            storyPlayerViewController.delegate = self
            interactiveTransition.attach(to: storyPlayerViewController)
            storyPlayerViewController.loadAndPresent(viewController: self, animated: animated)
    }
}
