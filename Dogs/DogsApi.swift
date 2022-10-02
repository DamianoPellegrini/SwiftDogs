//
//  LocationManager.swift
//  Dogs
//
//  Created by Damiano Pellegrini on 02/10/22.
//

import Foundation
import CoreLocation

public enum ApiMessage {
    case dict (Dictionary<String, [String]>)
    case array ([String])
    case single (String)
}

struct ApiResponse: Codable {
    let message: ApiMessage
    let status: String
}

public enum DogError : Error {
    case invalidMessage
    case invalidResponse
}

public class DogsApi {
    private static let session = URLSession(configuration: .ephemeral)
    private static let decoder = JSONDecoder()
    private static let BASE_URL = "https://dog.ceo/api"
    
    //    private var availableSubBreeds: Dictionary<String, [String]> = .init()
    
    private static func makeCall(from: URL) async throws -> ApiResponse {
        let (data, _) = try await session.data(from: from)
        let apiResponse = try decoder.decode(ApiResponse.self, from: data)
        return apiResponse
    }
    
    static func breeds() async throws -> Dictionary<String, [String]> {
        let apiResponse = try await makeCall(from: URL(string: "\(BASE_URL)/breeds/list/all")!)
        
        guard apiResponse.status == "success" else {
            throw DogError.invalidResponse
        }
        
        guard case let .dict(breeds) = apiResponse.message else {
            throw DogError.invalidMessage
        }
        
        return breeds
    }
    
    static func subBreeds(breed: String) async throws -> [String] {
        let apiResponse = try await makeCall(from: URL(string: "\(BASE_URL)/breed/\(breed)/list")!)
        
        guard apiResponse.status == "success" else {
            throw DogError.invalidResponse
        }
        
        guard case let .array(subBreeds) = apiResponse.message else {
            throw DogError.invalidMessage
        }
        
        return subBreeds
    }
    
    static func randomImages(by breed: String? = nil, specifically subBreed: String? = nil, count: Int? = nil) async throws -> ApiMessage {
        var url = breed == nil
        ? "https://dog.ceo/api/breeds/image/random"
        : (subBreed == nil
           ? "https://dog.ceo/api/breed/\(breed!)/images/random"
           : "https://dog.ceo/api/breed/\(breed!)/\(subBreed!)/images/random"
        )
        
        if count != nil {
            url += "/\(count!)"
        }
        
        let apiResponse = try await makeCall(from: URL(string: url)!)
        
        guard apiResponse.status == "success" else {
            throw DogError.invalidResponse
        }
        
        return apiResponse.message
    }
    
    static func imagesBy(breed: String, subBreed: String? = nil) async throws -> [String] {
        let url = subBreed == nil ? "https://dog.ceo/api/breed/\(breed)/images" : "https://dog.ceo/api/breed/\(breed)/\(subBreed!)/images"
        let apiResponse = try await makeCall(from: URL(string: url)!)
        
        guard apiResponse.status == "success" else {
            throw DogError.invalidResponse
        }
        
        guard case let .array(subBreeds) = apiResponse.message else {
            throw DogError.invalidMessage
        }
        
        return subBreeds
    }
}


// Codable implementation
extension ApiMessage : Codable {
    
    public init(from: Decoder) throws {
        let container = try from.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .single(value)
            return
        }
        
        if let value = try? container.decode([String].self) {
            self = .array(value)
            return
        }
        
        if let value = try? container.decode(Dictionary<String, [String]>.self) {
            self = .dict(value)
            return
        }
        
        throw DogError.invalidMessage
    }
    
    public func encode(to: Encoder) throws {
        var container = to.singleValueContainer()
        switch self {
        case .dict(let value):
            try container.encode(value)
            break
        case .array(let value):
            try container.encode(value)
        case .single(let value):
            try container.encode(value)
        }
    }
}
