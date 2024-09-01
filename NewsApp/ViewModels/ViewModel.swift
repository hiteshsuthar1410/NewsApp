//
//  ViewModel.swift
//  NewsApp
//
//  Created by Hitesh Suthar on 31/08/24.
//

import Foundation
import SwiftUI

final class NewsViewModel: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    @Published var articles: [NewsCategory: [Article]] = [:]
    @Published var categorySpecificArtciles = [Article]()
    @Published var errorMessage: String?
    
    @Published private(set) var currentLayout = LayoutOption.list
    @Published var isFilterSheetVisible = false
    
    @Published var filterOptions = [
        FilterOption(category: NewsCategory.business, isSelected: false),
        FilterOption(category: NewsCategory.entertainment, isSelected: false),
        FilterOption(category: NewsCategory.health, isSelected: false),
        FilterOption(category: NewsCategory.science, isSelected: false),
        FilterOption(category: NewsCategory.sports, isSelected: false),
        FilterOption(category: NewsCategory.technology, isSelected: false)
    ]
    
    private let networkService: NetworkServiceProtocol
    
    var getAppliedFiltersCount: Int {
        filterOptions.filter({ $0.isSelected}).count
    }
    
    var getFilterTitle: String {
        let activeFilters = filterOptions.filter({ $0.isSelected })
        var title = "Filter by Categories"
        if !activeFilters.isEmpty {
            title = activeFilters.map({ $0.category.rawValue.capitalized}).joined(separator: ", ")
        }
        return title
    }
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        self.articles = articles
        self.currentLayout = UserDefaults.standard.layoutOption
    }
    
    func didSelectFilters(updatedSelection: [FilterOption]) {
        filterOptions = updatedSelection
        let selectedCategories = filterOptions.filter({ $0.isSelected })
        fetchNews(for: selectedCategories.map({ $0.category }))
        print("Selected Filters:", selectedCategories.map({$0.category.rawValue}))
        isFilterSheetVisible.toggle()
    }
    
    func resetFilters() {
        for index in filterOptions.indices {
            filterOptions[index].isSelected = false
        }
        fetchNews(for: [])
        isFilterSheetVisible.toggle()
    }
    
    func showFilterSheet() {
        isFilterSheetVisible.toggle()
    }
    
    func changeLayout() {
        currentLayout == .list ? (currentLayout = .grid) : (currentLayout = .list)
        UserDefaults.standard.layoutOption = currentLayout
    }
    
    func fetchNews(for categories: [NewsCategory]) {
        networkService.fetchNews(for: categories) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    self?.articles = articles
                    print("Fetch: \(articles.values.map({$0.count}))")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchNews(for category: NewsCategory) {
        networkService.fetchNews(for: category) {  [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    self?.categorySpecificArtciles = articles
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
