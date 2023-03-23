//
//  ImageLoader.swift
//  JoinStoriesSDK
//
//  Created by Audrey SOBGOU ZEBAZE on 25/09/2022.
//

import Foundation
import UIKit

public enum ImageLoaderError: Error {
    case noData
    case common(error: Error)
}

public final class ImageLoader {
    public static let shared = ImageLoader()

    private let cache: ImageCacheType
    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()

    public init(cache: ImageCacheType = ImageCache()) {
        self.cache = cache
    }

    public func loadImage(from url: URL, completion: @escaping (Result<UIImage?, ImageLoaderError>) -> Void) {
        if let image = cache[url] {
            completion(.success(image))
        }
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            if let error = error {
                completion(.failure(.common(error: error)))
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            guard let imageFromData = UIImage(data: data) else {
                return completion(.success(nil))
            }
            self?.cache[url] = imageFromData
            DispatchQueue.main.async {
                completion(.success(imageFromData))
            }

        })
        .resume()
    }
}
