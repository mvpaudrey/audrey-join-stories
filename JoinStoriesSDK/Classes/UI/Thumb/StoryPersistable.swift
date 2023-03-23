import Foundation

public protocol StoryPersistable: AnyObject {
    
    /// Mark a story as `seen` when `unseen`
    func markAsSeen(id: String)
    
    /// Determine if a story is seen
    func storyIsSeen(id: String) -> Bool
}
