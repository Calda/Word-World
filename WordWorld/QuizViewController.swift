//
//  QuizViewController.swift
//  WordWorld
//
//  Created by DFA Film 9: K-9 on 5/8/15.
//  Copyright (c) 2015 Hear a Tale. All rights reserved.
//

import UIKit

class QuizViewController : UIViewController {
    
    var category: WordCategory?
    
    @IBOutlet weak var quizWord: UIButton!
    /*

    6+: 100
    6: 75
    5: 50
    4S: 65

    */
    
    @IBOutlet weak var option1: UIImageView!
    @IBOutlet weak var option2: UIImageView!
    @IBOutlet weak var option3: UIImageView!
    @IBOutlet weak var option4: UIImageView!
    
    @IBOutlet weak var correct: UILabel!
    @IBOutlet weak var incorrect: UILabel!
    
    var imageViewMap : [UIImageView] = []
    var quizChoices : [WordEntry] = []
    var quizAnswer : WordEntry?
    
    func quizWithCategory(category: WordCategory) {
        if imageViewMap.count == 0 {
            imageViewMap.append(option1)
            imageViewMap.append(option2)
            imageViewMap.append(option3)
            imageViewMap.append(option4)
        }
        self.category = category
        
        setUpQuiz()
    }
    
    func setUpQuiz() {
        var allWords : [WordEntry] = []
        for subcat in category!.subcategories.values {
            for word in subcat.words.values {
                allWords.append(word)
            }
        }
        
        if allWords.count < 4 {
            return
        }
        
        quizChoices = [allWords[0], allWords[1], allWords[2], allWords[3]]
        
        for i in 0...3 {
            quizChoices[i] = randomWord(&allWords)
            let path = quizChoices[i].picturePath
            let image = UIImage(data: NSData(contentsOfFile: path)!)
            imageViewMap[i].image = image
        }
        
        let answerID = Int(arc4random_uniform(4))
        quizAnswer = quizChoices[answerID]
        quizWord.titleLabel?.text = "word here"
        
    }
    
    func randomWord(inout array: [WordEntry]) -> WordEntry {
        let random = Int(arc4random_uniform(UInt32(array.count - 1)))
        let word = array[random]
        array.removeAtIndex(random)
        return word
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func quizWordPressed(sender: AnyObject) {
        quizAnswer?.playAudio()
    }
    
    @IBAction func tapRecognized(sender: UITapGestureRecognizer) {
        
    }
}
