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
        if section == 0 { return categories.count }
        else { return 0 }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let height = (collectionView.frame.height) * 0.95
        return CGSizeMake((9/16) * height, height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let notHeight = (collectionView.frame.height) * 0.05
        return UIEdgeInsetsMake(notHeight/2, notHeight/2, notHeight/2, notHeight/2)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        let card = collectionView.dequeueReusableCellWithReuseIdentifier("categoryCard", forIndexPath: indexPath) as! CategoryCell
        card.categoryName.text = categories[item]
        return card
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.view.userInteractionEnabled = false
        selected = indexPath.item
        for cell in collectionView.visibleCells() as! [CategoryCell] {
            let index = collectionView.indexPathForCell(cell)!.item
            let delta = Double(abs(index - selected!))
            animateCell(cell, delay: delta * 0.05, out: true)
        }
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as! CategoryCell
        NSNotificationCenter.defaultCenter().postNotificationName(WWDisplayWordsNotification, object: selectedCell.categoryName.text!)
    }
    
    func animateCell(cell: CategoryCell, delay: NSTimeInterval, out: Bool) {
        let currentY = cell.frame.origin.y
        let newY = (out ? currentY - (cell.frame.height * 1.15) : currentY + (cell.frame.height * 1.15))
        let newOrigin = CGPointMake(cell.frame.origin.x, newY)
        UIView.animateWithDuration(1.0, delay: delay, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: {
                cell.frame.origin = newOrigin
        }, completion: nil)
    }
    
    func represent() {
        self.view.userInteractionEnabled = true
        if let selected = selected {
            for cell in collectionView.visibleCells() as! [CategoryCell] {
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