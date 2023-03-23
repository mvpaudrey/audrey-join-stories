import QuartzCore

extension CALayer {
    
    /// function to add animation to layer without key
    func add<A: CAAnimation>(animation: A, forKey: String? = nil) {
        self.add(animation, forKey: forKey)
    }
}
