//
//  CardProtocol.swift
//  NewsApp
//
//  Created by Hitesh Suthar on 31/08/24.
//

import Foundation
protocol CardProtocol {
    var article: Article { get }
    var titleLineLimit: Int { get }
    var descriptionLineLimit: Int { get }
}

extension CardProtocol {
    var titleLineLimit: Int {
        3
    }
    var descriptionLineLimit: Int {
        3
    }
    
    var placeholderImage: String {
        return "img_imagePlaceholder"
    }
}
