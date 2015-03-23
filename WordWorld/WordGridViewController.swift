//
//  CategoryCollectionView.swift
//  WordWorld
//
//  Created by Cal on 3/22/15.
//  Copyright (c) 2015 Hear a Tale. All rights reserved.
//

import Foundation
import UIKit

class WordGridViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var wordImages : [UIImage] = []
    
    override func viewDidAppear(animated: Bool) {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //load applicable word images
        let imagesPath = NSBundle.mainBundle().bundlePath
        if let files = NSFileManager.defaultManager().contentsOfDirectoryAtPath(imagesPath, error: nil) as? [String] {
            for file in files {
                if file.hasSuffix("png") || file.hasSuffix("jpg") || file.hasSuffix("gif") {
                    if file.hasPrefix("example set") { continue }
                    let split = file.endIndex.predecessor().predecessor().predecessor().predecessor()
                    let name = file.substringToIndex(split)
                    let ending = file.substringFromIndex(split.successor())
                    let path = NSBundle.mainBundle().pathForResource(name, ofType: ending)!
                    let image = UIImage(contentsOfFile: path)!
                    wordImages.append(image)
                }
            }
        }
        
        wordImages.sort({ _, _ in arc4random() % 2 == 0 })
        collectionView.reloadData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "represent", name: WWDisplayWordsNotification, object: nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return 27 }
        else { return 0 }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(150, 150)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("word", forIndexPath: indexPath) as WordCell
        cell.loadImage(item, from: wordImages)
        return cell
    }
    
    @IBAction func panned(sender: AnyObject) {
        let offset = collectionView.contentOffset
        if offset.y < -50 && self.view.userInteractionEnabled {
            self.view.userInteractionEnabled = false
            NSNotificationCenter.defaultCenter().postNotificationName(WWDisplayCategoriesNotification, object: nil)
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    func represent() {
        self.view.userInteractionEnabled = true
        wordImages.sort({ _, _ in arc4random() % 2 == 0 })
        collectionView.reloadData()
    }
}

class WordCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadImage(index: Int, from wordImages: [UIImage]) {
        imageView.image = wordImages[index]
        self.layer.cornerRadius = 10.0
    }
    
}