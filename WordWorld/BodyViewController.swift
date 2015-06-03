//
//  BodyViewController.swift
//  WordWorld
//
//  Created by Cal on 6/3/15.
//  Copyright (c) 2015 Hear a Tale. All rights reserved.
//

import Foundation
import UIKit

class BodyViewController : UIViewController {
    
    
    
}

class BodyCell : UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    func decorate(#fileName: String) {
        
        let illustration = UIImage(named: fileName)!
        image.image = illustration
        
        //fix constraints
        for any in self.constraints() {
            if let constraint = any as? NSLayoutConstraint {
                
                let constant100 = constraint.constant
                let proportion = self.frame.width / 100
                let newConstant = constant100 * proportion
                constraint.constant = newConstant
                
            }
        }
        
        self.layoutIfNeeded()
        
    }
    
}