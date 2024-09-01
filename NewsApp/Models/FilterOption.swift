//
//  FilterOption.swift
//  NewsApp
//
//  Created by Hitesh Suthar on 31/08/24.
//

import Foundation
struct FilterOption: Identifiable {
    let id = UUID()
    let category: NewsCategory
    var isSelected: Bool
}
