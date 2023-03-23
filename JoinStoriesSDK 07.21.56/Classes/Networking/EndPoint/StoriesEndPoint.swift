//
//  StoriesEndPoint.swift
//  JoinStoriesSDK
//
//  Created by Audrey SOBGOU ZEBAZE on 25/09/2022.
//

import Foundation

public enum StoryEndPoint {
    case getStories(team: String, alias: String)
}

extension StoryEndPoint: EndPointType {

    public var baseURL: URL {
        guard let url = URL(string: API.baseUrl) else { fatalError("baseURL could not be configured.")}
        return url
    }

    public var path: String {
        switch self {
        case .getStories(let team, _):
            return "\(team)/stories"
        }
    }

    public var httpMethod: HTTPMethod {
        return .get
    }

    public var task: HTTPTask {
        switch self {
        case .getStories(_, let alias):
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: ["alias": alias,
                                "sort": "ordered"]
            )
        }
    }

    public var headers: HTTPHeaders? {
        return nil
    }

}
