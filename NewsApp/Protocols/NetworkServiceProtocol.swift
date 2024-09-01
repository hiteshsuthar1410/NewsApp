//
//  NetworkServiceProtocol.swift
//  NewsApp
//
//  Created by Hitesh Suthar on 31/08/24.
//

import Foundation
protocol NetworkServiceProtocol {
    
    func fetchNews(for categories: [NewsCategory], completion: @escaping (Result<[NewsCategory: [Article]], Error>) -> Void)
    
    func fetchNews(for category: NewsCategory, completion: @escaping (Result<[Article], Error>) -> Void)
    
}
