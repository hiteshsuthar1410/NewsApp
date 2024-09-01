//
//  ListCard.swift
//  NewsApp
//
//  Created by Hitesh Suthar on 31/08/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ListCard: View, CardProtocol {
    var article: Article
    let height = CGFloat(140)
    let spacing = CGFloat(6)
    
    var body: some View {
        HStack(spacing: spacing) {
            if let imageURL = article.urlToImage {
                WebImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: height, height: height)
                        .clipped()
                } placeholder: {
                    Image(placeholderImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: height, height: height)
                        .clipped()
                }
                .onSuccess { image, data, cacheType in
                    // Success
                }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                
            } else {
                Image(placeholderImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: height, height: height)
                    .clipped()
            }
            
            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .frame(alignment: .topLeading)
                    .lineLimit(titleLineLimit)
                Text(article.description ?? "N/A")
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .frame(alignment: .topLeading)
                    .lineLimit(descriptionLineLimit)
                
            }
            .padding(spacing)
            .frame(height: height, alignment: .topLeading)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: height, alignment: .topLeading)
        .background(Color.lightGrayF5)
        .cornerRadius(16)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    ListCard(article: Article(
        source: NewsSource(id: "wired", name: "Wired"),
        author: "Steven Levy",
        title: "Trump's Crypto Embrace Could Be a Disaster for Bitcoin",
        description: "At the Bitcoin 2024 conference in Nashville, Donald Trump promised the crypto community the moon. They'd better hope they don't get it.",
        url: "https://www.wired.com/story/donald-trump-bitcoin-reserve-promises/",
        urlToImage: "https://media.wired.com/photos/66ab594d0c0cc4819f595db4/191:100/w_1280,c_limit/073024_Crypto%20get%20rich%20quick.jpg",
        publishedAt: "2024-08-02T13:00:00Z",
        content: "Donald Trump is an unlikely crypto ally. The power of bitcoin, embodied in Satoshi Nakamoto's founding document, is that it frees participants from murky assessments of trust, instead relying on the blockchain...",
        category: .general
    )
)
}
