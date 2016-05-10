//
//  AppInitializer.swift
//  DocPort
//
//  Created by RAVIKUMAR on 25/09/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import CoreData

class AppInitializer
{
    
    
    init()
    {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var categories: [String] = []
        if let categoriesDb: Array<AnyObject> = defaults.valueForKey("categories") as? Array<AnyObject>
        {
            for category in categoriesDb
            {
                categories.append(category as! String)
            }
        }
        else {
            categories  = ["Education","Profession","Property"]
            defaults.setValue(categories, forKey: "categories")
            var fHandler = FileHandler()
            fHandler.createAppRootDirectory(BaseData.rootPath)
            for category in categories
            {
                fHandler.createAppRootDirectory("\(BaseData.rootPath)/\(category)")
            }
            
            //var theme : UIColor = UIColor.grayColor()
            //defaults.setObject(theme, forKey: "theme")
        }

       
    }
   
}
