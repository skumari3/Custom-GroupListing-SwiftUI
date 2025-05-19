//
//  Models.swift
//  HeaderArrowListView
//
//  Created by Santosh Kumari on 19/05/2025.
//

import Foundation

/// MARK: custom row model class
struct VListItem: Identifiable, Hashable, Equatable {
    var id: UUID = UUID()
    var label: String
    var isSelected: Bool
    var tag: Int
    
    init(label: String, isSelected: Bool, tag: Int) {
        self.label = label
        self.isSelected = isSelected
        self.tag = tag
    }
}

/// MARK: custom section model class
struct VHeaderListItem: Identifiable, Hashable {
    var id: UUID = UUID()
    var label: String
    var children: [VListItem]
    var sectionTag: Int
    var isSelected: Bool
    
    init(label: String, children: [VListItem], sectionTag: Int, isSelected: Bool) {
        self.label = label
        self.children = children
        self.sectionTag = sectionTag
        self.isSelected = isSelected
    }
}
