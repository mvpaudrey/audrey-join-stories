//
//  EndpointType.swift
//  JoinStoriesSDK
//
//  Created by Audrey SOBGOU ZEBAZE on 25/09/2022.
//

public protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
