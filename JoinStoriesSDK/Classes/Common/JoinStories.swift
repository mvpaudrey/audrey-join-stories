import Foundation
import UIKit

public typealias StoriesCompletionHandler = (Result<Void, StoriesAPIError>) -> Void

public typealias RNStoriesCompletionHandler = (Bool, StoriesAPIError?) -> Void

@objc
final public class JoinStories: NSObject {
    
    // MARK: - Properties

    @objc
    static public let shared = JoinStories()
    
    static var configuration: JoinConfiguration?
    
    static var thumbViewConfig: JoinStoriesThumbConfig?

    static var standaloneConfig: JoinStoriesStandaloneConfig?

    @available(*, deprecated, message: "This will be removed. Please use `storyConfig")
    static var viewConfig: StoryViewConfig?

    static var storyConfig: JoinStoriesConfig?

    private var presentedController: UIViewController?

    private let storiesApi: StoriesApiSpec = StoriesApi(baseUrl: API.baseUrl, timeoutInterval: storyConfig?.requestTimeoutInterval ?? API.defaultTimeoutInterval)

    // MARK: - Initializers
    
    private override init() {}
    
    // MARK: - Configuration
    
    @available(*, deprecated, message: "This will be removed. Please use `setConfiguration(_ configuration:)` instead")
    public static func setConfiguration(_ configuration: JoinConfiguration, viewConfig: StoryViewConfig? = nil) {
        self.configuration = configuration
        if let viewConfig = viewConfig {
            self.viewConfig = viewConfig
        } else { // Instantiate with default values
            self.viewConfig = StoryViewConfig()
        }
    }

    @objc
    public static func setConfiguration(_ configuration: JoinConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: - Launching methods

    @available(*, deprecated, message: "This will be removed. Please use `startThumbView(config:completion:)` instead")
    public static func startThumbView(alias: String, completion: @escaping StoriesCallback) {
        JoinStories.shared.fetchStories(alias: alias, completion: completion)
    }

    /// Native iOS only
    /// For React Native integration, use `startThumbView(config:completion:)` with `RNStoriesCallback`
    public static func startThumbView(config: JoinStoriesThumbConfig, completion: @escaping StoriesCallback) {
        JoinStories.thumbViewConfig = config
        JoinStories.shared.fetchStories(config: config, completion: completion)
    }

    /// Use only for React Native integration
    dynamic public static func startThumbView(config: JoinStoriesThumbConfig, completion: @escaping RNStoriesCallback) {
        JoinStories.thumbViewConfig = config
        JoinStories.shared.fetchStories(config: config, completion: completion)
    }

    @available(*, deprecated, message: "This will be removed. Please use `startPlayer(config:fromController:completion:onDismiss)` instead")
    public static func startPlayer(alias: String, fromController controller: UIViewController,
                                   completion: @escaping StoriesCompletionHandler,
                                   onDismiss: (() -> Void)? = nil) {
        JoinStories.shared.startPlayer(alias: alias, fromController: controller, completion: completion, onDismiss: onDismiss)
    }

    /// Native iOS only
    /// For React Native integration, use `startPlayer(config:fromController:completion:onDismiss:)` with `RNStoriesCompletionHandler
    public static func startPlayer(config: JoinStoriesStandaloneConfig, fromController controller: UIViewController,
                                   completion: @escaping StoriesCompletionHandler,
                                   onDismiss: (() -> Void)? = nil) {
        JoinStories.shared.startPlayer(config: config, fromController: controller, completion: completion, onDismiss: onDismiss)
    }

    /// Use only for React Native integration
    dynamic public static func startPlayer(
        config: JoinStoriesStandaloneConfig,
        fromController controller: UIViewController,
        completion: @escaping RNStoriesCompletionHandler,
        onDismiss: (() -> Void)? = nil) {
            JoinStories.shared.startPlayer(
                config: config,
                fromController: controller,
                completion: completion,
                onDismiss: onDismiss
            )
    }

    @objc dynamic public static func stopPlayer() {
        JoinStories.shared.stopPlayer()
    }
    
    // MARK: - Helpers
    
    @available(*, deprecated, message: "This will be removed. Please use `fetchStories(config:completion:)` instead")
    /// Fetch Stories for ThumbView
    public func fetchStories(alias: String, completion: @escaping StoriesCallback) {
        storiesApi.fetchStories(alias: alias, completion: completion)
    }

    /// Use only for Native iOS integration
    /// For React Native integration, use `fetchStories(config:completion:)` with `RNStoriesCallback`
    public func fetchStories(config: JoinStoriesConfig, completion: @escaping StoriesCallback) {
        storiesApi.fetchStories(config: config, completion: completion)
    }

    /// Use only for React Native integration
    dynamic public func fetchStories(config: JoinStoriesConfig, completion: @escaping RNStoriesCallback) {
        storiesApi.fetchStories(config: config, completion: completion)
    }

    @available(*, deprecated, message: "This will be removed. Please use `fetchStories(config:completion:)` instead")
    /// Start player for standalone player
    public func startPlayer(alias: String, fromController controller: UIViewController, completion: @escaping StoriesCompletionHandler, onDismiss: (() -> Void)? = nil ) {
        JoinStories.shared.fetchStories(alias: alias) { [weak self] result in
            switch result {
            case .success(let stories):
                    controller.presentStoryPlayer(
                        stories: stories,
                        animated: true,
                        onDismiss: onDismiss)
                self?.presentedController = controller
                completion(.success(()))
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    /// Start player for standalone player
    /// Use only for Native iOS integration
    /// For React Native, use `startPlayer(config:fromController:completion:onDismiss:)` with `RNStoriesCompletionHandler`
    public func startPlayer(config: JoinStoriesStandaloneConfig, fromController controller: UIViewController, completion: @escaping StoriesCompletionHandler, onDismiss: (() -> Void)? = nil ) {
        JoinStories.standaloneConfig = config
        JoinStories.shared.fetchStories(config: config) { [weak self] result in
            switch result {
            case .success(let stories):
                    controller.presentStoryPlayer(
                        stories: stories,
                        animated: true,
                        onDismiss: onDismiss)
                self?.presentedController = controller
                completion(.success(()))
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    /// Start player for standalone player
    /// Use only for React Native integration
    dynamic public func startPlayer(
        config: JoinStoriesStandaloneConfig,
        fromController controller: UIViewController,
        completion: @escaping RNStoriesCompletionHandler,
        onDismiss: (() -> Void)? = nil ) {
        JoinStories.standaloneConfig = config
        JoinStories.shared.fetchStories(config: config) { [weak self] stories, error in
            if let error = error {
                completion(false, error)
                return
            }
            guard let stories = stories else {
                completion(false, .noData)
                return
            }

            controller.presentStoryPlayer(
                stories: stories,
                animated: true,
                onDismiss: onDismiss)
            self?.presentedController = controller
            completion(true, nil)
        }
    }

    @objc dynamic public func stopPlayer() {
        presentedController?.dismiss(animated: true)
        presentedController = nil
    }
    
    @available(*, deprecated, message: "This will be removed. Please use `getThumbViewConfig` instead")
    public func getViewConfig() -> StoryViewConfig? {
        JoinStories.viewConfig
    }
        
    public func getThumbViewConfig() -> JoinStoriesThumbConfig? {
        JoinStories.thumbViewConfig
    }

    public func thumbAndLabelDimensions(ratio: Double = 0.7) -> (thumbWidth: Int, labelWidth: Int) {
        guard let config = JoinStories.thumbViewConfig else {
            return (0,0)
        }
        return config.getThumbAndLabelDimensions(ratio: ratio)
    }
    
    public func containerDimension() -> Int {
        guard let config = JoinStories.thumbViewConfig else {
            return 0
        }
        return config.containerDimension
    }
    
    public func thumbViewSpacing() -> Int {
        guard let config = JoinStories.thumbViewConfig else {
            return 0
        }
        return config.getThumbViewSpacing()
    }
            
}
