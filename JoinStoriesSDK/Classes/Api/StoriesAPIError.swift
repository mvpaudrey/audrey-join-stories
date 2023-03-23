import Foundation

@objc
public enum StoriesAPIError: Int, Error {
    
    case configurationNotFound
    case configurationNoTeamFound
    case noData
    case fetchingStoriesTimedOut
    case fetchingStoriesFailed
}
