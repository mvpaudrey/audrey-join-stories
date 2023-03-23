import UIKit

/// API related constants
struct API {
    
    static let baseUrl: String = "https://api.stories.studio/v1/teams/"
    static let defaultTimeoutInterval: TimeInterval = 60
}

/// Constant structure for animation keypath
struct KeyPath {
    static let rotation = "transform.rotation"
}

/// Constant structure for animation parameter
struct Parameter {
    static let duration: Double = 0.3
    static let scale: CGFloat = 0.9
}
