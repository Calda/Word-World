//
//  ViewController.swift
//  WordWorld
//
//  Created by Cal on 3/22/15.
//  Copyright (c) 2015 Hear a Tale. All rights reserved.
//

import UIKit

let WWDisplayWordsNotification = "com.hearatale.WordWorld.DisplayWords"
let WWDisplayCategoriesNotification = "com.hearatale.WordWorld.DisplayCategories"
let WWDismissWordModeNotification = "com.hearatale.WordWorld.DismissWordMode"

class WordModeViewController: UIViewController {

    @IBOutlet weak var wordsConstraint: NSLayoutConstraint!
    @IBOutlet weak var wordsContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(WordModeViewController.presentWords), name: NSNotification.Name(rawValue: WWDisplayWordsNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WordModeViewController.presentCategories), name: NSNotification.Name(rawValue: WWDisplayCategoriesNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WordModeViewController.dismiss as (WordModeViewController) -> () -> ()), name: NSNotification.Name(rawValue: WWDismissWordModeNotification), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func presentWords() {
        getConstraint().constant = -self.view.frame.height
        UIView.animate(withDuration: 1.0, delay: 0.25, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func presentCategories() {
        getConstraint().constant = 0
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }

    func getConstraint() -> NSLayoutConstraint {
        if wordsConstraint != nil { return wordsConstraint }
        
        for constraint in self.view.constraints as [NSLayoutConstraint] {
            if constraint.firstAttribute == NSLayoutAttribute.top {
                if let first = constraint.firstItem as? UIView {
                    if first == wordsContainer {
                        return constraint
                    }
                }
            }
        }
        
        //something went wrong
        return wordsConstraint
    }

}

