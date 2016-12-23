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
            tableView.isScrollEnabled = false
        }
        return min(height, self.view.frame.height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == settings.count { //last item it reset button
            return tableView.dequeueReusableCell(withIdentifier: "reset")!
        }
        
        let settingCell = tableView.dequeueReusableCell(withIdentifier: "switch") as! SettingsSwitchCell
        
        let (title, path, _) = settings[indexPath.item]
        settingCell.settingTitle.text = title
        settingCell.settingPath = path
        
        let data = UserDefaults.standard
        let current = data.bool(forKey: path)
        settingCell.settingSwitch.isOn = current
        
        return settingCell
    }
    
    @IBAction func close(_ sender: AnyObject) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: WWCloseSettingsNotification), object: nil)
    }
}

class SettingsSwitchCell : UITableViewCell {
    
    @IBOutlet weak var settingTitle: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    var settingPath: String?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //make background transparent
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
    }
    
    @IBAction func switched(_ sender: UISwitch) {
        if let path = settingPath {
            let data = UserDefaults.standard
            let previous = data.bool(forKey: path)
            data.set(!previous, forKey: path)
        }
    }
}

class ResetCell : UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var button: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //make background transparent
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
    }
    
    @IBAction func reset(_ sender: AnyObject) {
        let data = UserDefaults.standard
        data.set(0, forKey: "gold")
        data.set(0, forKey: "silver")
        
        title.text = "All data has been reset."
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                self.button.transform = self.button.transform.rotated(by: CGFloat(M_PI))
            }, completion: { success in
                self.title.text = "Reset All Data"
        })
    }
}
