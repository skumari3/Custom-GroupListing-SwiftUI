//
//  ViewModel.swift
//  HeaderArrowListView
//
//  Created by Santosh Kumari on 01/12/2024.
//
import SwiftUI

final class ViewModel: ObservableObject {
    
    init() {
        makeIndividualList()
        makeHeaderRowsList()
    }
    
    @Published var individualRows: [VListItem] = []
    @Published var headerRows: [VHeaderListItem] = []
    private var selectedRows: [VListItem] = []
    
    func numberOfRows(section: Int) -> Int? {
        guard let child = headerRows.first(where: { $0.sectionTag == section })?.children else {
            return nil
        }

        return child.count
    }
    
    
    /*rows selected in the different sections*/
    func didTapRow(tag: Int) {
        guard let selected = individualRows.first(where: { $0.tag == tag }) else {
            return
        }
        selectedRows(selected: selected)
    }
    
    /*rows selected in the different sections*/
    func didTapHeaderRow(rowSelected: Int, sectionTag: Int) {
        guard let selected = headerRows.first(where: { $0.sectionTag == sectionTag })?.children.first(where: { $0.tag == rowSelected }) else {
            return
        }
        selectedRows(selected: selected)
    }
    
}

//MARK: Privates

private extension ViewModel {
    
    private func makeIndividualList() {
        let list = checkboxList(numberOfItems: Array(0...2))
        individualRows = list
    }
    
    private func makeHeaderRowsList() {
        let numberOfSections = Array(0...8)
        let list = numberOfSections.map { index in
            return VHeaderListItem(label: "Section \(index + 1)", children: checkboxList(numberOfItems: Array(0...Int.random(in: 1..<10))), sectionTag: index, isSelected: false)
        }
        headerRows = list
    }
    
    private func checkboxList(numberOfItems: [Int]) -> [VListItem] {
        let list: [VListItem] = numberOfItems.map { index in
            return VListItem(label: "Row \(index + 1)", isSelected: false, tag: index)
        }

        return list
    }
    
    /* get selected rows */
    private func selectedRows(selected: VListItem) {
        if selectedRows.contains(where: { $0.id == selected.id }) {
            selectedRows.removeAll(where: { $0.id == selected.id })
        } else {
            selectedRows.append(selected)
        }
    }
}
