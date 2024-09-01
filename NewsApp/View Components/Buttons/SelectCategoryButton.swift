//
//  SelectCategoryButton.swift
//  NewsApp
//
//  Created by Hitesh Suthar on 01/09/24.
//

import SwiftUI

struct SelectCategoryButton: View {
    var title: String
    var showSheet: Bool
    var action: () -> ()
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(title)
                    .fontWeight(.semibold)
                    .padding(4)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Image(systemName: "chevron.down")
                    .fontWeight(.bold)
                    .rotationEffect(.degrees(showSheet ? -180 : 0))
            }
            
        }
        .animation(.easeInOut(duration: 0.6), value: showSheet)
        .frame(maxWidth: .infinity)
        .buttonBorderShape(.capsule)
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    SelectCategoryButton(title: "Select Category", showSheet: true) {}
}
