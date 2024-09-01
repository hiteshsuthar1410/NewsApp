//
//  SwitchLayoutButton.swift
//  NewsApp
//
//  Created by Hitesh Suthar on 01/09/24.
//

import SwiftUI

struct SwitchLayoutButton: View {
    var selectedLayout: LayoutOption
    var action: () -> ()
    var body: some View {
        Button {
            withAnimation(.spring) {
                action()
            }
        } label: {
            Image(systemName: selectedLayout == .grid ? "list.bullet" : "square.grid.2x2")
                .font(.title2)
                .animation(.easeInOut(duration: 0.6), value: selectedLayout)
        }
        .labelsHidden()
    }
}

#Preview {
    SwitchLayoutButton(selectedLayout: .grid) {}
}
