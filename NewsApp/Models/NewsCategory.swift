//
//  NewsCategory.swift
//  NewsApp
//
//  Created by Hitesh Suthar on 31/08/24.
//

import Foundation

enum NewsCategory: String, CaseIterable, Codable, Equatable, Identifiable {
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
    
    var id: Self {
        return self
    }
}
