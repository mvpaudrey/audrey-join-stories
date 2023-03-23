import UIKit
import JoinStoriesSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let genenalConfiguration = JoinConfiguration(team: "join-showcase")
        
        JoinStories.setConfiguration(genenalConfiguration)
        
        let navigationController = UINavigationController()
        let mainView = MainViewController(nibName: nil, bundle: nil)
        navigationController.viewControllers = [mainView]
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
}
