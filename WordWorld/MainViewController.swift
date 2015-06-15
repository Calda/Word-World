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
    @IBOutlet weak var roundedBlurred: UIView!
    @IBOutlet weak var darkener: UIView!
    
    @IBOutlet weak var settingsConstrint: NSLayoutConstraint!
    var settingsSize: CGFloat = 0.0
    
    override func viewWillAppear(animated: Bool) {
        roundedCorners.clipsToBounds = true
        roundedCorners.layer.cornerRadius = roundedCorners.frame.height / 4
        roundedCorners.layer.masksToBounds = true
        
        roundedBlurred.clipsToBounds = true
        roundedBlurred.layer.cornerRadius = roundedBlurred.frame.height / 4
        roundedBlurred.layer.masksToBounds = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeSettings", name: WWCloseSettingsNotification, object: nil)
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
        
        //copy blur button
        let blurButton = UIButton(frame: sender.frame)
        blurButton.backgroundColor = sender.backgroundColor
        blurButton.setTitle(sender.titleLabel!.text, forState: UIControlState.Normal)
        blurButton.titleLabel!.font = sender.titleLabel!.font
        blurButton.titleLabel!.text = sender.titleLabel!.text
        blurButton.titleLabel!.textColor! = UIColor.whiteColor()
        roundedBlurred.addSubview(blurButton)
        
        //animate blur button
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
                blurButton.frame = fullFrame
        }, completion: nil)
        
        //animate real button
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
                newButton.frame = fullFrame
            }, completion: { success in
                
                delay(0.25) {
                    //present selection
                    let view = sender.restorationIdentifier!
                    let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(view) as UIViewController
                    self.presentViewController(controller, animated: true, completion: {
                        
                        //reset self
                        self.view.userInteractionEnabled = true
                        newButton.removeFromSuperview()
                        blurButton.removeFromSuperview()
                        
                    })
                }
                
        })
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let settings = segue.destinationViewController as? SettingsViewController {
            settingsSize = settings.getDisplayHeight()
        }
        super.prepareForSegue(segue, sender: sender)
    }
    
    @IBAction func showSettings(sender: AnyObject) {
        settingsConstrint.constant = -settingsSize
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: (settingsSize == self.view.frame.height ? 1.0 : 0.7), initialSpringVelocity: 0.0, options: [], animations: {
                self.view.layoutIfNeeded()
                self.darkener.alpha = 0.4
        }, completion: nil)
    }
    
    func closeSettings() {
        settingsConstrint.constant = 0.0
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                self.view.layoutIfNeeded()
                self.darkener.alpha = 0.0
        }, completion: nil)
    }
}