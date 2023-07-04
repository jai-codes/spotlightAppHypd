//
//  CategoriesModel.swift
//  Spotlight
//
//  Created by Jai Deep on 28/06/23.
//
import Foundation

struct CategoriesModel: Codable {
    let success: Bool
    let payload: [CategoryPayload]
}

struct CategoryPayload: Codable {
    let l1Category: L1Category
    let l2Category: [L2Category]
}

struct L1Category: Codable {
    let id: String?
    let name: String?
    let slug: String?
    let thumbnail: ImageInfo
    let isMain: Bool?
}

struct L2Category: Codable {
    let id: String?
    let name: String?
    let slug: String?
    let parentID: String?
    let ancestorsID: [String]?
    let thumbnail: ImageInfo?
    let featuredImage: ImageInfo?
    let isMain: Bool?
}

struct ImageInfo: Codable {
    let src: URL?
    let height: Int?
    let width: Int?
}

