//
//  CharactersModel.swift
//  Marvel
//
//  Created by MarvelDev on 13/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import Foundation
import UIKit

// MARK: - CharactersModel
struct CharactersModel: StructDecodable {
    let code: Int
    let status, copyright, attributionText, attributionHTML, etag: String
    var data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    var offset, limit, total, count: Int
    var results: [Result]
}

// MARK: - Result
struct Result: Codable, Equatable {
    static func == (lhs: Result, rhs: Result) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let name, resultDescription, modified, resourceURI: String
    var description: String? = ""
    let thumbnail: Thumbnail
    var image: UIImage?
    let comics, series, events: Comics
    let stories: Stories
    let urls: [URLElement]
    var detailCharacter: CharactersModel?

    enum CodingKeys: String, CodingKey {
        case id, name
        case resultDescription = "description"
        case modified, thumbnail, resourceURI, comics, series, stories, events, urls
    }
}

// MARK: - Comics
struct Comics: Codable {
    let available, returned: Int
    let collectionURI: String
    let items: [ComicsItem]
}

// MARK: - ComicsItem
struct ComicsItem: Codable {
    let resourceURI, name: String
}

// MARK: - CharactersModel
struct Stories: Codable {
    let available, returned: Int
    let collectionURI: String
    let items: [StoriesItem]
}

// MARK: - StoriesItem
struct StoriesItem: Codable {
    let resourceURI, name, type: String
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path, thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - URLElement
struct URLElement: Codable {
    let type, url: String
}
