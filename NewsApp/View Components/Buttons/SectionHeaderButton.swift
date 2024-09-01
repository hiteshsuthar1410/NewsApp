//
//  SectionHeaderButton.swift
//  NewsApp
//
//  Created by Hitesh Suthar on 01/09/24.
//

import SwiftUI

struct SectionHeaderButton: View {
    var title: String
    var action: () -> ()
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .fontWeight(.semibold)
            .padding()
            .foregroundStyle(.blue)
            .background(Color.lightGrayF5)
        }
        .border(Color.gray)   
    }
}

#Preview {
    SectionHeaderButton(title: NewsCategory.sports.rawValue.capitalized, action: {})
}
