import Foundation

public protocol StoryComponentsConfigurable {
    
    /// Get dimensions for both thumbview and it's description label
    /// This helps calculating collectionView cell size
    func getThumbAndLabelDimensions(ratio: Double) -> (thumbWidth: Int, labelWidth: Int)

}
