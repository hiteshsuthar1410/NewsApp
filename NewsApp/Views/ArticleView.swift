//
//  ArticleView.swift
//  NewsApp
//
//  Created by Hitesh Suthar on 31/08/24.
//

import SwiftUI
import WebKit

struct ArticleView: View {
    var articleLink: String?
    var body: some View {
        if let link = articleLink {
            WebView(url: URL(string: link)!)
                .edgesIgnoringSafeArea(.all)
        } else {
            Text("No link provided")
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView(frame: .zero)
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}


#Preview {
    ArticleView(articleLink: "https://apple.in")
}
