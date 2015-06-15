//
//  BodyViewController.swift
//  WordWorld
//
//  Created by Cal on 6/3/15.
//  Copyright (c) 2015 Hear a Tale. All rights reserved.
//

import Foundation
import UIKit

let WWCloseClassCollectionNotification = "com.hearatale.wordworld.closeclass"
let WWBodyBackgroundThread = dispatch_queue_create("WWBodyBackground", nil)

class BodyViewController : UIViewController {
    
    @IBOutlet weak var body: UIImageView!
    @IBOutlet weak var skinTone: UIImageView!
    @IBOutlet weak var socks: UIImageView!
    @IBOutlet weak var shoes: UIImageView!
    @IBOutlet weak var pants: UIImageView!
    @IBOutlet weak var belt: UIImageView!
    @IBOutlet weak var shirt: UIImageView!
    @IBOutlet weak var bowtie: UIImageView!
    @IBOutlet weak var mouth: UIImageView!
    @IBOutlet weak var nose: UIImageView!
    @IBOutlet weak var eyes: UIImageView!
    @IBOutlet weak var hair: UIImageView!
    @IBOutlet weak var glasses: UIImageView!
    @IBOutlet weak var wrist: UIImageView!
    @IBOutlet weak var hold: UIImageView!
    
    var imageMap: [String : UIImageView]?
    var features: [BodyFeature] = []
    
    var currentSkinToneFeature: BodyFeature?
    let outlineHolding = "Body-Feature-body2"
    let outlineStraight = "Body-Feature-body"
    
    @IBOutlet weak var categoryCollection: UICollectionView!
    var categoryDelegate: CategoryCollectionDelegate?
    
    @IBOutlet weak var classCollection: UICollectionView!
    @IBOutlet weak var classConstraint: NSLayoutConstraint!
    var classDelegate: ClassCollectionDelegate?
    
    override func viewWillAppear(animated: Bool) {
        imageMap = [
            "bodyShape" : body,
            "body" : skinTone,
            "socks" : socks,
            "shoes" : shoes,
            "pants" : pants,
            "belt" : belt,
            "shirt" : shirt,
            "bowtie" : bowtie,
            "mouth" : mouth,
            "nose" : nose,
            "eyes" : eyes,
            "hair" : hair,
            "glasses" : glasses,
            "wrist" : wrist,
            "hold" : hold
        ]
        
        //load data from CSV
        let csvPath = NSBundle.mainBundle().pathForResource("body feature database", ofType: "csv")!
        let csvString = String(contentsOfFile: csvPath, encoding: NSUTF8StringEncoding, error: nil)!
        let csv = split(csvString){ $0 == "\n" }
        
        //process csv
        for line in csv {
            let cells = split(line){ $0 == "," }
            if cells.count != 3 {
                continue
            }
            
            let feature = BodyFeature(csvEntry: line)
            features.append(feature)
        }
        
        //set up collection views
        //category collection
        categoryDelegate = CategoryCollectionDelegate(controller: self)
        categoryCollection.delegate = categoryDelegate!
        categoryCollection.dataSource = categoryDelegate!
        categoryCollection.reloadData()
        
        //class collection
        classDelegate = ClassCollectionDelegate(controller: self)
        classCollection.delegate = classDelegate
        classCollection.dataSource = classDelegate
        classConstraint.constant = -(classCollection.frame.width + 100)
        self.view.layoutIfNeeded()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeClassCollection", name: WWCloseClassCollectionNotification, object: nil)
    }
    
    //pragma MARK: - Managing Body Figure
    
    func setImageInView(className: String, toFeature feature: BodyFeature?) {
        if let imageView = imageMap![className] {
            //deinit previous
            imageView.image = nil
            
            //set new
            imageView.image = feature?.getImage(cropped: false)
                
            //ensure correct body stance
            if className == "body" || className == "hold" {
                if className == "body" { currentSkinToneFeature = feature }
                
                let isHolding = hold.image != nil
                if isHolding {
                    body.image = UIImage(named: outlineHolding)
                    if let skinName = currentSkinToneFeature?.fileName as NSString? {
                        if skinName.containsString("-straight") {
                            let newSkinName = skinName.stringByReplacingOccurrencesOfString("-straight", withString: "")
                            currentSkinToneFeature = BodyFeature(duplicateAndChange: currentSkinToneFeature!, fileName: newSkinName)
                            setImageInView("body", toFeature: currentSkinToneFeature)
                        }
                    }
                }
                else if !isHolding {
                    body.image = UIImage(named: outlineStraight)
                    if let skinName = currentSkinToneFeature?.fileName as NSString? {
                        if !skinName.containsString("-straight") {
                            let newSkinName = "\(skinName)-straight"
                            currentSkinToneFeature = BodyFeature(duplicateAndChange: currentSkinToneFeature!, fileName: newSkinName)
                            setImageInView("body", toFeature: currentSkinToneFeature)
                        }
                    }
                }
            }
            
            
        }
    }
    
    
    @IBAction func randomize(sender: AnyObject) {
        for (className, _) in imageMap! {
            
            //get new image
            let classFeatures = allFeaturesInClass(className)
            if classFeatures.count == 0 { continue }
            let randomChoice = Int(arc4random_uniform(UInt32(count(classFeatures) - 1)))
            setImageInView(className, toFeature: classFeatures[randomChoice])
            
        }
    }
    
    func allFeaturesInClass(className: String) -> [BodyFeature] {
        var classFeatures: [BodyFeature] = []
        
        for feature in features {
            if feature.className == className {
                classFeatures.append(feature)
            }
        }
        
        return classFeatures
    }
    
    
    //pragma MARK: - Switching Between Collection Views
    
    func showClassCollection(className: String) {
        classDelegate!.setClass(className)
        classCollection.reloadData()
        classConstraint.constant = 0
        classCollection.alpha = 0.0
        
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: nil, animations: {
            self.classCollection.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func closeClassCollection() {
        classConstraint.constant = -(classCollection.frame.width + 100)
        
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: nil, animations: {
            self.classCollection.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}

//pragma MARK: - Body Feature Data

class BodyFeature {
    
    let fileName: String
    let type: String
    let className: String
    
    init(csvEntry: String) {
        //format: fileName, type, class
        let cells = split(csvEntry){ $0 == "," }
        fileName = cells[0]
        type = cells[1]
        className = cells[2]
    }
    
    init(duplicateAndChange duplicate: BodyFeature, fileName: String) {
        self.fileName = fileName
        self.type = duplicate.type
        self.className = duplicate.className
    }
    
    func getImage(#cropped: Bool) -> UIImage {
        let bundle = NSBundle.mainBundle()
        let filePath = bundle.pathForResource(fileName + (cropped ? "#cropped" : ""), ofType: "png")
        let data = NSData(contentsOfFile: filePath!)!
        return UIImage(data: data)!
    }
    
}

//pragma MARK: - Collection View Delegates

class CategoryCollectionDelegate : NSObject, UICollectionViewDelegate, UICollectionViewDataSource {

    let classOrder = ["body", "hair", "eyes", "nose", "mouth", "glasses", "shirt", "pants", "socks", "shoes", "bowtie", "belt", "wrist", "hold"]
    let controller: BodyViewController

    init(controller: BodyViewController) {
        self.controller = controller
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return classOrder.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        let className = classOrder[index]
        let all = controller.allFeaturesInClass(className)
        let feature = all[5]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("feature", forIndexPath: indexPath) as! BodyCell
        cell.decorate(feature: feature)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.width
        //three items per row with 0px padding
        let width = (collectionWidth - 2.0) / CGFloat(3.0)
        return CGSizeMake(width, width)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let className = classOrder[indexPath.item]
        controller.showClassCollection(className)
    }
    
}

class ClassCollectionDelegate : CategoryCollectionDelegate {
    
    var className: String?
    var features: [BodyFeature]?
    
    func setClass(name: String) {
        className = name
        features = controller.allFeaturesInClass(name)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let features = features {
            return features.count
        }
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let features = features {
            
            let feature = features[indexPath.item]
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("feature", forIndexPath: indexPath) as! BodyCell
            cell.decorate(feature: feature)
            
            return cell
            
        }
        return collectionView.dequeueReusableCellWithReuseIdentifier("skin", forIndexPath: indexPath) as! UICollectionViewCell
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "title", forIndexPath: indexPath) as! TitleCell
        if let className = className {
            cell.title.text = cell.classTitleMap[className]
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let feature = features![indexPath.item]
        controller.setImageInView(className!, toFeature: feature)
    }
    
}

//pragma MARK: - Collection View Cells

class BodyCell : UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    var featureName: String = ""
    
    func decorate(#feature: BodyFeature) {
        image.image = nil //deinit previous
        
        featureName = feature.fileName
        self.backgroundColor = UIColor.whiteColor()
        self.alpha = 0.0
        
        dispatch_async(WWBodyBackgroundThread, {
        
            let featureImage = feature.getImage(cropped: true)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.image.image = featureImage
                UIView.animateWithDuration(0.3, animations: {
                    self.alpha = 1.0
                })
            })
            
        })
    }
    
    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes! {
        return layoutAttributes
    }
}

class TitleCell : UICollectionReusableView {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    let classTitleMap = [
        "bodyShape" : "Body Shape",
        "body" : "Skin Tone",
        "socks" : "Socks",
        "shoes" : "Shoes",
        "pants" : "Pants",
        "belt" : "Belts",
        "shirt" : "Shirts",
        "bowtie" : "Bowties",
        "mouth" : "Mouths",
        "nose" : "Noses",
        "eyes" : "Eyes",
        "hair" : "Hair Styles",
        "glasses" : "Glasses",
        "wrist" : "Small Accessories",
        "hold" : "Big Accessories"
    ]
    
    @IBAction func backPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(WWCloseClassCollectionNotification, object: nil)
    }
}