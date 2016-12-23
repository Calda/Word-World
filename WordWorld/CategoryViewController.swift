//
//  CategoryCollectionView.swift
//  WordWorld
//
//  Created by Cal on 3/22/15.
//  Copyright (c) 2015 Hear a Tale. All rights reserved.
//

import Foundation
import UIKit

class CategoryViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var selected : Int?
    var categories: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(CategoryViewController.represent), name: NSNotification.Name(rawValue: WWDisplayCategoriesNotification), object: nil)
        
        categories = Array(DATABASE.categories.keys)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (collectionView.frame.height) * 0.95
        
        if indexPath.item == 0 { //back card is half width
            return CGSize(width: (9/32) * height, height: height)
        }
        else {
            return CGSize(width: (9/16) * height, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = getInsetSize()
        return UIEdgeInsetsMake(inset, inset, inset, inset)
    }
    
    func getInsetSize() -> CGFloat {
        let notHeight = (collectionView.frame.height) * 0.05
        return notHeight / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        
        if item == 0 { //back card
            return collectionView.dequeueReusableCell(withReuseIdentifier: "back", for: indexPath) as UICollectionViewCell
        }
        else {
            let card = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCard", for: indexPath) as! CategoryCell
            card.categoryName.text = categories[item - 1]
            return card
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = indexPath.item
        
        if selected == 0 {
            //back button
            NotificationCenter.default.post(name: Notification.Name(rawValue: WWDismissWordModeNotification), object: nil)
        }
        
        else {
            for cell in collectionView.visibleCells as [UICollectionViewCell] {
                let index = collectionView.indexPath(for: cell)!.item
                let delta = Double(abs(index - selected!))
                animateCell(cell, delay: delta * 0.05, out: true)
            }
            let selectedCell = collectionView.cellForItem(at: indexPath) as! CategoryCell
            self.view.isUserInteractionEnabled = false
            NotificationCenter.default.post(name: Notification.Name(rawValue: WWDisplayWordsNotification), object: selectedCell.categoryName.text!)
        }
    
    }
    
    func animateCell(_ cell: UICollectionViewCell, delay: TimeInterval, out: Bool) {
        let currentY = cell.frame.origin.y
        let newY = (out ? currentY - (cell.frame.height * 1.15) : getInsetSize())
        let newOrigin = CGPoint(x: cell.frame.origin.x, y: newY)
        
        if newY == cell.frame.origin.y { //not in the right place
            let startY = currentY - (cell.frame.height * 1.15)
            cell.frame.origin = CGPoint(x: cell.frame.origin.x, y: startY)
        }
        
        UIView.animate(withDuration: 1.0, delay: delay, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
                cell.frame.origin = newOrigin
        }, completion: nil)
    }
    
    func represent() {
        self.view.isUserInteractionEnabled = true
        if let selected = selected {
            for cell in collectionView.visibleCells as [UICollectionViewCell] {
                let index = collectionView.indexPath(for: cell)!.item
                let delta = Double(abs(index - selected))
                animateCell(cell, delay: delta * 0.05, out: false)
            }
        }
        
    }
    
}

class CategoryCell : UICollectionViewCell {

    @IBOutlet weak var categoryName: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        let color = UIColor(hue: CGFloat(arc4random_uniform(255)) / 255.0, saturation: 0.6, brightness: 0.8, alpha: 1.0)
        self.backgroundColor = color
        self.layer.cornerRadius = 20.0
    }
    
}
