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
    var categoryName : String = ""
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.dataSource = self
        collectionView.delegate = self

        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(WordGridViewController.represent(_:)), name: NSNotification.Name(rawValue: WWDisplayWordsNotification), object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wordImages.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        if item == 0 { //back button is first
            return collectionView.dequeueReusableCell(withReuseIdentifier: "back", for: indexPath) as UICollectionViewCell
        }
        if item == wordImages.count + 1 { // is the last cell -- must be the quiz button
            return collectionView.dequeueReusableCell(withReuseIdentifier: "quiz", for: indexPath) as UICollectionViewCell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "word", for: indexPath) as! WordCell
        cell.loadImage(item - 1, from: wordImages)
        return cell
    }
    
    @IBAction func panned(_ sender: AnyObject) {
        let offset = collectionView.contentOffset
        if offset.y < -50 && self.view.isUserInteractionEnabled {
            unpresent()
        }
    }
    
    @IBAction func pinched(_ sender: UIPinchGestureRecognizer) {
        if sender.scale < 0.7 && sender.velocity < -1.5
            && self.view.isUserInteractionEnabled {
            unpresent()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? WordCell {
            let word = cell.word!
            word.playAudio()
            cell.imageView.alpha = 0.5
            UIView.animate(withDuration: 0.5, animations: { cell.imageView.alpha = 1.0 })
        }
        
        else {
            if indexPath.item == 0 { //is first cell, thus Back button
                unpresent()
            }
            
            else { //is quiz button
                let quiz = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "quiz") as! QuizViewController
                self.present(quiz, animated: true, completion: nil)
                quiz.quizWithCategory(DATABASE[categoryName]!)
            }
        }
    }
    
    func unpresent() {
        self.view.isUserInteractionEnabled = false
        NotificationCenter.default.post(name: Notification.Name(rawValue: WWDisplayCategoriesNotification), object: nil)
    }
    
    func represent(_ notification: Notification) {
        categoryName = notification.object! as! String
        let category = DATABASE[categoryName]
        var words : [WordEntry] = []
        for (_ , subcategory) in category!.subcategories {
            for (_, word) in subcategory.words {
                words.append(word)
            }
        }
        
        wordImages = []
        for word in words {
            let image = UIImage(contentsOfFile: word.picturePath)!
            wordImages.append(image, word)
        }
        
        self.view.isUserInteractionEnabled = true
        collectionView.reloadData()
    }
}

class WordCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    var word : WordEntry? = nil
    
    func loadImage(_ index: Int, from wordImages: [(UIImage, WordEntry)]) {
        imageView.image = wordImages[index].0
        self.layer.cornerRadius = 10.0
        word = wordImages[index].1
    }
    
}
