//
//  BaseData.swift
//  iBriefcase
//
//  Created by RAVIKUMAR on 11/09/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import Foundation
import UIKit

class BaseData {
    static var PathNumber:Int! = 0
    static var SelectedCategory = "All"
    static var rootPath : String = "AppData/Users"
    static var layoutColor : UIColor = UIColor.grayColor()
    static var defaultCategories = ["Education","Profession","Property"]
    static var defaultPreferences = ["Background Color","Logo","Import Options","Export Options","Zip/UnZip","Allowed File Types"]
}

class FileInfo
{
    var name:String = ""
    var category:String = ""
    var fullPath : String = ""
    var parentPath : String = ""
    var creationDate :NSDate?
}