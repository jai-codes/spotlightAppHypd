//
//  ItemModel.swift
//  Spotlight
//
//  Created by Jai Deep on 24/06/23.
//

import Foundation



//MARK: Model
struct ItemModel: Codable {
    let payload: [Payload]
    let success: Bool
}

struct Payload: Codable, Identifiable {
    let id: String
    let name: String
    let brand_info: BrandInfo
    let featured_image: FeaturedImage
    let base_price: Price
    let retail_price: Price
    let commission_rate: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, brand_info, featured_image, base_price, retail_price, commission_rate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        brand_info = try container.decode(BrandInfo.self, forKey: .brand_info)
        featured_image = try container.decode(FeaturedImage.self, forKey: .featured_image)
        base_price = try container.decode(Price.self, forKey: .base_price)
        retail_price = try container.decode(Price.self, forKey: .retail_price)
        
        commission_rate = (try container.decodeIfPresent(Int.self, forKey: .commission_rate)) ?? 0
    }
}


struct BrandInfo: Codable {
    let id: String
    let name: String
    let logo: FeaturedImage
}

struct FeaturedImage: Codable {
    let src: String
}

struct Price: Codable {
    let value: Int
}

// FuaturedProductIDs Model
struct APIResponse: Codable {
    let payload: CatalogIDPayload
}

struct CatalogIDPayload: Codable {
    let id: String
    let catalogIDs: [String]
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case catalogIDs = "catalog_ids"
    }
}
