import UIKit
import JoinStoriesSDK

/// PlayerOnlyViewController can launch StoryPlayer without using thumbViews
/// You will need top on button
class PlayerOnlyViewController: UIViewController {
    
    private let buttonHeight: CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        let launchPlayerButton = UIButton(type: .custom)
        launchPlayerButton.setTitle("Lancer le player", for: [])
        launchPlayerButton.setTitleColor(.black, for: .normal)
        launchPlayerButton.backgroundColor = .white
        launchPlayerButton.layer.cornerRadius = 10
        launchPlayerButton.addTarget(self, action: #selector(launchPlayer), for: .touchUpInside)
        
        view.addSubview(launchPlayerButton)

        launchPlayerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            launchPlayerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            launchPlayerButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            launchPlayerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            launchPlayerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    @objc private func launchPlayer(sender: UIButton!) {
        let config = JoinStoriesStandaloneConfig(
            alias: "widget-test-sdk",
            requestTimeoutInterval: 15,
            playerBackgroundColor: .black,
            playerStandaloneAnimationOrigin: .default,
            playerVerticalAnchor: .topIgnoringSafeArea
        )
        JoinStories.startPlayer(config: config, fromController: self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("LaunchPlayer: Success")
                case .failure(let error):
                    self?.showError(error)
                }
            }
        } onDismiss: {
            print("Player Dismissed")
            self.presentAlert(title: "Player", message: "The player has been dismissed!")
        }
    }
    
}
