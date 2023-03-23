//
//  StoryWebView.swift
//  JoinStoriesSDK
//
//  Created by JOIN on 09/01/2021.
//

import Foundation
import WebKit

public protocol StoryWebViewDelegate: WKNavigationDelegate {
    func onPlayerDismiss()
    func didReceiveNoPreviousPageListener(on story: StoryValue)
    func didReceiveNoNextPageListener(on story: StoryValue)
}

@objcMembers
public class StoryPlayer: WKWebView, WKScriptMessageHandler {
    
    var story: StoryValue? = nil
    
    var delegate: StoryWebViewDelegate?
    
    private let notificationCenter: NotificationCenter = .default
    
    private var userScript: WKUserScript {
        let source = """
        window.addEventListener('ampstory:nopreviouspage', ()=>{ window.webkit.messageHandlers.noPreviousPageListener.postMessage('click clack no Previous!'); })
            window.addEventListener('ampstory:nonextpage', ()=>{ window.webkit.messageHandlers.noNextPageListener.postMessage('click clack! no Next'); })
            window.addEventListener('ampstory:switchpage', ()=>{ window.webkit.messageHandlers.switchPageListener.postMessage('switchpage'); })
        """
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
    }
        
    var state = State.initial {
        // We add a property observer on 'state', which lets us
        // run a function on each value change.
        didSet { stateDidChange() }
    }
        
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public init(frame: CGRect) {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.preferences = preferences
        super.init(frame: frame, configuration: configuration)
        configuration.userContentController.addUserScript(self.userScript)
        configuration.userContentController.add(
            self, name: StoryEventListener.noPreviousPageListener.name)
        configuration.userContentController.add(
            self, name: StoryEventListener.noNextPageListener.name)
        configuration.userContentController.add(
            self, name: StoryEventListener.switchPageListener.name)
        self.setupView()
    }
    
    public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        self.setupView()
    }
    
    func setupView() {
        // empty
    }
    
    public override func layoutSubviews() {
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        swipeDownRecognizer.direction = .down
        
        self.addGestureRecognizer(swipeDownRecognizer)
    }
    
    public func addDelegate(_ delegate: StoryWebViewDelegate?) {
        self.delegate = delegate
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let story = story else { return }
        if message.name == StoryEventListener.noPreviousPageListener.name {
            self.delegate?.didReceiveNoPreviousPageListener(on: story)
            
        } else if message.name == StoryEventListener.noNextPageListener.name {
            self.delegate?.didReceiveNoNextPageListener(on: story)
        }
    }
    
    func loadStory(story: StoryValue) {
        self.story = story
        self.scrollView.bounces = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.isScrollEnabled = false
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        self.scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let url = URL(string: story.url) {
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
            self.load(request)
        }
    }
    
    @objc private func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        if (recognizer.direction == .down) {
            self.delegate?.onPlayerDismiss()
        }
    }
}

extension StoryPlayer {
    
    enum State {
        case initial
        case loading
    }
}

private extension StoryPlayer {
    
    func stateDidChange() {
        switch state {
        case .initial:
            notificationCenter.post(name: .storyPlayerStoppedLoading, object: story)
        case .loading:
            notificationCenter.post(name: .storyPlayerStartedLoading, object: story)
        }
    }
}
