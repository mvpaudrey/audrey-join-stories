//
//  HTTPTask.swift
//  JoinStoriesSDK
//
//  Created by Audrey SOBGOU ZEBAZE on 25/09/2022.
//

import Foundation
public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
    case request

    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)

    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)

    // case download, upload...etc
}
