//
//  QuizViewController.swift
//  WordWorld
//
//  Created by DFA Film 9: K-9 on 5/8/15.
//  Copyright (c) 2015 Hear a Tale. All rights reserved.
//

import UIKit
import Foundation

class QuizViewController : UIViewController {
    
    var categories: [WordCategory]?
    var allWords: [WordEntry] = []
    
    @IBOutlet weak var quizWord: UILabel!
    @IBOutlet weak var quizWordHeight: NSLayoutConstraint!
    
    @IBOutlet weak var option1: UIImageView!
    @IBOutlet weak var option2: UIImageView!
    @IBOutlet weak var option3: UIImageView!
    @IBOutlet weak var option4: UIImageView!
    @IBOutlet weak var imagesContainer: UIView!
    
    @IBOutlet weak var correct: UILabel!
    @IBOutlet weak var incorrect: UILabel!
    
    @IBOutlet weak var coin: UIImageView!
    var goldCoin: UIImage?
    var silverCoin: UIImage?
    var answerAttempts = 0
    
    var imageViewMap : [UIImageView] = []
    var quizChoices : [WordEntry] = []
    var quizAnswer : WordEntry?
    
    override func viewWillAppear(animated: Bool) {
        
        func getQuizWordHeight() -> CGFloat {
            let screen = Int(self.view.frame.width)
            var constant : CGFloat
            
            switch(screen) {
                case(480): return 85.0 //4S
                case(568): return 60.0 //5
                case(667): return 100.0 //6
                default: return 150.0 //6+ or larger??
            }
        }
        
        quizWordHeight.constant = getQuizWordHeight()
        self.view.layoutIfNeeded()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        quizAnswer!.playAudio()
    }
    
    func quizWithCategory(category: WordCategory) {
        self.categories = [category]
        setUpQuiz(usingAudio: false)
    }
    
    func quizWithDatabase() {
        self.categories = DATABASE.categories.values.array
        setUpQuiz(usingAudio: false)
    }
    
    func setUpQuiz(usingAudio: Bool = true) {
        goldCoin = UIImage(named: "Gold-Coin")
        silverCoin = UIImage(named: "Silver-Coin")
        
        if imageViewMap.count == 0 {
            imageViewMap.append(option1)
            imageViewMap.append(option2)
            imageViewMap.append(option3)
            imageViewMap.append(option4)
        }
        
        for category in categories! {
            for subcat in category.subcategories.values {
                for word in subcat.words.values {
                    allWords.append(word)
                }
            }
        }
        
        poseQuestion(usingAudio: usingAudio)
        
    }
    
    
    func poseQuestion(usingAudio: Bool = true) {
        answerAttempts = 0
        correct.hidden = true
        incorrect.hidden = true
        
        if allWords.count == 0 {
            //used all words, restart
            setUpQuiz(usingAudio: usingAudio)
            return
        }
        quizAnswer = randomWord(&allWords)
        quizWord.text = quizAnswer!.name.lowercaseString
        shakeTitle()
        
        let questionCategory = quizAnswer!.subcategory.category
        
        var allInCategory : [WordEntry] = []
        for subcat in questionCategory.subcategories {
            for word in subcat.1.words {
                if word.1.name != quizAnswer!.name {
                    allInCategory.append(word.1)
                }
            }
        }
        
        if allInCategory.count < 4 {
            poseQuestion() //only use categories with more than 4 words
        }
        else {
            let answerIndex = Int(arc4random_uniform(4))
            quizChoices = [allInCategory[0], allInCategory[1], allInCategory[2], allInCategory[3]]
            for index in 0...3 {
                let word : WordEntry
                if index == answerIndex {
                    word = quizAnswer!
                } else {
                    word = randomWord(&allInCategory)
                }
                quizChoices[index] = word
                let path = word.picturePath
                let image = UIImage(data: NSData(contentsOfFile: path)!)
                imageViewMap[index].image = image
            }
        }
        
        if usingAudio { quizAnswer!.playAudio() }
    }
    
    
    func randomWord(inout array: [WordEntry]) -> WordEntry {
        let random = Int(arc4random_uniform(UInt32(array.count)))
        let word = array[random]
        array.removeAtIndex(random)
        return word
    }
    
    
    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if categories!.count > 1 { //not launched from single category view
            NSNotificationCenter.defaultCenter().postNotificationName(WWDisplayCategoriesNotification, object: nil)
        }
    }
    
    @IBAction func tapRecognized(sender: UITapGestureRecognizer) {
        
        var touch = sender.locationInView(self.view)
        //figure out what got pressed
        
        if CGRectContainsPoint(quizWord.frame, touch) {
            quizWordPressed(quizWord)
        }
        
        touch = sender.locationInView(imagesContainer)
        
        if CGRectContainsPoint(option1.frame, touch) {
            imageOptionPressed(1)
        }
        else if CGRectContainsPoint(option2.frame, touch) {
            imageOptionPressed(2)
        }
        else if CGRectContainsPoint(option3.frame, touch) {
            imageOptionPressed(3)
        }
        else if CGRectContainsPoint(option4.frame, touch) {
            imageOptionPressed(4)
        }
        
    }
    
    func quizWordPressed(sender: UILabel) {
        quizAnswer?.playAudio()
        sender.alpha = 0.5
        UIView.animateWithDuration(0.5, animations: { sender.alpha = 1.0 })
        shakeTitle()
    }
    
    func shakeTitle() {
        let animations : [CGFloat] = [20.0, -20.0, 10.0, -10.0, 3.0, -3.0, 0]
        for i in 0 ..< animations.count {
            let frameOrigin = CGPointMake(quizWord.frame.origin.x + animations[i], quizWord.frame.origin.y)
            UIView.animateWithDuration(0.1, delay: NSTimeInterval(0.1 * Double(i)), options: nil, animations: {
                self.quizWord.frame.origin = frameOrigin
            }, completion: nil)
        }
    }
    
    func imageOptionPressed(id: Int) {
        answerAttempts++
        let word = quizChoices[id - 1]
        
        if word.name == quizAnswer!.name {
            correct.hidden = false
            incorrect.hidden = true
            self.view.setNeedsDisplay()
            word.playAudio()
            self.view.userInteractionEnabled = false
            
            //animate "correct"
            let start = correct.frame.origin
            let temp = CGPointMake(start.x, self.view.frame.height * 1.2)
            correct.frame.origin = temp
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: nil, animations: {
                self.correct.frame.origin = start
            }, completion: nil)
            
            delay(1.0, {
                self.poseQuestion()
                self.view.userInteractionEnabled = true
            })
            
            //animate coin
            if answerAttempts == 1 {
                coin.image = goldCoin
            }
            if answerAttempts == 2 {
                coin.image = silverCoin
            }
            if answerAttempts == 1 || answerAttempts == 2 {
                
                coin.center = imageViewMap[id - 1].center
                let animateUpTo = CGPointMake(coin.center.x, coin.center.y - imageViewMap[id - 1].frame.height * 1.0)
                let animateDownTo = coin.center
                
                UIView.animateWithDuration(0.3, animations: {
                    self.coin.alpha = 1.0
                })
                
                UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: nil, animations: {
                        self.coin.center = animateUpTo
                    }, completion: nil)
                
                UIView.animateWithDuration(0.3, delay: 0.3, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: nil, animations: {
                        self.coin.center = animateDownTo
                        self.coin.alpha = 0.0
                    }, completion: nil)
            }
        }
        else {
            incorrect.hidden = false
            incorrect.layer.removeAllAnimations()
            incorrect.alpha = 1.0
            correct.hidden = true
            self.view.setNeedsDisplay()
            word.playAudio()
            
            //animate "incorrect"
            let start = incorrect.frame.origin
            let temp = CGPointMake(start.x, self.view.frame.height * 1.2)
            incorrect.frame.origin = temp
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: nil, animations: {
                self.incorrect.frame.origin = start
            }, completion: nil)
            
            UIView.animateWithDuration(1.5, animations: { self.incorrect.alpha = 0.0 })
        }
        
        let image = imageViewMap[id - 1]
        image.alpha = 0.5
        UIView.animateWithDuration(0.5, animations: { image.alpha = 1.0 })
    }
    
}
