//
//  NewsResponse.swift
//  NewsApp
//
//  Created by Hitesh Suthar on 31/08/24.
//

import Foundation
struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
