//
//  CheckBoxLabelView.swift
//  HeaderArrowListView
//
//  Created by Santosh Kumari on 2024-06-06.
//

import SwiftUI

struct HeaderArrowListView: View {
    @Binding var VList: [VHeaderListItem]
    var sectionHeaderSeparator: Bool = true
    var sectionFooterSeparator: Bool = true
    var didSectionSelected: (_ section: Int, _ isSelected: Bool) -> Void = {_,_ in }
    var didRowSelected: (_ row: Int, _ section: Int) -> Void = {_,_ in }
    @State private var inProcess: Bool = true
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ForEach(0..<VList.count, id: \.self) { section in
                let item = VList[section]
                VStack(alignment: .center, spacing: 0) {
                    if sectionHeaderSeparator {
                        Divider().tint(.init(uiColor: UIColor.lightGray))
                    }
                    
                    VStack(alignment: .center, spacing: 0) {
                        
                            Button {
                                reloadSections(section)
                            } label: {
                                HStack {
                                    Text(item.label)
                                        .padding(.leading, 15)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .tint(.green)
                                        .fontWeight(.bold)
                                        .rotationEffect(Angle(degrees: item.isSelected ? 0 : 180))
                                        .frame(width: 16, height: 16)
                                        .padding(.trailing, 15)
                                }
                            }
                            .frame(height: 40)

                            if item.isSelected, item.children.count > 0 {
                                withAnimation {
                                    CheckBoxListView(VList: .constant(item.children), buttonAction: { row in
                                        updateSelectedRow(row: row, section: section)
                                        didRowSelected(row, section)
                                    }).padding(.horizontal, 15)
                                    .opacity(inProcess ? 1.0 : 0.0)
                                }
                            }

                    }.padding(.vertical, 8)
                    
                    if sectionFooterSeparator {
                        Divider().tint(.init(uiColor: UIColor.lightGray))
                    }
                }
                .background(Color.white)
                .frame(width: UIScreen.main.bounds.width, height: item.isSelected ? (CGFloat(item.children.count) * 40 + 56) : 56)
                .transition(.move(edge: .leading))
                .animation(.interpolatingSpring(duration: 1.0), value: item.isSelected)
                .onTapGesture {
                    reloadSections(section)
                }
            }
        }
    }
    
    private func reloadSections(_ tag: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            inProcess = false
        }
        let list = VList.map {
            var item = $0
            if item.sectionTag == tag {
                item.isSelected.toggle()
            } else {
                item.isSelected = false
            }
            return item
        }
        VList = list
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            inProcess = true
        }
    }
    
    private func updateSelectedRow(row: Int, section: Int) {
        let list = VList.map {
            var item = $0
            if item.sectionTag == section {
                item.children = item.children.map {
                               var selectRow = $0
                               if selectRow.tag == row {
                                   selectRow.isSelected.toggle()
                               }
                                return selectRow
                             }
            }
            return item
        }
        
        VList = list
    }
}

struct CheckBoxListView: View {
    @Binding var VList: [VListItem]
    var buttonAction: (Int) -> Void = {_ in }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<VList.count, id: \.self) { index in
                CheckBoxLabelView(buttonLabel: VList[index].label, isSelected: $VList[index].isSelected, buttonTag: index, buttonAction: { tag in
                    reloadRows(tag: tag)
                    buttonAction(tag)
                }).id(VList[index].isSelected)
            }
        }.background(Color.white)
        .frame(width: UIScreen.main.bounds.width, height: CGFloat(VList.count) * 40)
    }
    
    private func reloadRows(tag: Int) {
        let list = VList.map {
            var item = $0
            if item.tag == tag {
                item.isSelected.toggle()
            }
            return item
        }
        VList = list
    }
    
}

/// MARK: custom rows
///
struct CheckBoxLabelView: View {
    var buttonLabel: String
    @Binding var isSelected: Bool
    var buttonTag: Int
    var buttonAction: (Int) -> Void
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(alignment: .center, spacing: 8) {
                Button {
                    buttonAction(buttonTag)
                } label: {
                    if isSelected {
                        Image("checkbox")
                            .resizable()
                            .scaledToFit()
                            .tint(.green)
                            .frame(width: 35, height: 35)
                    } else {
                        Image(systemName: "square")
                            .tint(.green)
                    }
                }.frame(width: 40,height: 40)
                .tag(buttonTag)
                if !isSelected {
                    Text(buttonLabel)
                        .fontWeight(.medium)
                } else {
                    Text(buttonLabel)
                        .fontWeight(.bold)
                }
                
                Spacer()
            }.background(Color.white)
            .tag(buttonTag)
            .frame(width: UIScreen.main.bounds.width)
            .onTapGesture {
                buttonAction(buttonTag)
            }
        }
    }
}
