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

let audioQueue = dispatch_queue_create("com.hearatale.audio", DISPATCH_QUEUE_SERIAL)

class WordEntry : CustomStringConvertible {
    
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
        
        let pictureName = ((picture as NSString).substringToIndex(picture.characters.count - 4) as String)
        let pictureExt = ((picture as NSString).substringFromIndex(picture.characters.count - 3) as String)
        picturePath = NSBundle.mainBundle().pathForResource(pictureName, ofType: pictureExt)!
        
        let audioName = ((audio as NSString).substringToIndex(audio.characters.count - 4) as String)
        let audioExt = ((audio as NSString).substringFromIndex(audio.characters.count - 3) as String)
        audioPath = NSBundle.mainBundle().pathForResource(audioName, ofType: audioExt)!
        
        self.subcategory = subcategory
        subcategory.words.updateValue(self, forKey: name)
    }
    
    func playAudio() {
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(true)
        try! audioSession.setCategory(AVAudioSessionCategoryPlayback)
        
        let soundData = NSData(contentsOfFile: self.audioPath)
        let player = try! AVAudioPlayer(data: soundData!)
        player.play()
        dispatch_async(audioQueue, {
            while(player.playing) { }
            player.stop()
        })
        
    }
    
}