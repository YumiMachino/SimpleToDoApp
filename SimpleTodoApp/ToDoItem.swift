//
//  ToDoItem.swift
//  SimpleTodoApp
//
//  Created by Yumi Machino on 2021/01/09.
//

import Foundation

struct ToDoItem {
    var title: String
    var priorityLevel: priorityLevel
    var isCompletedIndicator: Bool
}

enum priorityLevel {
    case high
    case medium
    case low
}
