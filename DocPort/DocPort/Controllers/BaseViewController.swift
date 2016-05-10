//
//  BaseViewController.swift
//  DocPort
//
//  Created by RAVIKUMAR on 05/10/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let userSelectedColorData  = NSUserDefaults.standardUserDefaults().objectForKey("UserSelectedColor") as? NSData {
            if let userSelectedColor = NSKeyedUnarchiver.unarchiveObjectWithData(userSelectedColorData) as? UIColor {
                navigationController?.navigationBar.barTintColor = userSelectedColor
                navigationController?.toolbar.barTintColor = userSelectedColor
                navigationController?.setToolbarHidden(false, animated: false)
                navigationController?.navigationBar.tintColor = UIColor.brownColor()
                
                
//                var image=UIImage(named: "rainbow")
//                navigationController!.navigationBar.setBackgroundImage(image,
//                    forBarMetrics: .Default)
//                navigationController?.toolbar.setBackgroundImage(image, forToolbarPosition: UIBarPosition.Bottom, barMetrics: UIBarMetrics.Default)

            }
        }
       
       NSNotificationCenter.defaultCenter().addObserver(self, selector: "languageDidChangeNotification:", name: "LANGUAGE_DID_CHANGE", object: nil)
        languageDidChange()

    }
    override func viewDidAppear(animated: Bool) {
        if let userSelectedColorData  = NSUserDefaults.standardUserDefaults().objectForKey("UserSelectedColor") as? NSData {
            if let userSelectedColor = NSKeyedUnarchiver.unarchiveObjectWithData(userSelectedColorData) as? UIColor {
                navigationController?.navigationBar.barTintColor = userSelectedColor
                navigationController?.toolbar.barTintColor = userSelectedColor
            }
        }
    }
    func languageDidChangeNotification(notification:NSNotification){
        languageDidChange()
    }
    
    func languageDidChange(){
        
    }

    func switchLanguage(language:String) {
        
        var localeString:String?
        
        let fullNameArr = language.componentsSeparatedByString("-")
        if fullNameArr.count > 1
        {
         localeString = fullNameArr[1];
        }
        else
        {
            localeString = nil
        }
        
        if localeString != nil {
            NSNotificationCenter.defaultCenter().postNotificationName("LANGUAGE_WILL_CHANGE", object: localeString)
        }
    }

}
