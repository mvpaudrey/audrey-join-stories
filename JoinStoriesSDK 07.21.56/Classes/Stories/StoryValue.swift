//
//  StoryValue.swift
//  JoinStoriesSDK
//
//  Created by JOIN on 07/11/2020.
//

import Foundation

@objc
public class StoryValue: NSObject, Decodable {

    public var id: String
    var title: String
    var url: String
    private var coverObjects: CoverObjects

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case url
        case coverObjects
    }

    var thumbnail: String {
        guard var components = URLComponents(string: url) else { return "" }
        components.query = nil
        guard let url = components.url else { return "" }
        // print("DEBUG URL: " + url.absoluteString + coverObjects.smallSize.originalUrl)
        if(coverObjects.smallSize.originalUrl.range(of: "^(http(s)?://)", options: .regularExpression) != nil){
            return coverObjects.smallSize.originalUrl
        }
        return url.absoluteString + coverObjects.smallSize.originalUrl
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        coverObjects = try container.decode(CoverObjects.self, forKey: .coverObjects)
        let decodedUrl = try container.decode(String.self, forKey: .url)
        guard var urlComponents = URLComponents(string: decodedUrl) else {
            url = decodedUrl
            return
        }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: "referrer", value: "sdk-ios")
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        url = urlComponents.url?.absoluteString ?? decodedUrl
    }

    // MARK: Equatable

    public static func == (lhs: StoryValue, rhs: StoryValue) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title && lhs.url == rhs.url
    }

}

private struct CoverObjects: Decodable, Equatable {
    var smallSize: SmallSize

    enum CodingKeys: String, CodingKey {
        case smallSize = "100x100.png"
    }
}

private struct SmallSize: Decodable, Equatable {
    var originalUrl: String
}
