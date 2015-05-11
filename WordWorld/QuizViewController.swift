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
    
    var category: WordCategory?
    
    @IBOutlet weak var quizWord: UILabel!
    /*
    
    6+: 100
    6: 75
    5: 50
    4S: 65
    
    */
    @IBOutlet weak var quizWordHeight: NSLayoutConstraint!
    
    @IBOutlet weak var option1: UIImageView!
    @IBOutlet weak var option2: UIImageView!
    @IBOutlet weak var option3: UIImageView!
    @IBOutlet weak var option4: UIImageView!
    @IBOutlet weak var imagesContainer: UIView!
    
    @IBOutlet weak var correct: UILabel!
    @IBOutlet weak var incorrect: UILabel!
    
    var imageViewMap : [UIImageView] = []
    var quizChoices : [WordEntry] = []
    var quizAnswer : WordEntry?
    
    override func viewWillAppear(animated: Bool) {
        
        func getQuizWordHeight() -> CGFloat {
            let screen = Int(self.view.frame.width)
            var constant : CGFloat
            
            switch(screen) {
                case(480): return 65.0 //4S
                case(568): return 50.0 //5
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
        if imageViewMap.count == 0 {
            imageViewMap.append(option1)
            imageViewMap.append(option2)
            imageViewMap.append(option3)
            imageViewMap.append(option4)
        }
        self.category = category
        
        setUpQuiz(usingAudio: false)
    }
    
    func setUpQuiz(usingAudio: Bool = true) {
        correct.hidden = true
        incorrect.hidden = true
        
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
        quizWord.text = quizAnswer!.name
        if usingAudio { quizAnswer!.playAudio() }
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
    }
    
    func imageOptionPressed(id: Int) {
        let word = quizChoices[id - 1]
        if word.name == quizAnswer!.name {
            correct.hidden = false
            incorrect.hidden = true
            self.view.setNeedsDisplay()
            word.playAudio()
            delay(1.0, { self.setUpQuiz() })
        }
        else {
            incorrect.hidden = false
            incorrect.layer.removeAllAnimations()
            incorrect.alpha = 1.0
            correct.hidden = true
            self.view.setNeedsDisplay()
            word.playAudio()
            UIView.animateWithDuration(1.0, animations: { self.incorrect.alpha = 0.0 })
        }
        
        let image = imageViewMap[id - 1]
        image.alpha = 0.5
        UIView.animateWithDuration(0.5, animations: { image.alpha = 1.0 })
        
    }
}
