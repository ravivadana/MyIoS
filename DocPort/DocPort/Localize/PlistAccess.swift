//
//  PlistAccess.swift
//  DocPort
//
//  Created by RAVIKUMAR on 14/10/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import Foundation


class PlistAccess
{
   
    
    func getPlistValue(key:String,language:String) -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("\(language).plist")
        
        let fileManager = NSFileManager.defaultManager()
        
      
        if(!fileManager.fileExistsAtPath(path)) {
            if let bundlePath = NSBundle.mainBundle().pathForResource("\(language)", ofType: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                fileManager.copyItemAtPath(bundlePath, toPath: path, error: nil)
              
            } else {
               // println("GameData.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
         
            
        }
        
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        
        var myDict = NSDictionary(contentsOfFile: path)
        var value : String = ""
        if let dict = myDict {
            if dict.objectForKey(key) != nil
            {
                 value = dict.objectForKey(key) as! String
            }
            else
            {
                value = NSLocalizedString(key, comment: "")
            }
            
        } else {
           value = NSLocalizedString(key, comment: "")
        }
        
        if value == ""
        {
            value = key
        }
        return value
    }
    func savePlistValue(key:String,val:String,language:String) {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("\(language).plist")
        var dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        dict.setObject(val, forKey: key)
        dict.writeToFile(path, atomically: false)
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
    }
    func addItemToPlist(key:String,val:String,language:String) {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("\(language).plist")
        var dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        dict[key] = val
        //dict.setObject(val, forKey: key)
        dict.writeToFile(path, atomically: false)
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
    }
}