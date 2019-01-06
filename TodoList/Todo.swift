//
//  Todo.swift
//  TODO
//
//  Created by kowumon on 05/01/2019.
//  Copyright © 2019 kowumon. All rights reserved.
//

import Foundation

struct Todo: Equatable {
    var title: String
    var isDone: Bool
    
    init(title: String) {
        self.title = title
        self.isDone = false
    }
    
//    mutating func setDone() {
//        isDone = true
//    }
//    
//    mutating func setTodo() {
//        isDone = false
//    }
    
    mutating func updateTitle(_ title: String) {
        self.title = title
    }
}
