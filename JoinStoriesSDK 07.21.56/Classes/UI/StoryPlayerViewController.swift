//
//  StoryPlayerViewController.swift
//  JoinStoriesSDK
//
//  Created by JOIN on 09/01/2021.
//

import Foundation
import WebKit

@objc
public protocol StoryNavigationDelegate {
    
    /// Save as `seen` when navigating through stories
    func storyItemShown(at indexPath: IndexPath)
}

@objc
public class StoryPlayerViewController: UIViewController, StoryWebViewDelegate, WKNavigationDelegate {

    var configType: JoinStoriesConfigType?

    var thumbViewConfig: JoinStoriesThumbConfig?
    var standaloneConfig: JoinStoriesStandaloneConfig?


    @objc
    public var startingPoint: CGPoint = .zero {
        didSet {
            transition.startingPoint = self.startingPoint
        }
    }
    
    var stories: [StoryValue] = []

    var onceOnly = false
    
    var story: StoryValue? = nil
    var storyPlayer: StoryPlayer = StoryPlayer()
    var parentView: UIViewController = UIViewController()
    var playerAnimationIn: Bool = true
    
    var delegate: StoryNavigationDelegate?
    
    var onDismiss: (() -> Void)? = nil
    
    private var parentViewPresented: Bool = false
    
    var scrollIndexPath: IndexPath = IndexPath(item: 0, section: 0) {
        didSet {
            // Update story selected from previous viewController
            guard let story = stories[safe: scrollIndexPath.row] else { return }
            self.story = story
            storyPlayer.story = story
        }
    }

    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(StoryPlayerCollectionViewCell.self, forCellWithReuseIdentifier: StoryPlayerCollectionViewCell.reuseIdentifier)
        return cv
    }()
    
    private var lastContentOffset: CGFloat = 0.0
    
    public var transition: StoryAnimatable = StoryCircularTransition()
    weak var interactiveTransition: StoryCircularInteractiveTransition?

    @objc
    public init() {
        self.thumbViewConfig = JoinStories.thumbViewConfig
        self.standaloneConfig = JoinStories.standaloneConfig
        if let standaloneConfig = standaloneConfig {
            switch standaloneConfig.playerStandaloneAnimationOrigin {
            case .`default`, .topLeft, .topRight, .bottomLeft, .bottomRight:
                self.transition = StoryCircularTransition()
            case .top:
                self.transition = StorySlideDownTransition()
            case .bottom:
                self.transition = StorySlideUpTransition()
            }
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    /// Loaded from ThumbView
    func loadAndPresent(viewController: StoryTransitionViewController, animated: Bool) {
        parentView = viewController
        playerAnimationIn = animated
        
        setupStoryPlayer()
        
        self.view.backgroundColor = UIColor.black
        
        self.navigationController?.setNavigationBarHidden(true, animated: playerAnimationIn)
        
        if let storyValue = story {
            storyPlayer.story = storyValue
            storyPlayer.loadStory(story: storyValue)
        }
        
        // ScrollViewDidScroll is called when indexPath.row is different from row = 0
        // So we need to deal with that first index here
        if scrollIndexPath.row == 0 {
            delegate?.storyItemShown(at: scrollIndexPath)
        }
    }

    /// Player only
    func presentPlayer(viewController: UIViewController, animated: Bool = false, onDismiss: (() -> Void)? = nil) {
        guard let storyValue = stories.first else {
            return
        }
        parentView = viewController
        setupStoryPlayer()
        self.story = storyValue
        storyPlayer.story = storyValue
        storyPlayer.loadStory(story: storyValue)
        self.onDismiss = onDismiss
    }

    func transitionOrigin(_ origin: PlayerStandaloneAnimationOrigin?) {
        guard let origin = origin else { return }
        switch origin {
        case .`default`:
            startingPoint = CGPoint(x: view.frame.width / 2, y: view.frame.height)
        case .topLeft:
            startingPoint = CGPoint.zero
        case .topRight:
            startingPoint = CGPoint(x: view.frame.width, y: 0)
        case .bottomLeft:
            startingPoint = CGPoint(x: 0, y: view.frame.height)
        case .bottomRight:
            startingPoint = CGPoint(x: view.frame.width, y: view.frame.height)
        case .top, .bottom:
            break
        }
    }
    
    private func setupStoryPlayer() {
        storyPlayer = StoryPlayer(frame: self.view.frame)
        storyPlayer.frame = view.bounds
        storyPlayer.navigationDelegate = self
        storyPlayer.addDelegate(self)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.transitionOrigin(self.standaloneConfig?.playerStandaloneAnimationOrigin)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        view = collectionView
    }
    
    @objc
    public override var prefersStatusBarHidden: Bool {
        return true
    }

    var playerAnchor: PlayerVerticalAnchor {
        if let configType = self.configType {
            switch configType {
            case .standalone:
                return standaloneConfig?.playerVerticalAnchor ??
                JoinStoriesStandaloneDefaultConfig.shared.playerVerticalAnchor
            case .thumbview:
                return thumbViewConfig?.playerVerticalAnchor ?? .bottom

            }
        }
        return .bottom
    }

    func updateBackgroundCell(_ cell: StoryPlayerCollectionViewCell) {
        if let type = configType {
            switch type {
            case .standalone:
                cell.backgroundColor = self.standaloneConfig?.playerBackgroundColor
                break
            case .thumbview:
                cell.backgroundColor = self.thumbViewConfig?.playerBackgroundColor
            }
        }
    }
    
    // MARK: - WKNavigationDelegate
    
    @objc
    public func webView(_ webView: WKWebView,
                        didFinish navigation: WKNavigation!) {
        storyPlayer.state = .initial
        if !parentViewPresented {
            parentView.present(self, animated: true) {
                for cell in self.collectionView.visibleCells {
                    if let cell = cell as? StoryPlayerCollectionViewCell {
                        self.updateBackgroundCell(cell)
                    }
                }
            }
            parentViewPresented = true
        }
    }

    @objc
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }

    @objc
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        storyPlayer.state = .loading
    }

    @objc
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        storyPlayer.state = .initial
    }

    @objc
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        storyPlayer.state = .initial
    }
    
    // MARK: Scrolling

    @objc
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.x
        updateCurrentScrollIndex()
        delegate?.storyItemShown(at: scrollIndexPath)
    }
    
    private func updateCurrentScrollIndex() {
        let currentRow = Int(lastContentOffset / collectionView.frame.width)
        scrollIndexPath.row = currentRow
    }
    
    // MARK: StoryWebViewDelegate

    @objc
    public func onPlayerDismiss() {
        storyPlayer.stopLoading()
        for cell in collectionView.visibleCells {
            if let cell = cell as? StoryPlayerCollectionViewCell {
                cell.backgroundColor = .clear
            }
        }
        dismiss(animated: true, completion: onDismiss)
    }

    @objc
    public func didReceiveNoPreviousPageListener(on story: StoryValue) {
        if story == self.story {
            advanceToPreviousStory()
        }
    }

    @objc
    public func didReceiveNoNextPageListener(on story: StoryValue) {
        if story == self.story {
            advanceToNextStory()
        }
    }
    
    private func advanceToPreviousStory() {
        let previousItemRow = scrollIndexPath.row - 1
        guard stories[safe: previousItemRow] != nil && previousItemRow >= 0 else {
            dismiss(animated: true, completion: onDismiss)
            return
        }
        collectionView.scrollToPreviousItem()
        scrollIndexPath.row -= 1
    }
    
    private func advanceToNextStory() {
        let nextItemRow = scrollIndexPath.row + 1
        let itemsCount = collectionView.numberOfItems(inSection: scrollIndexPath.section)
        guard stories[safe: nextItemRow] != nil && nextItemRow < itemsCount else {
            dismiss(animated: true, completion: onDismiss)
            return
        }
        collectionView.scrollToNextItem()
        scrollIndexPath.row += 1
    }
    
}

// MARK: - UICollectionViewDataSource

extension StoryPlayerViewController: UICollectionViewDataSource {

    @objc
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    @objc
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stories.count
    }

    @objc
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryPlayerCollectionViewCell", for: indexPath) as? StoryPlayerCollectionViewCell else {
            return UICollectionViewCell()
        }
        let currentStory = stories[indexPath.item]
        cell.setupCell(storyValue: currentStory, anchor: playerAnchor, delegate: self)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension StoryPlayerViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDelegate

    @objc
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !onceOnly {
            collectionView.scrollToItem(at: scrollIndexPath, at: .left, animated: false)
            onceOnly = true
        } else {
            if let cell = cell as? StoryPlayerCollectionViewCell, scrollIndexPath != indexPath {
                updateBackgroundCell(cell)
            }
        }
    }

    @objc
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }

    @objc
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout

    @objc
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    @objc
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
        
}

// MARK: UIViewControllerTransitioningDelegate

/// Use to animate presenting ViewController on Standalone player mode
extension StoryPlayerViewController: UIViewControllerTransitioningDelegate {

    @objc
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = self.startingPoint
        if let color = self.view.backgroundColor {
            transition.circleColor = color
        }

        guard let transition = transition as? UIViewControllerAnimatedTransitioning else {
            return nil
        }
        return transition
    }

    @objc
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = self.startingPoint
        if let color = self.view.backgroundColor {
            transition.circleColor = color
        }
        guard let transition = transition as? UIViewControllerAnimatedTransitioning else {
            return nil
        }
        return transition
    }
}
