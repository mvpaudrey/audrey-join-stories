import Foundation

@objc
final public class JoinConfiguration: NSObject {
    
    let team: String
            
    public init(team: String) {
        self.team = team
    }
    
}
