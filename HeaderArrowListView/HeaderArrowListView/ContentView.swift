//
//  ContentView.swift
//  HeaderArrowListView
//
//  Created by Santosh Kumari on 2024-06-06.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State var contentHeights: CGFloat = .zero

    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack(alignment: .center, spacing: 0) {
                    //topView
                    Spacer()
                    ScrollViewReader { proxy in
                        ScrollView([.vertical], showsIndicators: false) {
                            ///checkbox
                            CheckBoxListView(VList: $viewModel.individualRows, buttonAction: { index in
                                viewModel.didTapRow(tag: index)
                            })
                            .padding(.horizontal, 15)
                            .padding(.vertical, 16)
                            
                            sectionFacets(proxy: proxy)
                            Spacer()
                        }.background(Color.white)
                            .frame(width: UIScreen.main.bounds.width, height: geo.size.height)
                            .ignoresSafeArea(edges: .top)
                        
                    }
                }
            }
            .navigationTitle("Custom Group List")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: Facet Views
    private func sectionFacets(proxy: ScrollViewProxy) -> some View {
        ///Facets Content
        ZStack(alignment: .top) {
            HeaderArrowListView(VList: $viewModel.headerRows,
                                didSectionSelected: { section, selected in
                                   scrollToChild(proxy: proxy, section: section, selected: selected)
                               },didRowSelected: { row,section  in
                                   viewModel.didTapHeaderRow(rowSelected: row, sectionTag: section)
            })
        }
    }
    
    private func scrollToChild(proxy: ScrollViewProxy, section: Int, selected: Bool) {
        if selected, let count = viewModel.numberOfRows(section: section) {
          if count > 8 {
              proxy.scrollTo(section, anchor: .top)
          } else {
              proxy.scrollTo(section, anchor: .bottom)
          }
        }
    }
}


#Preview {
    ContentView()
}
