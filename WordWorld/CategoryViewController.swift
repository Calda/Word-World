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
    
    override func viewWillAppear(animated: Bool) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "represent", name: WWDisplayCategoriesNotification, object: nil)
        
        categories = DATABASE.categories.keys.array
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let height = (collectionView.frame.height) * 0.95
        
        if indexPath.item == 0 { //back card is half width
            return CGSizeMake((9/32) * height, height)
        }
        else {
            return CGSizeMake((9/16) * height, height)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let inset = getInsetSize()
        return UIEdgeInsetsMake(inset, inset, inset, inset)
    }
    
    func getInsetSize() -> CGFloat {
        let notHeight = (collectionView.frame.height) * 0.05
        return notHeight / 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        
        if item == 0 { //back card
            return collectionView.dequeueReusableCellWithReuseIdentifier("back", forIndexPath: indexPath) as UICollectionViewCell
        }
        else {
            let card = collectionView.dequeueReusableCellWithReuseIdentifier("categoryCard", forIndexPath: indexPath) as! CategoryCell
            card.categoryName.text = categories[item - 1]
            return card
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selected = indexPath.item
        
        if selected == 0 {
            //back button
            NSNotificationCenter.defaultCenter().postNotificationName(WWDismissWordModeNotification, object: nil)
        }
        
        else {
            for cell in collectionView.visibleCells() as [UICollectionViewCell] {
                let index = collectionView.indexPathForCell(cell)!.item
                let delta = Double(abs(index - selected!))
                animateCell(cell, delay: delta * 0.05, out: true)
            }
            let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as! CategoryCell
            self.view.userInteractionEnabled = false
            NSNotificationCenter.defaultCenter().postNotificationName(WWDisplayWordsNotification, object: selectedCell.categoryName.text!)
        }
    
    }
    
    func animateCell(cell: UICollectionViewCell, delay: NSTimeInterval, out: Bool) {
        let currentY = cell.frame.origin.y
        let newY = (out ? currentY - (cell.frame.height * 1.15) : getInsetSize())
        let newOrigin = CGPointMake(cell.frame.origin.x, newY)
        
        if newY == cell.frame.origin.y { //not in the right place
            let startY = currentY - (cell.frame.height * 1.15)
            cell.frame.origin = CGPointMake(cell.frame.origin.x, startY)
        }
        
        UIView.animateWithDuration(1.0, delay: delay, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
                cell.frame.origin = newOrigin
        }, completion: nil)
    }
    
    func represent() {
        self.view.userInteractionEnabled = true
        if let selected = selected {
            for cell in collectionView.visibleCells() as [UICollectionViewCell] {
                let index = collectionView.indexPathForCell(cell)!.item
                let delta = Double(abs(index - selected))
                animateCell(cell, delay: delta * 0.05, out: false)
            }
        }
        
    }
    
}

class CategoryCell : UICollectionViewCell {

    @IBOutlet weak var categoryName: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let color = UIColor(hue: CGFloat(arc4random_uniform(255)) / 255.0, saturation: 0.6, brightness: 0.8, alpha: 1.0)
        self.backgroundColor = color
        self.layer.cornerRadius = 20.0
    }
    
}