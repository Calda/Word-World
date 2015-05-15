//
//  BankViewController.swift
//  WordWorld
//
//  Created by DFA Film 9: K-9 on 5/15/15.
//  Copyright (c) 2015 Hear a Tale. All rights reserved.
//

import UIKit

enum CoinType {
    case Silver, Gold
    
    func getImage() -> UIImage {
        switch(self) {
            case .Silver: return UIImage(named: "Silver-Coin")!
            case .Gold: return UIImage(named: "Gold-Coin")!
        }
    }
}

class BankViewController : ViewController {
    
    @IBOutlet weak var noCoins: UIButton!
    @IBOutlet weak var coinView: UIView!
    
    func start() {
        coinView.layer.masksToBounds = true
        let data = NSUserDefaults.standardUserDefaults()
        let gold = data.integerForKey("gold")
        let silver = data.integerForKey("silver")
        
        for _ in 0 ..< gold {
            spawnCoinOfType(.Gold)
        }
        for _ in 0 ..< silver {
            spawnCoinOfType(.Silver)
        }
        
        if gold == 0 && silver == 0 {
            noCoins.hidden = false
        } else {
            noCoins.hidden = true
        }
    }
    
    func spawnCoinOfType(type: CoinType) {
        let startX = CGFloat(arc4random_uniform(UInt32(self.view.frame.width)))
        
        let coin = UIImageView(frame: CGRectMake(startX, -50.0, 50.0, 50.0))
        coin.image = type.getImage()
        self.coinView.addSubview(coin)
        
        let endPosition = CGPointMake(startX, self.view.frame.height + 50)
        let duration = 2.0 + (Double(Int(arc4random_uniform(1000))) / 250.0)
        UIView.animateWithDuration(duration, animations: {
            coin.frame.origin = endPosition
        }, completion: { success in
            coin.removeFromSuperview()
            self.spawnCoinOfType(type)
        })
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
