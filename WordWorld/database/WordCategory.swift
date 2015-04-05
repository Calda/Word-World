//
//  WordCategory.swift
//  WordWorld
//
//  Created by Cal on 4/5/15.
//  Copyright (c) 2015 Hear a Tale. All rights reserved.
//

import Foundation

class WordCategory : Printable {
    
    let name: String
    let database: WordDatabase
    var subcategories: [String : WordSubcategory] = [:]
    var description: String {
        get {
            var desc = "\(name)["
            let subs = subcategories.values
            for i in 0..<subcategories.count {
                desc += (subs.array[i] as WordSubcategory).name
                if i != (subcategories.count - 1) {
                    desc += ","
                }
            }
            desc += "]"
            return desc
        }
    }
    
    init(name: String, database: WordDatabase) {
        self.name = name
        self.database = database
        database.categories.updateValue(self, forKey: name)
    }
    
}


class WordSubcategory : Printable {
    
    let name: String
    let category: WordCategory
    var words: [String : WordEntry] = [:]
    var description: String {
        get {
            var desc = "\(name)["
            let allWords = words.values
            for i in 0..<words.count {
                desc += (allWords.array[i] as WordEntry).name
                if i != (words.count - 1) {
                    desc += ","
                }
            }
            desc += "]"
            return desc
        }
    }
    
    init(name: String, category: WordCategory) {
        self.name = name
        self.category = category
        category.subcategories.updateValue(self, forKey: name)
    }
    
}