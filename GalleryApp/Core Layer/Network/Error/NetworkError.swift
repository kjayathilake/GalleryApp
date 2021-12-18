//
//  NetworkError.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 11/4/21.
//
import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingFailed
    case unknown
}

enum CustomError: Error {
    case invalidURL
    case decodingFailed
    case unknown
    case networkUnavailable
    case error(message: String)
    
    var description: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .decodingFailed: return "Invalid Response"
        case .unknown: return "Unknown Error"
        case .networkUnavailable: return "No network connection"
        case .error(message: let message): return message
        }
    }
}
