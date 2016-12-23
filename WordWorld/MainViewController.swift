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
    @IBOutlet weak var friends: UIButton!
    @IBOutlet weak var roundedBlurred: UIView!
    @IBOutlet weak var darkener: UIView!
    
    @IBOutlet weak var settingsConstrint: NSLayoutConstraint!
    var settingsSize: CGFloat = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        roundedCorners.clipsToBounds = true
        roundedCorners.layer.cornerRadius = roundedCorners.frame.height / 4
        roundedCorners.layer.masksToBounds = true
        
        roundedBlurred.clipsToBounds = true
        roundedBlurred.layer.cornerRadius = roundedBlurred.frame.height / 4
        roundedBlurred.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.closeSettings), name: NSNotification.Name(rawValue: WWCloseSettingsNotification), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //copy subviews to blur background area
        for colorView in roundedCorners.subviews {
            let copy = UIView(frame: colorView.frame)
            copy.backgroundColor = colorView.backgroundColor
            roundedBlurred.addSubview(copy)
        }
        
        //fix text size on 4S
        if self.view.frame.width < 500 {
            for subview in roundedCorners.subviews {
                if let button = subview as? UIButton {
                    let currentFont = button.titleLabel!.font
                    let newFont = UIFont(name: (currentFont?.fontName)!, size: 29)
                    button.titleLabel!.font = newFont
                }
            }
        }
    }
    
    @IBAction func pressInterfaceButton(_ sender: UIButton) {
        
        self.view.isUserInteractionEnabled = false
        
        //copy button
        let newButton = UIButton(frame: sender.frame)
        newButton.backgroundColor = sender.backgroundColor
        newButton.setTitle(sender.titleLabel!.text, for: UIControlState())
        newButton.titleLabel!.font = sender.titleLabel!.font
        newButton.titleLabel!.text = sender.titleLabel!.text
        newButton.titleLabel!.textColor! = UIColor.white
        roundedCorners.addSubview(newButton)
        
        //animate to cover all buttons
        var fullFrame: CGRect!
        for subview in self.roundedCorners.subviews {
            if fullFrame == nil {
                fullFrame = subview.frame
            }
            else {
                fullFrame = subview.frame.union(fullFrame)
            }
        }
        
        //copy blur button
        let blurButton = UIButton(frame: sender.frame)
        blurButton.backgroundColor = sender.backgroundColor
        blurButton.setTitle(sender.titleLabel!.text, for: UIControlState())
        blurButton.titleLabel!.font = sender.titleLabel!.font
        blurButton.titleLabel!.text = sender.titleLabel!.text
        blurButton.titleLabel!.textColor! = UIColor.white
        roundedBlurred.addSubview(blurButton)
        
        //animate blur button
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
                blurButton.frame = fullFrame
        }, completion: nil)
        
        //animate real button
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
                newButton.frame = fullFrame
            }, completion: { success in
                
                delay(0.25) {
                    //present selection
                    let view = sender.restorationIdentifier!
                    let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: view) as UIViewController
                    self.present(controller, animated: true, completion: {
                        
                        //reset self
                        self.view.isUserInteractionEnabled = true
                        newButton.removeFromSuperview()
                        blurButton.removeFromSuperview()
                        
                    })
                }
                
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settings = segue.destination as? SettingsViewController {
            settingsSize = settings.getDisplayHeight()
        }
        super.prepare(for: segue, sender: sender)
    }
    
    @IBAction func showSettings(_ sender: AnyObject) {
        settingsConstrint.constant = -settingsSize
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: (settingsSize == self.view.frame.height ? 1.0 : 0.7), initialSpringVelocity: 0.0, options: [], animations: {
                self.view.layoutIfNeeded()
                self.darkener.alpha = 0.4
        }, completion: nil)
    }
    
    func closeSettings() {
        settingsConstrint.constant = 0.0
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                self.view.layoutIfNeeded()
                self.darkener.alpha = 0.0
        }, completion: nil)
    }
}
