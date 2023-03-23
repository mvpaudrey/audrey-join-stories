import UIKit
import JoinStoriesSDK

class ThumbViewController: StoryTransitionViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var activityIndicator = UIActivityIndicatorView()
            
    let joinStories = JoinStories.shared

    @objc func willEnterForeground() {
        // We re-load stories when the app re-open
        startThumbView()
    }
    
    private func startThumbView() {
        let config = JoinStoriesThumbConfig(
            alias: "widget-test-sdk", // "demo-bulles",
            requestTimeoutInterval: 15,
            containerDimension: 150,
            labelColor: UIColor.gray,
            thumbViewSpacing: 32,
            loaderInnerViewColor : [UIColor.black],
            loaderColors : [UIColor.red, UIColor.blue],
            loaderInnerViewWidth: 2,
            loaderWidth: 3,
            storyViewedIndicatorColor: UIColor.gray,
            storyViewedIndicatorAlpha: 0.8,
            thumbViewOverlayColor: UIColor(hex8: 0x4C4C4CBB),
            playerBackgroundColor: .black,
            playerVerticalAnchor: .bottom
        )

        JoinStories.startThumbView(config: config) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                switch result {
                case .success(let stories):
                    self?.stories = stories
                    self?.collectionView.reloadData()
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add view controller as DataSource of `collectionView`
        collectionView.dataSource = self
        // Add a notification observer to know when the app is becoming active
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        self.view.backgroundColor = .black
        
        // Create an optional loader in case of bad network condition
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // On Load, fetch the stories from the Join public API
        startThumbView()
    }
    
    /// UICollectionViewDelegateFlowLayout should be implemented to match storyConfig parameters
    // MARK: UICollectionViewDelegateFlowLayout

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: joinStories.thumbAndLabelDimensions().0,
               height: joinStories.containerDimension())
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        CGFloat(joinStories.thumbViewSpacing())
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stories.count
    }
    
    // MARK: - UICollectionViewDataSource
    
    /// Configure cell with ratio between height and width of the cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.reuseIdentifier, for: indexPath) as? StoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        let story = self.stories[indexPath.item]
        guard let storyConfig = joinStories.getThumbViewConfig() else {
            return UICollectionViewCell()
        }
        cell.setupCell(storyValue: story, with: storyConfig, ratio: 0.7)
        return cell
    }
}
