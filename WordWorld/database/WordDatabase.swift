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
        print("Initializing Database")
        let csvPath = Bundle.main.path(forResource: "database", ofType: "csv")!
        let csvString = try! String(contentsOfFile: csvPath, encoding: String.Encoding.utf8)
        let csv = csvString.components(separatedBy: "\n")
        
        //process csv
        for line in csv {
            let cells = line.components(separatedBy: ",")
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
                
                let _ = WordEntry(name: wordName, picture: picture, audio: audio, subcategory: subcategory!)
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
