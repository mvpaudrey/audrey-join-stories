import Foundation

enum StoryEventListener: String {
    
    case noPreviousPageListener
    case noNextPageListener
    case switchPageListener
    
    var name: String {
        self.rawValue
    }
}
