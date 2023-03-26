import Foundation

@objc
final public class JoinConfiguration: NSObject {
    
    let team: String
            
    @objc
    public init(team: String) {
        self.team = team
    }
    
}
