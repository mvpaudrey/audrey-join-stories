//
//  NetworkError.swift
//  JoinStoriesSDK
//
//  Created by JOIN on 27/01/2021.
//

import Foundation

public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}
