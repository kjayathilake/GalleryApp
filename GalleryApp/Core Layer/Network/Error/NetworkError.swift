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
    case error(message: String)
}
