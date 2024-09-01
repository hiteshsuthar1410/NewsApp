//
//  HomeView.swift
//  NewsApp
//
//  Created by Hitesh Suthar on 31/08/24.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    @Namespace private var animation
    @StateObject private var viewModel = NewsViewModel(networkService: NetworkService())
    
    private let rows = [GridItem(.fixed(50))]
    private let columns = [GridItem(.adaptive(minimum: 160))]
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            Group {
                SelectCategoryButton(title: viewModel.getFilterTitle,
                                     showSheet: viewModel.isFilterSheetVisible, action: {
                    viewModel.showFilterSheet()
                })
                .padding(.top, 6)
                .padding(.horizontal)
                
                if viewModel.currentLayout == .list {
                    List(viewModel.articles.map({ $0.key }).sorted { $0.rawValue < $1.rawValue }, id: \.self) { category in
                        if let articles = viewModel.articles[category] {
                            if viewModel.getAppliedFiltersCount > 1 {
                                
                                SectionHeaderButton(title: category.rawValue.capitalized) {
                                    viewModel.navigationPath.append(category)
                                }
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets())
                                .matchedGeometryEffect(id: "\(category.rawValue)", in: animation)
                            }
                            
                            ForEach(articles, id: \.url) { article in
                                Button {
                                    viewModel.navigationPath.append(article)
                                } label: {
                                    ListCard(article: article)
                                        .matchedGeometryEffect(id: "\(article.title)", in: animation)
                                }
                                .listRowSeparator(.hidden)
                            }
                        }
                    }
                    .listStyle(.inset)
                    
                } else {
                    ScrollView {
                        if viewModel.getAppliedFiltersCount <= 1 {
                            LazyVGrid(columns: columns, spacing: 12) {
                                if let articles = viewModel.articles.first?.value {
                                    ForEach(articles, id: \.url) { article in
                                        Button {
                                            viewModel.navigationPath.append(article)
                                        } label: {
                                            GridCard(article: article)
                                                .matchedGeometryEffect(id: "\(article.title)", in: animation)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        } else {
                            ForEach(viewModel.articles.map({ $0.key }).sorted { $0.rawValue < $1.rawValue }, id: \.self) { category in
                                VStack(spacing: 10) {
                                    SectionHeaderButton(title: category.rawValue.capitalized) {
                                        viewModel.navigationPath.append(category)
                                    }
                                    .matchedGeometryEffect(id: "\(category.rawValue)", in: animation)
                                    .buttonStyle(.plain)
                                    
                                    ScrollView(.horizontal) {
                                        if let articles = viewModel.articles[category] {
                                            LazyHGrid(rows: rows, alignment: .center, spacing: 12) {
                                                ForEach(articles, id: \.url) { article in
                                                    Button {
                                                        viewModel.navigationPath.append(article)
                                                    } label: {
                                                        GridCard(article: article)
                                                        
                                                            .matchedGeometryEffect(id: "\(article.title)", in: animation)
                                                        
                                                    }
                                                    .buttonStyle(.plain)
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.bottom, 18)
                            }
                        }
                    }
                }
            }
            .navigationTitle("News")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Article.self) { article in
                ArticleView(articleLink: article.url)
            }
            .navigationDestination(for: NewsCategory.self) { category in
                CategoryArticlesView(viewModel: viewModel, category: category)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    SwitchLayoutButton(selectedLayout: viewModel.currentLayout) {
                        withAnimation(.bouncy) {
                            viewModel.changeLayout()
                        }
                    }
                }
            }
        }
        .task {
            if viewModel.getAppliedFiltersCount > 0 {
            } else {
                viewModel.fetchNews(for: [])
            }
        }
        .sheet(isPresented: $viewModel.isFilterSheetVisible, content: {
            FilterSheetView(viewModel: viewModel)
                .presentationDetents([.medium, .large])
        })
        .ignoresSafeArea()
    }
}

#Preview {
        HomeView()
}
