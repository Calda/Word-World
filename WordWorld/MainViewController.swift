//
//  MainViewController.swift
//  WordWorld
//
//  Created by Cal on 5/23/15.
//  Copyright (c) 2015 Hear a Tale. All rights reserved.
//

import Foundation
import UIKit

class MainViewController : UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var roundedCorners: UIView!
    @IBOutlet weak var words: UIButton!
    @IBOutlet weak var bank: UIButton!
    @IBOutlet weak var game: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        roundedCorners.clipsToBounds = true
        roundedCorners.layer.cornerRadius = roundedCorners.frame.height / 4
        roundedCorners.layer.masksToBounds = true
    }
    
    @IBAction func pressInterfaceButton(sender: UIButton) {
        
        self.view.userInteractionEnabled = false
        
        //copy button
        let newButton = UIButton(frame: sender.frame)
        newButton.backgroundColor = sender.backgroundColor
        newButton.setTitle(sender.titleLabel!.text, forState: UIControlState.Normal)
        newButton.titleLabel!.font = sender.titleLabel!.font
        newButton.titleLabel!.text = sender.titleLabel!.text
        newButton.titleLabel!.textColor! = UIColor.whiteColor()
        roundedCorners.addSubview(newButton)
        
        //animate to cover all buttons
        let fullFrame = CGRectUnion(words.frame, CGRectUnion(bank.frame, game.frame))
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: nil, animations: {
                newButton.frame = fullFrame
            }, completion: { success in
                
                delay(0.25) {
                    //present selection
                    let view = sender.restorationIdentifier!
                    let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(view) as! UIViewController
                    self.presentViewController(controller, animated: true, completion: {
                        
                        //reset self
                        self.view.userInteractionEnabled = true
                        newButton.removeFromSuperview()
                        
                    })
                }
                
        })
        
    }
    
    
}