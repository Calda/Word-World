//
//  WWDatabase.swift
//  WordWorld
//
//  Created by Cal on 4/5/15.
//  Copyright (c) 2015 Hear a Tale. All rights reserved.
//

import Foundation

let DATABASE = WordDatabase()

class WordDatabase {
    
    var categories: [String : WordCategory] = [:]
    
    init() {
        println("Initializing Database")
        let csvPath = NSBundle.mainBundle().pathForResource("database", ofType: "csv")!
        let csvString = String(contentsOfFile: csvPath, encoding: NSUTF8StringEncoding, error: nil)!
        let csv = split(csvString){ $0 == "\n" }
        
        //process csv
        for line in csv {
            let cells = split(line){ $0 == "," }
            if cells.count != 5 {
                continue
            }
            let catName = cells[0]
            let subName = cells[1]
            let wordName = cells[2]
            let picture = cells[3]
            let audio = cells[4]
            if (picture as NSString).length > 2 && (audio as NSString).length > 2 {
                var category = categories[catName]
                if category == nil {
                    category = WordCategory(name: catName, database: self)
                }
                
                var subcategory = category!.subcategories[subName]
                if subcategory == nil {
                    subcategory = WordSubcategory(name: subName, category: category!)
                }
                
                WordEntry(name: wordName, picture: picture, audio: audio, subcategory: subcategory!)
            }
        }
    }
    
    subscript(category: String) -> WordCategory? {
        return categories[category]
    }
    
    subscript(category: String, subcategory: String) -> WordSubcategory? {
        return self[category]?.subcategories[subcategory]
    }
    
    subscript(category: String, subcategory: String, word: String) -> WordEntry? {
        return self[category, subcategory]?.words[word]
    }

    
}
