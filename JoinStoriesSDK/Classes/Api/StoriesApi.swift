//
//  Api.swift
//  JoinStoriesSDK
//
//  Created by JOIN on 07/11/2020.
//

import Foundation

public typealias StoriesCallback = (Result<[StoryValue], StoriesAPIError>) -> Void

public typealias RNStoriesCallback = ([StoryValue]?, StoriesAPIError?) -> Void

public protocol StoriesApiSpec {
    
    @available(*, deprecated, message: "This will be removed. Please use `fetchStories(config:completion)` instead")
    func fetchStories(alias: String, completion: @escaping StoriesCallback)

    func fetchStories(config: JoinStoriesConfig, completion: @escaping StoriesCallback)

    /// React Native Only
    func fetchStories(config: JoinStoriesConfig, completion: @escaping RNStoriesCallback)

}

enum NetworkResponseResult<String>{
    case success
    case failure(String)
}

public class StoriesApi: StoriesApiSpec {

    private let router: Router<StoryEndPoint>
    
    /// The default timeout for each request is 60 seconds.
    public init(baseUrl: String, timeoutInterval: TimeInterval) {
        self.router = Router<StoryEndPoint>(timeoutInterval: timeoutInterval)
    }
    
    private func buildRoute(alias: String, completion: @escaping (Result<String, JoinConfigurationError>) -> Void) {
    
        guard let configuration = JoinStories.configuration else {
            completion(.failure(.noConfigurationFound))
            return
        }
        completion(.success(configuration.team))
    }

    private func buildRoute(completion: @escaping (Result<String, JoinConfigurationError>) -> Void) {

        guard let configuration = JoinStories.configuration else {
            completion(.failure(.noConfigurationFound))
            return
        }
        completion(.success(configuration.team))
    }

    /// Used for React native bridging code
    private func buildRouteRN(completion: @escaping (String?, JoinConfigurationError?) -> Void) {

        guard let configuration = JoinStories.configuration else {
            completion(nil, .noConfigurationFound)
            return
        }
        completion(configuration.team, nil)
    }

    private func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResponseResult<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    @available(*, deprecated, message: "This will be removed. Please use `fetchStories(config:completion)` instead")
    public func fetchStories(alias: String, completion: @escaping StoriesCallback) {
        buildRoute(alias: alias) { result in
            switch result {
            case .success(let team):
                self.router.request(.getStories(team: team, alias: alias)) { [weak self] data, response, error in
                    // Handle response error
                    if error != nil {
                        switch (error as? URLError)?.code {
                        case .some(.timedOut):
                            completion(.failure(.fetchingStoriesTimedOut))
                        default:
                            completion(.failure(.fetchingStoriesFailed))
                        }
                    }

                    guard let self = self, let response = response as? HTTPURLResponse else {
                        return completion(.success([]))
                    }
                    let responseResult = self.handleNetworkResponse(response)
                    switch responseResult {
                    case .success:
                        guard let responseData = data else {
                            completion(.failure(.noData))
                            return
                        }
                        do {
                            print(responseData)
                            let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                            print(jsonData)
                            let stories = try JSONDecoder().decode([StoryValue].self, from: responseData)
                            DispatchQueue.main.async {
                                completion(.success(stories))
                            }
                        } catch {
                            // Decoding Error
                            print(error)
                            completion(.failure(.fetchingStoriesFailed))
                        }
                    case .failure:
                        completion(.failure(.fetchingStoriesFailed))
                    }

                }

            case .failure(let configurationError):
                switch configurationError {
                case .noConfigurationFound:
                    completion(.failure(.configurationNotFound))
                case .noTeamFound:
                    completion(.failure(.configurationNoTeamFound))
                }
            }
        }
    }

    /// Use for native iOS integration only
    /// For React Native, use
    public func fetchStories(config: JoinStoriesConfig, completion: @escaping StoriesCallback) {
        buildRoute { result in
            switch result {
            case .success(let team):
                self.router.request(.getStories(team: team, alias: config.alias)) { [weak self] data, response, error in
                    // Handle response error
                    if error != nil {
                        switch (error as? URLError)?.code {
                        case .some(.timedOut):
                            completion(.failure(.fetchingStoriesTimedOut))
                        default:
                            completion(.failure(.fetchingStoriesFailed))
                        }
                    }

                    guard let self = self, let response = response as? HTTPURLResponse else {
                        return completion(.success([]))
                    }
                    let responseResult = self.handleNetworkResponse(response)
                    switch responseResult {
                    case .success:
                        guard let responseData = data else {
                            completion(.failure(.noData))
                            return
                        }
                        do {
                            print(responseData)
                            let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                            print(jsonData)
                            let stories = try JSONDecoder().decode([StoryValue].self, from: responseData)
                            DispatchQueue.main.async {
                                completion(.success(stories))
                            }
                        } catch {
                            // Decoding Error
                            print(error)
                            completion(.failure(.fetchingStoriesFailed))
                        }
                    case .failure:
                        completion(.failure(.fetchingStoriesFailed))
                    }

                }

            case .failure(let configurationError):
                switch configurationError {
                case .noConfigurationFound:
                    completion(.failure(.configurationNotFound))
                case .noTeamFound:
                    completion(.failure(.configurationNoTeamFound))
                }
            }
        }
    }

    /// Use only for React Native integration
    public func fetchStories(
        config: JoinStoriesConfig,
        completion: @escaping RNStoriesCallback) {
        buildRouteRN { team, error in
            // Handle response error
            if error != nil {
                completion(nil, .configurationNotFound)
                return
            }

            guard let team = team else {
                completion(nil, .configurationNoTeamFound)
                return
            }

            self.router.request(.getStories(team: team, alias: config.alias)) { [weak self] data, response, error in
                // Handle response error
                if error != nil {
                    switch (error as? URLError)?.code {
                    case .some(.timedOut):
                        completion(nil, .fetchingStoriesTimedOut)
                    default:
                        completion(nil, .fetchingStoriesFailed)
                    }
                }

                guard let self = self, let response = response as? HTTPURLResponse else {
                    return completion([], nil)
                }
                let responseResult = self.handleNetworkResponse(response)
                switch responseResult {
                case .success:
                    guard let responseData = data else {
                        completion(nil, .noData)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let stories = try JSONDecoder().decode([StoryValue].self, from: responseData)
                        DispatchQueue.main.async {
                            completion(stories, nil)
                        }
                    } catch {
                        // Decoding Error
                        print(error)
                        completion(nil, .fetchingStoriesFailed)
                    }
                case .failure:
                    completion(nil, .fetchingStoriesFailed)
                }

            }
        }

    }

}
