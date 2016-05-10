//
//  FileHandler.swift
//  iBriefcase
//
//  Created by RAVIKUMAR on 08/09/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FileHandler
{
    func getFileFullPath(folderPath:String,fileName:String) -> String
    {
        var fileFullPath:String
    
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        let appRootPath = paths.firstObject as! String
        
        fileFullPath = "\(folderPath)/\(fileName)"
        
        return fileFullPath
    }
    
    func createAppRootDirectory(directory:String)  -> String   {
        var error: NSError?
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        let documentsDirectory: AnyObject = paths[0]
        
        //Create Root Path
        var dataPath = documentsDirectory.stringByAppendingPathComponent(directory)
        if (!NSFileManager.defaultManager().fileExistsAtPath(dataPath)) {
            NSFileManager.defaultManager() .createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil, error: &error)
            
        }
        return dataPath
       
    }
    func getAllFiles(documentsDirectoryFullPath:String)-> [String]
    {
         var filePaths:[String] = []
        
        let filemanager:NSFileManager = NSFileManager()
        let files = filemanager.enumeratorAtPath(documentsDirectoryFullPath)
        while let file: AnyObject = files?.nextObject() {
            var fileName : String = file as! String
            if  fileName.rangeOfString(".DS_Store") == nil && fileName.rangeOfString("Search") == nil
            {
               filePaths.append(fileName)
            }
        }
       
        
        return filePaths;
    }
    
    func getFilesFromDocumentsFolder(documentsDirectoryFullPath:String) -> [FileInfo]
    {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        let appRootPath = paths.firstObject as! String
         var files:[FileInfo] = []
       
        let fileManager = NSFileManager.defaultManager()
    
        var error : NSError?
        
        if let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath(documentsDirectoryFullPath)
        {
            
            while let element = enumerator.nextObject() as? String {
              
                if  element != ".DS_Store"
                {
                    //println(element)
                    if element.rangeOfString("/") == nil
                    {
                        var file = FileInfo()
                        file.name = element
                        file.category = documentsDirectoryFullPath.lastPathComponent
                        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
                        let documentsDirectory: AnyObject = paths[0]
                    
                        //Create Root Path
                        var rootPath = documentsDirectory.stringByAppendingPathComponent(BaseData.rootPath)
                    
                        var fileFullPath: String = "file://\(documentsDirectoryFullPath)/\(element)"
                        
                        file.fullPath = fileFullPath
                        
                        var eascapefileFullPath = fileFullPath.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())

                        
                        if let fileUrl = NSURL(string: eascapefileFullPath!)
                        {
                          if let creationDate = dateOfType(NSURLCreationDateKey, url: fileUrl)
                          {
                            //  println("\(element):Creation Date = \(creationDate)")
                              file.creationDate = creationDate
                          }
                        }
                       // println(fileFullPath)
                        files.append(file)
                       
                    }
                }
                
            }
        }
       
        files = getOrderedCategoryContent(files)
        
       return files

    }
    
    func getOrderedCategoryContent(files:[FileInfo] ) -> [FileInfo]
    {
        var temp : [FileInfo] = files
        temp.sort({$0.creationDate!.timeIntervalSinceNow < $1.creationDate!.timeIntervalSinceNow})
        
        
        return temp
        
    }
    func dateOfType(type: String, url: NSURL) -> NSDate?{ var value:AnyObject?
        var error:NSError?
        if url.getResourceValue(
        &value,
        forKey: type,
        error: &error) && value != nil{
        return value as? NSDate }
        return nil
    }
    
    func isFileAvailable(filePathInCategory:String) -> Bool
    {
        var isFileExisted = false
        var checkValidation = NSFileManager.defaultManager()
        if (checkValidation.fileExistsAtPath(filePathInCategory))
        {
            isFileExisted = true
        }
        return isFileExisted
    }
    
    func moveFile(sourePath:String, destinationFilePath:String) -> Bool
    {
        
        let yourURL = NSURL(string: sourePath)
        let urlRequest = NSURLRequest(URL: yourURL!)
        let theData = NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: nil, error: nil)
        var docURL = NSURL(fileURLWithPath: destinationFilePath)
        
        
        theData?.writeToURL(docURL!, atomically: true)
        
        return true
    
    }
    func createFolder(folderName:String,parentPath:String) -> String
    {
        var createdCategoryPath:String = ""
        var error : NSError?
        if parentPath != ""
        {
             createdCategoryPath="\(parentPath)/\(folderName)"
        }
        else
        {
            createdCategoryPath="\(folderName)"
        }
       
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(createdCategoryPath)) {
            NSFileManager.defaultManager() .createDirectoryAtPath(createdCategoryPath, withIntermediateDirectories: false, attributes: nil, error: &error)
        }
        
       // println(createdCategoryPath)
        return createdCategoryPath
    }
    
    func deleteFileOrFolder(fileOrFolderFullPath:String) -> Bool
    {
        var isDeletedFileOrFolder: Bool = false
        var fileManager:NSFileManager = NSFileManager.defaultManager()
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
            if paths.count > 0 {
                if let dirPath = paths[0] as? String {
                    var error:NSErrorPointer = NSErrorPointer()
                    fileManager.removeItemAtPath(fileOrFolderFullPath, error: error)
                    if error != nil {
                       // println(error.debugDescription)
                    }
                    else
                    {
                        isDeletedFileOrFolder=true
                    }
                }
            }
        }
        
        return isDeletedFileOrFolder;
        
        
    }
    
}