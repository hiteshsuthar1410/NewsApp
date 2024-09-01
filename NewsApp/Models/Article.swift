//
//  Article.swift
//  NewsApp
//
//  Created by Hitesh Suthar on 31/08/24.
//

import Foundation
struct Article: Codable, Hashable {
    let source: NewsSource
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    var category: NewsCategory?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}

extension Article: Equatable {
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.source == rhs.source &&
        lhs.author == rhs.author &&
               lhs.title == rhs.title &&
               lhs.description == rhs.description &&
               lhs.url == rhs.url &&
               lhs.urlToImage == rhs.urlToImage &&
               lhs.publishedAt == rhs.publishedAt &&
               lhs.content == rhs.content &&
               lhs.category == rhs.category
    }
}
