//
//  Localizer.swift
//  DocPort
//
//  Created by RAVIKUMAR on 13/10/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import Foundation

class Localizer
{
    var isActiveLanguageEnglish = true
    var ActiveLanguage : String
    init()
    {
        ActiveLanguage = (NSUserDefaults.standardUserDefaults().objectForKey("selectedLanguage") as? String)!
        if ActiveLanguage != "en"
        {
            isActiveLanguageEnglish = false
        }
    }
    func getLocalizedString(enkey:String) -> String
    {
        var localizedValue : String = enkey
        localizedValue = NSLocalizedString(enkey, comment: "")
        if ActiveLanguage != "en"
        {
            if localizedValue == enkey
            {
                localizedValue = getLocalizedStringFromSPList(enkey)
            }
        }
        
        return localizedValue
    }
    func getLocalizedStringFromSPList(enkey:String) -> String
    {
        var plistResult : String = enkey
        ActiveLanguage = (NSUserDefaults.standardUserDefaults().objectForKey("selectedLanguage") as? String)!
        var plistAccess = PlistAccess()
        plistResult = plistAccess.getPlistValue(enkey,language: ActiveLanguage)
        
        return plistResult
    }
}