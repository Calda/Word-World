//
//  WordEntry.swift
//  WordWorld
//
//  Created by Cal on 4/5/15.
//  Copyright (c) 2015 Hear a Tale. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

class WordEntry : Printable {
    
    let name: String
    let picturePath: String
    let audioPath: String
    let subcategory: WordSubcategory
    
    var description: String {
        get {
            return "\(name) in \(subcategory.category.name)/\(subcategory.name)"
        }
    }
    
    init(name: String, picture: String, audio: String, subcategory: WordSubcategory) {
        self.name = name
        
        let pictureName = ((picture as NSString).substringToIndex(count(picture) - 4) as String)
        let pictureExt = ((picture as NSString).substringFromIndex(count(picture) - 3) as String)
        picturePath = NSBundle.mainBundle().pathForResource(pictureName, ofType: pictureExt)!
        
        let audioName = ((audio as NSString).substringToIndex(count(audio) - 4) as String)
        let audioExt = ((audio as NSString).substringFromIndex(count(audio) - 3) as String)
        audioPath = NSBundle.mainBundle().pathForResource(audioName, ofType: audioExt)!
        
        self.subcategory = subcategory
        subcategory.words.updateValue(self, forKey: name)
    }
    
    func playAudio() {
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(true, error: nil)
        audioSession.setCategory(AVAudioSessionCategoryPlayback, error: nil)
        
        let soundData = NSData(contentsOfFile: self.audioPath)
        let player = AVAudioPlayer(data: soundData, error: nil)
        player.play()
        while(player.playing) { }
        player.stop()
    }
    
}