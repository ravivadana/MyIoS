//
//  AppDbWrapper.swift
//  DocPort
//
//  Created by RAVIKUMAR on 25/09/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import Foundation
import CoreData

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class Language
{
    var name: String = ""
    var code: String = ""
}
class AppDbWrapper
{
   
    var appDelegate = AppDelegate()
    func getCategoryNames() ->[String]
    {
        var categories: [String] = []
        let defaults = NSUserDefaults.standardUserDefaults()
    
        if let storedCategories = defaults.objectForKey("categories") as? [String]
        {
            for category in storedCategories
            {
              categories.append(category as String)
            }
        }
        else {
            var fHandler = FileHandler()
            fHandler.createAppRootDirectory(BaseData.rootPath)
        }
        return categories
    }
    func getThemeNames() ->[UIColor]
    {
        var themes: [UIColor] = []
        
        var color1:UIColor = UIColor(netHex:0x3399FF)
        themes.append(color1)
        var color2:UIColor = UIColor(netHex:0xFF5E3A)
        themes.append(color2)
        var color3:UIColor = UIColor(netHex:0x0BD318)
       // themes.append(color3)
        var color4:UIColor = UIColor(netHex:0x5AC8FB)
        //themes.append(color4)
        var color5:UIColor = UIColor(netHex:0x1D62F0)
        themes.append(color5)
        var color6:UIColor = UIColor(netHex:0x898C90)
        themes.append(color6)
        var color7:UIColor = UIColor(netHex:0xFF3B30)
        themes.append(color7)
        var color8:UIColor = UIColor(netHex:0x4CD964)
        themes.append(color8)
        var color9:UIColor = UIColor(netHex:0x34AADC)
        themes.append(color9)
        var color10:UIColor = UIColor(netHex:0xFF5B37)
        themes.append(color10)
        var color11:UIColor = UIColor(netHex:0xD7D7D7)
        themes.append(color11)
        var color12:UIColor = UIColor(netHex:0xE4DDCA)
        themes.append(color12)
        var color13:UIColor = UIColor(netHex:0xFF3B30)
        themes.append(color13)
        var color14:UIColor = UIColor(netHex:0xF7F7F7)
        //themes.append(color14)
        var color15:UIColor = UIColor(netHex:0xFF1300)
        //themes.append(color15)
        
        
        themes.append(color9)
        
        
        return themes
    }
    
    func getLanguageByCode(code:String) -> String
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let storedLanguages = defaults.objectForKey("languages") as? [String]
        {
            for language in storedLanguages
            {
                let fullNameArr = language.componentsSeparatedByString("-")
                if fullNameArr[1] == code
                {
                    return language
                }
                
            }
  
        }
        return ""
    }
    func getLanguages() ->[String]
    {
       
        var languages: [String] = []
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let storedLanguages = defaults.objectForKey("languages") as? [String]
        {
            if storedLanguages.count > 0
            {
                for language in storedLanguages
                {
                   languages.append(language)
                }
            }
            else
            {
                languages = initializeDefaultLanguages()
            }
        }
        else {
           languages = initializeDefaultLanguages()
        }
        return languages
    }
    
    func getProfilePics() ->[String]
    {
        var pics : [String] = []
        pics.append("Pic1")
        pics.append("Pic2")
        return pics
    }
    func getAllowedDocumentTypes() -> [String]
    {
        var docTypes : [String] = []
        docTypes.append(".pdf")
        docTypes.append(".doc")
        docTypes.append(".docx")
        docTypes.append(".xls")
        docTypes.append(".xlsx")
        docTypes.append(".txt")
        return docTypes
    
    }
    func initializeDefaultLanguages() -> [String]
    {
        
        var languages: [String] = []
        let defaults = NSUserDefaults.standardUserDefaults()
        
        languages.append("English-en")
        languages.append("Spanish-es")
        languages.append("Telugu-te")
        languages.append("Tamil-ta")
        languages.append("Hindi-hi")
        languages.append("Chinese-zh")
        languages.append("Korean-ko")
        languages.append("French-fr")
        languages.append("German-de")
       
        defaults.setObject(languages, forKey: "languages")
        defaults.synchronize()
        return languages
    }
}