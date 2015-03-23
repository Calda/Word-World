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

class ViewController: UIViewController {

    @IBOutlet weak var wordsConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "presentWords", name: WWDisplayWordsNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "presentCategories", name: WWDisplayCategoriesNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func presentWords() {
        wordsConstraint.constant = -self.view.frame.height
        UIView.animateWithDuration(1.0, delay: 0.25, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func presentCategories() {
        wordsConstraint.constant = 0
        UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
    }


}

