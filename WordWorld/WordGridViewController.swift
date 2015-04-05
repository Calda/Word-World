//
//  CategoryCollectionView.swift
//  WordWorld
//
//  Created by Cal on 3/22/15.
//  Copyright (c) 2015 Hear a Tale. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class WordGridViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var wordImages : [(UIImage, WordEntry)] = []
    
    override func viewDidAppear(animated: Bool) {
        collectionView.dataSource = self
        collectionView.delegate = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "represent:", name: WWDisplayWordsNotification, object: nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return wordImages.count }
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
            unpresent()
        }
    }
    
    @IBAction func pinched(sender: UIPinchGestureRecognizer) {
        if sender.scale < 0.7 && sender.velocity < -1.5
            && self.view.userInteractionEnabled {
            unpresent()
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)! as WordCell
        let word = cell.word!
        
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(true, error: nil)
        audioSession.setCategory(AVAudioSessionCategoryPlayback, error: nil)
        
        let soundData = NSData(contentsOfFile: word.audioPath)
        let player = AVAudioPlayer(data: soundData, error: nil)
        player.play()
        while(player.playing) { }
        player.stop()
        
    }
    
    func unpresent() {
        self.view.userInteractionEnabled = false
        NSNotificationCenter.defaultCenter().postNotificationName(WWDisplayCategoriesNotification, object: nil)
    }
    
    func represent(notification: NSNotification) {
        let categoryName = notification.object! as String
        let category = DATABASE[categoryName]
        var words : [WordEntry] = []
        for subcategory in category!.subcategories.values.array {
            for word in subcategory.words.values.array {
                words.append(word)
            }
        }
        
        wordImages = []
        for word in words {
            let image = UIImage(contentsOfFile: word.picturePath)!
            wordImages.append(image, word)
        }
        
        self.view.userInteractionEnabled = true
        collectionView.reloadData()
    }
}

class WordCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    var word : WordEntry? = nil
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadImage(index: Int, from wordImages: [(UIImage, WordEntry)]) {
        imageView.image = wordImages[index].0
        self.layer.cornerRadius = 10.0
        word = wordImages[index].1
    }
    
}