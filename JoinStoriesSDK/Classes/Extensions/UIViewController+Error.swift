import UIKit

public extension UIViewController {
    
    func showError(_ error: StoriesAPIError) {
        let alert = UIAlertController(title: "Erreur", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
