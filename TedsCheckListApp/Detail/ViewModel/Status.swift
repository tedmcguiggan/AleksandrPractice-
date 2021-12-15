//
//  Status.swift
//  TedsCheckListApp
//
//  Created by Ted McGuiggan on 9/15/21.
//

import Foundation


enum Status: String, CaseIterable {
    case toDO
    case inProgress
    case done
    
    var description: String {
        switch self {
        case .toDO:
            return "To-Do"
        case .inProgress:
            return "In Progress"
        case .done:
            return "Done"
        }
    }
}
