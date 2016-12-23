//
//  BankViewController.swift
//  WordWorld
//
//  Created by DFA Film 9: K-9 on 5/15/15.
//  Copyright (c) 2015 Hear a Tale. All rights reserved.
//

import UIKit
import Foundation

enum CoinType {
    case silver, gold
    
    func getImage() -> UIImage {
        switch(self) {
            case .silver: return UIImage(named: "Silver-Coin")!
            case .gold: return UIImage(named: "Gold-Coin")!
        }
    }
}

class BankViewController : UIViewController {
    
    @IBOutlet weak var noCoins: UIButton!
    @IBOutlet weak var coinCount: UILabel!
    @IBOutlet weak var coinView: UIView!
    @IBOutlet weak var backButton: UIButton!
    var addingNewCoins = true
    
    var goldUp: Int = 0
    var silverUp: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        updateReadout()
        coinView.layer.masksToBounds = true
        let data = UserDefaults.standard
        let gold = data.integer(forKey: "gold")
        print(gold)
        let silver = data.integer(forKey: "silver")
        
        updateReadout()
        
        for _ in 0 ..< gold {
            var wait = Double(arc4random_uniform(100)) / 50.0
            if coinView.subviews.count < 5 {
                wait = 0.0
            }
            
            delay(wait) {
                self.spawnCoinOfType(.gold)
                delay(0.1) {
                    self.goldUp += 1
                    self.updateReadout()
                }
            }
        }
        for _ in 0 ..< silver {
            var wait = Double(arc4random_uniform(100)) / 50.0
            if coinView.subviews.count < 5 {
                wait = 0.0
            }
            
            delay(wait) {
                self.spawnCoinOfType(.silver)
                delay(0.1) {
                    self.silverUp += 1
                    self.updateReadout()
                }
            }
        }
        
        if gold == 0 && silver == 0 {
            noCoins.isHidden = false
            coinCount.isHidden = true
            backButton.titleLabel!.textColor = noCoins.titleLabel!.textColor
        } else {
            noCoins.isHidden = true
            coinCount.isHidden = false
        }
    }
    
    func updateReadout() {
        let text = NSMutableAttributedString(attributedString: coinCount.attributedText!)
        
        let current = text.string
        var splits = current.components(separatedBy: " ")
        
        text.replaceCharacters(in: NSMakeRange(splits[0].characters.count + 3, splits[2].characters.count), with: "\(silverUp)")
        text.replaceCharacters(in: NSMakeRange(0, splits[0].characters.count), with: "\(goldUp)")
        coinCount.attributedText = text
    }
    
    func spawnCoinOfType(_ type: CoinType) {
        if coinView.subviews.count > 500 {
            return
        }
        let startX = CGFloat(arc4random_uniform(UInt32(self.view.frame.width)))
        
        let coin = UIImageView(frame: CGRect(x: startX - 25.0, y: -50.0, width: 50.0, height: 50.0))
        coin.image = type.getImage()
        self.coinView.addSubview(coin)
        
        let endPosition = CGPoint(x: startX - 25.0, y: self.view.frame.height + 50)
        let duration = 2.0 + (Double(Int(arc4random_uniform(1000))) / 250.0)
        UIView.animate(withDuration: duration, animations: {
            coin.frame.origin = endPosition
        }, completion: { success in
            coin.removeFromSuperview()
            if self.addingNewCoins { self.spawnCoinOfType(type) }
        })
    }
    
    @IBAction func back(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        self.addingNewCoins = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        for subview in coinView.subviews {
            subview.removeFromSuperview()
        }
    }
}
