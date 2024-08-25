//
//  LNRequest.swift
//  AnimeList-Demo
//
//  Created by Lynn Thit Nyi Nyi on 25/8/2567 BE.
//

import Foundation

final class LNRequest {
    /// API Constants
    private struct Constants {
        static let baseUrl = "https://api.jikan.moe/v4"
    }
    
    /// Desired endpoint
    private let endpoint: LNEndpoint
    
    private let pathComponents: Set<String>
    
    private let queryParameters: [URLQueryItem]
    
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if (!pathComponents.isEmpty) {
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        if (!queryParameters.isEmpty) {
            string += "?"
            // name=name&value&name=value
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else {return nil}
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            string += argumentString
        }
        
        return string
    }
    
    /// Computed and Constructed API Url
    public var url: URL? {
        return URL(string: urlString)
    }
    
    /// Desired HTTP Method
    public let httpMethod = "GET"
    
    // MARK: -Public
    /// Construct request
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: Collection of Path components
    ///   - queryParameters: Collection of Query parameters
    public init (
        endpoint: LNEndpoint,
        pathComponents: Set<String> = [],
        queryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
}

extension LNRequest {
    static let listLatestAnimesRequests = LNRequest(endpoint: .latestAnime)
}
