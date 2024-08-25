//
//  LNService.swift
//  AnimeList-Demo
//
//  Created by Lynn Thit Nyi Nyi on 25/8/2567 BE.
//

import Foundation

final class LNService {
    static let shared = LNService()
    
    private init() {}
    
    enum LNServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Send Get Latest Anime API Call
    /// - Parameters:
    ///   - request: Request
    ///   - type: Type of object we expect to get back
    ///   - completion: Callback with data or error
    public func execute<T: Codable>(
        _ request: LNRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(LNServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? LNServiceError.failedToGetData))
                return
            }
            
            // Decode response
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - Private
    
    private func request (from lnRequest: LNRequest) -> URLRequest? {
        guard let url = lnRequest.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = lnRequest.httpMethod // GET
        
        return request
    }
}
