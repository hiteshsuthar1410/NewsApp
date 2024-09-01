//
//  NetworkService.swift
//  NewsApp
//
//  Created by Hitesh Suthar on 31/08/24.
//

import Foundation

class NetworkService: NetworkServiceProtocol {
    private let apiKey = "94ffb9e914f24a24af895d1686f8263d" // 9bf5781d9c574ce28a8275acc4d58d14
    private let baseURL = "https://newsapi.org"
    private let unavailableArticleTitle = "[Removed]"
    
    /**
     - Parameters:
        - categories: An array of `NewsCategory` enums specifying the categories for which news articles should be fetched. If empty, general news is fetched.
        - completion: A closure that takes a `Result` as a parameter:
            - Success: Returns a dictionary with `NewsCategory` keys and arrays of `Article` values.
            - Failure: Returns an `Error` if any issue occurs during fetching.
     */
    func fetchNews(for categories: [NewsCategory], completion: @escaping (Result<[NewsCategory: [Article]], Error>) -> Void) {
        let group = DispatchGroup()
        var allArticles: [NewsCategory: [Article]] = [:]
        var fetchError: Error?
        
        let categoriesToFetch = categories.isEmpty ? [.general] : categories
        
        for category in categoriesToFetch {
            group.enter()
            
            let query = category == .general ? "world" : category.rawValue
            let urlString = "\(baseURL)/v2/everything?q=\(query)&apiKey=\(apiKey)&pageSize=\(categories.isEmpty ? 20 : 10)"
            
            guard let url = URL(string: urlString) else {
                fetchError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL for category \(query)"])
                group.leave()
                continue
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                defer { group.leave() }
                
                if let error = error {
                    fetchError = error
                    return
                }
                
                guard let data = data else {
                    fetchError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received for category \(query)"])
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let newsResponse = try decoder.decode(NewsResponse.self, from: data)
                    
                    let filteredArticles = newsResponse.articles.filter { $0.title != self.unavailableArticleTitle }
                    let articlesWithCategory = filteredArticles.map { article -> Article in
                        var article = article
                        article.category = category
                        return article
                    }
                    
                    if allArticles[category] != nil {
                        allArticles[category]?.append(contentsOf: articlesWithCategory)
                    } else {
                        allArticles[category] = articlesWithCategory
                    }
                } catch {
                    fetchError = error
                }
            }
            
            task.resume()
        }
        
        group.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
            } else {
                completion(.success(allArticles))
            }
        }
    }
    
    /**
     - Parameters:
        - category: A `NewsCategory` enum value specifying the category for which news articles should be fetched.
        - completion: A closure that takes a `Result` as a parameter:
            - Success: Returns an array of `Article` objects for the specified category.
            - Failure: Returns an `Error` if any issue occurs during fetching.

     - Note:
       The `completion` handler is called once the network request is completed.
     */
    func fetchNews(for category: NewsCategory, completion: @escaping (Result<[Article], Error>) -> Void) {
        var allArticles = [Article]()
        var fetchError: Error?

        guard let url = URL(string: "\(baseURL)/v2/everything?q=\(category.rawValue)&apiKey=\(apiKey)&pageSize=20") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL for category \(category.rawValue)"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                fetchError = error
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                fetchError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received for category \(category.rawValue)"])
                completion(.failure(fetchError!))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let newsResponse = try decoder.decode(NewsResponse.self, from: data)
                let articlesWithCategory = newsResponse.articles.map { article -> Article in
                    var article = article
                    article.category = category
                    return article
                }
                allArticles.append(contentsOf: articlesWithCategory)
                completion(.success(allArticles.filter({ $0.title != self.unavailableArticleTitle})))
            } catch {
                fetchError = error
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
