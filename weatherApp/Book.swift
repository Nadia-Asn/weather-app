//
//  Book.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 19/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import Foundation
class Book {
    private var x: Int?
    private var y: Int?
    private var book: Book
    static let   sharedInstance = Book()
    
    private init() {
        book = Book()
    }
    
    func add(x: Int , y: Int) -> Int{
        let z = x+y
        return z
    }
    func display(){
        print("test target 2")
    }
    
}
