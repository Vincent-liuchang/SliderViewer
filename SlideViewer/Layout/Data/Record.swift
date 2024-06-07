//
//  Record.swift
//  OneApp
//
//  Created by Chang Liu on 22/9/2023.
//

import Foundation
import SwiftData

class Record: Identifiable {
    var id: Int
    var name: String
    var type: String
    var value: Double
    
    init(id: Int, name: String, type: String, value: Double) {
        self.id = id
        self.name = name
        self.type = type
        self.value = value
    }
}

class Bill: Record {
    var billType: RecordType
    var categtory: BillCategory
    
    init(id: Int, name: String, type: RecordType, category: BillCategory, value: Double) {
        self.billType = type
        self.categtory = category
        super.init(id: id, name: name, type: type.rawValue, value: value)
    }
}

enum RecordType: String {
    case Incoming
    case Outgoing
}

enum BillCategory: String {
    case unknown
    case eating
    case transportation
    case clothing
    case living
}
