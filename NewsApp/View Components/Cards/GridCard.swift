//
//  GridCard.swift
//  NewsApp
//
//  Created by Hitesh Suthar on 31/08/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct GridCard: View, CardProtocol {
    var article: Article
    var descriptionLineLimit = 2
    let height = CGFloat(240)
    let width = CGFloat(160)
    var body: some View {
        VStack(spacing: 0) {
            if let imageURL = article.urlToImage {
                WebImage(url: URL(string: imageURL)) { image in
                    image.resizable()
                } placeholder: {
                    Image(placeholderImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .clipped()
                }
                .onSuccess { image, data, cacheType in
                    // Success
                }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                .frame(width: width, height: 120)
                .clipped()
                
            } else {
                Image(placeholderImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 140)
                    .clipped()
            }
            Divider()
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
            .padding(6)
            .frame(alignment: .topLeading)
            
        }
        .frame(width: width, height: height, alignment: .topLeading)
        .background(Color.lightGrayF5)
        .cornerRadius(16)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    GridCard(article: Article(
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


