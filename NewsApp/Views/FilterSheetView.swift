//
//  FilterSheet.swift
//  NewsApp
//
//  Created by Hitesh Suthar on 31/08/24.
//

import SwiftUI

struct FilterSheetView: View {
    @ObservedObject var viewModel: NewsViewModel
    @State private var selectedFilters = [FilterOption]()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(selectedFilters.enumerated()), id: \.element.id) { index, option in
                    Button(action: {
                        withAnimation {
                            selectedFilters[index].isSelected.toggle()
                        }
                    }) {
                        HStack {
                            Text(option.category.rawValue.capitalized)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            if option.isSelected {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .font(.headline)
                    }
                    .animation(.bouncy, value: option.isSelected)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        viewModel.resetFilters()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        viewModel.didSelectFilters(updatedSelection: selectedFilters)
                    }
                    .fontWeight(.bold)
                }
            }
            .onAppear {
                selectedFilters = viewModel.filterOptions
            }
        }
    }
}

#Preview {
    FilterSheetView(viewModel: NewsViewModel(networkService: NetworkService()))
}
