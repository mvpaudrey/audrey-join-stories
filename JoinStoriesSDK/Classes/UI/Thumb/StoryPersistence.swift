import Foundation

class StoryPersistence: StoryPersistable {
    
    private static let userDefaultsKey = "storiesSeen"
    
    private let userDefaults = UserDefaultsManager.userDefaults
        
    func markAsSeen(id: String) {
        var arrayOfSeen = retrieveSeenStories()
        if !arrayOfSeen.contains(id) {
            arrayOfSeen.append(id)
            userDefaults.set(arrayOfSeen, forKey: StoryPersistence.userDefaultsKey)
        }
    }
    
    func storyIsSeen(id: String) -> Bool {
        let arrayOfSeen = retrieveSeenStories()
        return arrayOfSeen.contains(id)
    }
    
    private func retrieveSeenStories() -> [String] {
        userDefaults.stringArray(forKey: StoryPersistence.userDefaultsKey) ?? [String]()
    }
    
}
