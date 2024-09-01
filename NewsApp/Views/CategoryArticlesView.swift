//
//  CategoryArticlesView.swift
//  NewsApp
//
//  Created by Hitesh Suthar on 01/09/24.
//

import SwiftUI

struct CategoryArticlesView: View {
    @ObservedObject var viewModel: NewsViewModel
    @Namespace private var animation
    
    var category: NewsCategory
    let columns = [GridItem(.adaptive(minimum: 160))]
    
    var body: some View {
        VStack {
            if viewModel.currentLayout == .list {
                
                List(viewModel.categorySpecificArtciles, id: \.url) { article in
                    Button {
                        viewModel.navigationPath.append(article)
                    } label: {
                        ListCard(article: article)
                            .matchedGeometryEffect(id: "\(article.title)", in: animation)
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.inset)
                
            } else {
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        
                        ForEach(viewModel.categorySpecificArtciles, id: \.url) { article in
                            Button {
                                viewModel.navigationPath.append(article)
                            } label: {
                                GridCard(article: article)
                                    .matchedGeometryEffect(id: "\(article.title)", in: animation)
                            }
                            .buttonStyle(.plain)
                            
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init())
                        }
                    }
                    .padding(.vertical)
                }
                
            }
        }
        .navigationTitle(category.rawValue.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Article.self) { article in
            ArticleView(articleLink: article.url)
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
        .task {
            viewModel.fetchNews(for: category)
        }
    }
}

#Preview {
    NavigationStack {
        CategoryArticlesView(viewModel: NewsViewModel(networkService: NetworkService()), category: .entertainment)
    }
}
