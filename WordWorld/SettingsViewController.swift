//
//  SettingsViewController.swift
//  WordWorld
//
//  Created by Cal on 5/24/15.
//  Copyright (c) 2015 Hear a Tale. All rights reserved.
//

import UIKit

let WWSettingReadingMode = "disableSpeakingWord"
let WWSettingDisableCoin = "disableCoinSounds"
let WWSettingDisableAllGameSounds = "disableAllQuizSounds"
let WWCloseSettingsNotification = "com.hearatale.wordworld.closesettings"

class SettingsViewController : UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let settings: [(title:String, path:String, defaults:Bool)] = [
        ("Reading Mode (Don't speak word in Game)", WWSettingReadingMode, false),
        ("Disable Coin Sound Effects", WWSettingDisableCoin, false),
        ("Disable All Quiz Game Sound Effects", WWSettingDisableAllGameSounds, false)
    ]
    
    func getDisplayHeight() -> CGFloat {
        let cells = settings.count + 1
        let height = CGFloat(70 + (cells * 43))
        if height < self.view.frame.height {
            tableView.scrollEnabled = false
        }
        return min(height, self.view.frame.height)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.item == settings.count { //last item it reset button
            return tableView.dequeueReusableCellWithIdentifier("reset")!
        }
        
        let settingCell = tableView.dequeueReusableCellWithIdentifier("switch") as! SettingsSwitchCell
        
        let (title, path, _) = settings[indexPath.item]
        settingCell.settingTitle.text = title
        settingCell.settingPath = path
        
        let data = NSUserDefaults.standardUserDefaults()
        let current = data.boolForKey(path)
        settingCell.settingSwitch.on = current
        
        return settingCell
    }
    
    @IBAction func close(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(WWCloseSettingsNotification, object: nil)
    }
}

class SettingsSwitchCell : UITableViewCell {
    
    @IBOutlet weak var settingTitle: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    var settingPath: String?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //make background transparent
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
    }
    
    @IBAction func switched(sender: UISwitch) {
        if let path = settingPath {
            let data = NSUserDefaults.standardUserDefaults()
            let previous = data.boolForKey(path)
            data.setBool(!previous, forKey: path)
        }
    }
}

class ResetCell : UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //make background transparent
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
    }
    
    @IBAction func reset(sender: AnyObject) {
        let data = NSUserDefaults.standardUserDefaults()
        data.setInteger(0, forKey: "gold")
        data.setInteger(0, forKey: "silver")
        title.text = "All data has been reset."
    }
}