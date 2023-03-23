import Foundation

extension Notification.Name {
    
    // MARK: - Story Player
    
    static var storyPlayerStartedLoading: Notification.Name {
        return .init(rawValue: "StoryPlayer.startedLoading")
    }

    static var storyPlayerStoppedLoading: Notification.Name {
        return .init(rawValue: "StoryPlayer.stoppedLoading")
    }
}
