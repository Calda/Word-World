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

let audioQueue = DispatchQueue(label: "com.hearatale.audio", attributes: [])

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
        
        let pictureName = ((picture as NSString).substring(to: picture.characters.count - 4) as String)
        let pictureExt = ((picture as NSString).substring(from: picture.characters.count - 3) as String)
        picturePath = Bundle.main.path(forResource: pictureName, ofType: pictureExt)!
        
        let audioName = ((audio as NSString).substring(to: audio.characters.count - 4) as String)
        let audioExt = ((audio as NSString).substring(from: audio.characters.count - 3) as String)
        audioPath = Bundle.main.path(forResource: audioName, ofType: audioExt)!
        
        self.subcategory = subcategory
        subcategory.words.updateValue(self, forKey: name)
    }
    
    func playAudio() {
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(true)
        try! audioSession.setCategory(AVAudioSessionCategoryPlayback)
        
        let soundData = try? Data(contentsOf: URL(fileURLWithPath: self.audioPath))
        let player = try! AVAudioPlayer(data: soundData!)
        player.play()
        audioQueue.async(execute: {
            while(player.isPlaying) { }
            player.stop()
        })
        
    }
    
}
