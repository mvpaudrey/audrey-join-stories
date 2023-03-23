import UIKit

class MainViewController: UIViewController {
    
    private var stackView: UIStackView!
    
    private let stackViewSpacing: CGFloat = 20
    
    private let buttonHeight: CGFloat = 44
    
    private var contentView: UIView!
    
    private var contentViewHeight: CGFloat {
        stackViewSpacing + (buttonHeight * 2)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: contentViewHeight)
        ])
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = stackViewSpacing
        
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
        
        let thumbViewButton = UIButton(type: .custom)
        thumbViewButton.setTitle("ThumbView (avec bulles)", for: [])
        thumbViewButton.setTitleColor(.black, for: .normal)
        thumbViewButton.backgroundColor = .white
        thumbViewButton.layer.cornerRadius = 10
        thumbViewButton.addTarget(self, action: #selector(showThumbViewController), for: .touchUpInside)
        stackView.addArrangedSubview(thumbViewButton)

        thumbViewButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbViewButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        
        let playerButton = UIButton(type: UIButton.ButtonType.custom)
        playerButton.setTitle("Player (sans bulles)", for: [])
        playerButton.setTitleColor(.black, for: [])
        playerButton.backgroundColor = .white
        playerButton.layer.cornerRadius = 10
        playerButton.addTarget(self, action: #selector(showPlayerOnlyViewController), for: .touchUpInside)
        stackView.addArrangedSubview(playerButton)

        playerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])

    }
    
    @objc private func showThumbViewController(sender: UIButton!) {
        let thumbViewController = ThumbViewController()
        self.navigationController?.pushViewController(thumbViewController, animated: true)
    }
    
    @objc private func showPlayerOnlyViewController(sender: UIButton!) {
        let playerOnlyViewController = PlayerOnlyViewController()
        self.navigationController?.pushViewController(playerOnlyViewController, animated: true)
    }
    
}

