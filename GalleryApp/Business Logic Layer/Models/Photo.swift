//
//  UnsplashModel.swift
//  GalleryApp
//
//  Created by Krishantha Jayathilake on 11/4/21.
//

import Foundation

struct UnsplashSearchResponse: Codable {
    let total: Int
    let totalPages: Int
    let results: UnsplashResponse
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - UnsplashResponseElement
struct Photo: Codable {
    let id: String
    let createdAt, updatedAt: String
    let promotedAt: String?
    let width, height: Int
    let color, blurHash: String?
    let photoDescription, altDescription: String?
    let urls: Urls
    let links: UnsplashModelLinks?
    let likes: Int
    let likedByUser: Bool
    let sponsorship: Sponsorship?
    let topicSubmissions: TopicSubmissions?
    let user: User
    let exif: Exif?
    let location: Location?
    let meta: Meta?
    let publicDomain: Bool?
    let tags: [PhotoTag]?
    let tagsPreview: [TagsPreview]?
    let views, downloads: Int?
    let topics: [Topic]?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case promotedAt = "promoted_at"
        case width, height, color
        case blurHash = "blur_hash"
        case photoDescription = "description"
        case altDescription = "alt_description"
        case urls, links, likes
        case likedByUser = "liked_by_user"
        case sponsorship
        case topicSubmissions = "topic_submissions"
        case user, exif, location, meta
        case publicDomain = "public_domain"
        case tags
        case tagsPreview = "tags_preview"
        case views, downloads, topics
    }
}

// MARK: - Topic
struct Topic: Codable {
    let id, title, slug, visibility: String?
}

// MARK: - TagsPreview
struct TagsPreview: Codable {
    let type: String?
    let title: String?
}

// MARK: - PhotoTag
struct PhotoTag: Codable {
    let type: String?
    let title: String?
}

// MARK: - Exif
struct Exif: Codable {
    let make, model, name, exposureTime: String?
    let aperture, focalLength: String?
    let iso: Int?

    enum CodingKeys: String, CodingKey {
        case make, model, name
        case exposureTime = "exposure_time"
        case aperture
        case focalLength = "focal_length"
        case iso
    }
}

// MARK: - Location
struct Location: Codable {
    let title, name, city, country: String?
    let position: Position?
}

// MARK: - Position
struct Position: Codable {
    let latitude, longitude: Double?
}

// MARK: - Meta
struct Meta: Codable {
    let index: Bool?
}

// MARK: - UnsplashResponseLinks
struct UnsplashModelLinks: Codable {
    let linksSelf, html, download, downloadLocation: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
        case downloadLocation = "download_location"
    }
}

// MARK: - Sponsorship
struct Sponsorship: Codable {
    let impressionUrls: [String]
    let tagline: String
    let taglineURL: String
    let sponsor: User

    enum CodingKeys: String, CodingKey {
        case impressionUrls = "impression_urls"
        case tagline
        case taglineURL = "tagline_url"
        case sponsor
    }
}

// MARK: - User
struct User: Codable {
    let id: String
    let updatedAt: String
    let username, name, firstName: String
    let lastName, twitterUsername: String?
    let portfolioURL: String?
    let bio, location: String?
    let links: UserLinks
    let profileImage: ProfileImage
    let instagramUsername: String?
    let totalCollections, totalLikes, totalPhotos: Int
    let acceptedTos, forHire: Bool
    let social: Social

    enum CodingKeys: String, CodingKey {
        case id
        case updatedAt = "updated_at"
        case username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case twitterUsername = "twitter_username"
        case portfolioURL = "portfolio_url"
        case bio, location, links
        case profileImage = "profile_image"
        case instagramUsername = "instagram_username"
        case totalCollections = "total_collections"
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case acceptedTos = "accepted_tos"
        case forHire = "for_hire"
        case social
    }
}

// MARK: - UserLinks
struct UserLinks: Codable {
    let linksSelf, html, photos, likes: String
    let portfolio, following, followers: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes, portfolio, following, followers
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small, medium, large: String
}

// MARK: - Social
struct Social: Codable {
    let instagramUsername: String?
    let portfolioURL: String?
    let twitterUsername: String?
    let paypalEmail: String?

    enum CodingKeys: String, CodingKey {
        case instagramUsername = "instagram_username"
        case portfolioURL = "portfolio_url"
        case twitterUsername = "twitter_username"
        case paypalEmail = "paypal_email"
    }
}

// MARK: - TopicSubmissions
struct TopicSubmissions: Codable {
    let people: People?
    let businessWork, technology: BusinessWork?
    let wallpapers: People?

    enum CodingKeys: String, CodingKey {
        case people
        case businessWork = "business-work"
        case technology, wallpapers
    }
}

// MARK: - BusinessWork
struct BusinessWork: Codable {
    let status: String
    let approvedOn: String?

    enum CodingKeys: String, CodingKey {
        case status
        case approvedOn = "approved_on"
    }
}

// MARK: - People
struct People: Codable {
    let status: String
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb: String
}

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Photo: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

typealias UnsplashResponse = [Photo]
