//
//  CategoriesViewController.swift
//  DocPort
//
//  Created by RAVIKUMAR on 01/10/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController, UITableViewDataSource,UITableViewDelegate  {
    var  appDbWrapper : AppDbWrapper?
    var settingName: String = ""
    var settingItems: [AnyObject]? = []
    var ActiveLanguage : String = "English"
    lazy var localizer = Localizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let done:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("btnDone"))
        done.image=UIImage(named: "settings")
        self.navigationItem.rightBarButtonItem = done
        appDbWrapper = AppDbWrapper()
        populateSettingData(settingName)

        
    }
    func populateSettingData(settingName:String)
    {
        switch(settingName)
        {
            case "Categories":
               settingItems = appDbWrapper?.getCategoryNames()
            case "Themes":
               settingItems = appDbWrapper?.getThemeNames()
            case "Languages":
               settingItems = appDbWrapper?.getLanguages()
            case "Profile":
               settingItems = appDbWrapper?.getProfilePics()
            case "Allowed Document Types":
               settingItems = appDbWrapper?.getAllowedDocumentTypes()
            default: break;
        }
        self.navigationController!.toolbarHidden=false;
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return settingItems!.count
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        println(settingName)
        switch settingName{
          case "Themes":
            var changeLayoutColorConfirm = UIAlertController(title: "Are You Sure to Change Layout Color", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            changeLayoutColorConfirm.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                var selectedCellBackground : UIColor = self.settingItems![indexPath.row] as! UIColor
                var userSelectedColor : NSData? =    (NSUserDefaults.standardUserDefaults().objectForKey("UserSelectedColor") as? NSData)
                var colorToSetAsDefault : UIColor = selectedCellBackground
                var data : NSData = NSKeyedArchiver.archivedDataWithRootObject(colorToSetAsDefault)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: "UserSelectedColor")
                NSUserDefaults.standardUserDefaults().synchronize()
                if let userSelectedColorData  =  NSUserDefaults.standardUserDefaults().objectForKey("UserSelectedColor") as? NSData {
                    if let userSelectedColor = NSKeyedUnarchiver.unarchiveObjectWithData(userSelectedColorData) as? UIColor {
                        self.navigationController?.navigationBar.barTintColor = selectedCellBackground
                        self.navigationController?.toolbar.barTintColor = selectedCellBackground
                    }
                }
            }))
            changeLayoutColorConfirm.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
              //  println("Handle Cancel Logic here")
            }))
            presentViewController(changeLayoutColorConfirm, animated: true, completion: nil)
        case "Languages":
            var selectedCellValue: String = settingItems![indexPath.row] as! String
            var language = localizer.getLocalizedString(selectedCellValue)
            var changeLanguageConfirm = UIAlertController(title: "Are You Sure to Change Language", message: "\(language)", preferredStyle: UIAlertControllerStyle.Alert)
            changeLanguageConfirm.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                self.ActiveLanguage = selectedCellValue
                super.switchLanguage(selectedCellValue)
                self.title = self.localizer.getLocalizedString(self.settingName)
            }))
            changeLanguageConfirm.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
               // println("Handle Cancel Logic here")
            }))
            presentViewController(changeLanguageConfirm, animated: true, completion: nil)

            default:
              println("Default Action")
        }
 
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! CustomTableViewCell
        switch(settingName)
        {
        case "Languages":
            let buttonDelete : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            buttonDelete.frame = CGRectMake(100, 60, 25, 24)
            let cellDeleteHeight: CGFloat = 44.0
            buttonDelete.center = CGPoint(x: view.bounds.width - 50, y: cellDeleteHeight / 2.0)
            buttonDelete.layer.cornerRadius = 12
            var image : UIImage = UIImage(named: "delete")!
            buttonDelete.setBackgroundImage(image, forState: UIControlState.Normal)
            var cellValue : String = settingItems![indexPath.row] as! String
            
             super.switchLanguage(cellValue)
            buttonDelete.tag = indexPath.row
            
            var language : String = localizer.getLocalizedString(cellValue)
            cell.textLabel?.text = language
            buttonDelete.addTarget(self, action: "buttonLanguageDeleteClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.addSubview(buttonDelete)
            
            let buttonEdit : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            buttonEdit.frame = CGRectMake(120, 60, 25, 24)
            let cellEditHeight: CGFloat = 44.0
            buttonEdit.center = CGPoint(x: view.bounds.width - 20, y: cellEditHeight / 2.0)
            
            buttonEdit.layer.cornerRadius = 12
            var imageEdit  = UIImage(named: "edit")!
            buttonEdit.setBackgroundImage(imageEdit, forState: UIControlState.Normal)
            
            buttonEdit.tag = indexPath.row
            cell.textLabel?.text = language
            buttonEdit.addTarget(self, action: "buttonLanguageEditClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.addSubview(buttonEdit)
           // println("\(indexPath.row)=\(settingItems?.count)")
            let settingsCount : Int = (settingItems?.count)!-1
           // println("\(indexPath.row)=\(settingsCount)")
            if indexPath.row ==  settingsCount
            {
               // println("\(indexPath.row)=\(settingItems?.count)")
                super.switchLanguage(ActiveLanguage)
            }
        case "Categories":
            let buttonDelete : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            buttonDelete.frame = CGRectMake(100, 60, 25, 24)
            let cellDeleteHeight: CGFloat = 44.0
            buttonDelete.center = CGPoint(x: view.bounds.width - 50, y: cellDeleteHeight / 2.0)
            buttonDelete.layer.cornerRadius = 12
            var image : UIImage = UIImage(named: "delete")!
            buttonDelete.setBackgroundImage(image, forState: UIControlState.Normal)
            var cellValue : String = settingItems![indexPath.row] as! String
            buttonDelete.tag = indexPath.row
            cell.textLabel?.text = cellValue
            buttonDelete.addTarget(self, action: "buttonDeleteCategoryClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.addSubview(buttonDelete)
            
            let buttonEdit : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            buttonEdit.frame = CGRectMake(120, 60, 25, 24)
            let cellEditHeight: CGFloat = 44.0
            buttonEdit.center = CGPoint(x: view.bounds.width - 20, y: cellEditHeight / 2.0)
            
            buttonEdit.layer.cornerRadius = 12
            var imageEdit  = UIImage(named: "edit")!
            buttonEdit.setBackgroundImage(imageEdit, forState: UIControlState.Normal)
            
            buttonEdit.tag = indexPath.row
            cell.textLabel?.text = localizer.getLocalizedString(cellValue)
            buttonEdit.addTarget(self, action: "buttonCategoryEditClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.addSubview(buttonEdit)
            
        case "Themes":
            var cellBackground : UIColor = settingItems![indexPath.row] as! UIColor
             cell.backgroundColor = cellBackground
        case "Profile":
             var cellValue : String = settingItems![indexPath.row] as! String
             var image : UIImage = UIImage(named: "profile_pic")!
             cell.imageView!.image = image
            
            let buttonDelete : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            buttonDelete.frame = CGRectMake(100, 60, 25, 24)
            let cellDeleteHeight: CGFloat = 44.0
            buttonDelete.center = CGPoint(x: view.bounds.width - 50, y: cellDeleteHeight / 2.0)
            buttonDelete.layer.cornerRadius = 12
            var imageToDelete : UIImage  = UIImage(named: "delete")!
            buttonDelete.setBackgroundImage(imageToDelete, forState: UIControlState.Normal)
           
            buttonDelete.tag = indexPath.row
            
           // cell.imageView!.image = imageToDelete
            cell.textLabel?.text = cellValue
            buttonDelete.addTarget(self, action: "buttonDeleteProfilePicsClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.addSubview(buttonDelete)
       case "Allowed Document Types":
            
        let buttonDelete : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonDelete.frame = CGRectMake(100, 60, 25, 24)
        let cellDeleteHeight: CGFloat = 44.0
        buttonDelete.center = CGPoint(x: view.bounds.width - 50, y: cellDeleteHeight / 2.0)
        buttonDelete.layer.cornerRadius = 12
        var image : UIImage = UIImage(named: "delete")!
        buttonDelete.setBackgroundImage(image, forState: UIControlState.Normal)
        var cellValue : String = settingItems![indexPath.row] as! String
        buttonDelete.tag = indexPath.row
        cell.textLabel?.text = cellValue
        buttonDelete.addTarget(self, action: "buttonDeleteAllowedDocTypeClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.addSubview(buttonDelete)
        
        let buttonEdit : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonEdit.frame = CGRectMake(120, 60, 25, 24)
        let cellEditHeight: CGFloat = 44.0
        buttonEdit.center = CGPoint(x: view.bounds.width - 20, y: cellEditHeight / 2.0)
        
        buttonEdit.layer.cornerRadius = 12
        var imageEdit  = UIImage(named: "edit")!
        buttonEdit.setBackgroundImage(imageEdit, forState: UIControlState.Normal)
        
        buttonEdit.tag = indexPath.row
        cell.textLabel?.text = localizer.getLocalizedString(cellValue)
        buttonEdit.addTarget(self, action: "buttonAllowedDocTypeEditClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.addSubview(buttonEdit)
        default: break;
        }
          return cell
    
    }
    func buttonLanguageDeleteClicked(sender:UIButton)
    {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        var appRootPath:String = paths.firstObject as! String
        
        var languageIndex : Int = sender.tag as Int
        var languageToDelete: String = self.settingItems![languageIndex] as! String
        
        var AreYouSureToDelete = localizer.getLocalizedString("Are You Sure To Delete")
        var Ok = localizer.getLocalizedString("Ok")
        var Cancel = localizer.getLocalizedString("Cancel")
        languageToDelete = localizer.getLocalizedString("\(languageToDelete)")
        
        var deleteConfirm = UIAlertController(title: AreYouSureToDelete, message: "\(languageToDelete)", preferredStyle: UIAlertControllerStyle.Alert)
        deleteConfirm.addAction(UIAlertAction(title: Ok, style: .Default, handler: { (action: UIAlertAction!) in
            
            let defaults = NSUserDefaults.standardUserDefaults()
            var storedLanguages = defaults.objectForKey("languages") as? [String] ?? [String]()
            var updateLanguages : [String] = []
            for storedLanguage in storedLanguages
            {
                if storedLanguage != languageToDelete
                {
                    updateLanguages.append(storedLanguage)
                }
            }
            
            defaults.setObject(updateLanguages, forKey: "languages")
            defaults.synchronize()
            self.settingItems = self.appDbWrapper?.getLanguages()
            self.tableView.reloadData()
            
        }))
        deleteConfirm.addAction(UIAlertAction(title: Cancel, style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Cancel Logic here")
        }))
        presentViewController(deleteConfirm, animated: true, completion: nil)
    }
    func buttonLanguageEditClicked(sender:UIButton)
    {
        var settingItemIndex : Int = sender.tag as Int
        var settngToEdit: String = self.settingItems![settingItemIndex] as! String
        var EnterCategoryName = localizer.getLocalizedString("Enter Category Name")
        var Cancel = localizer.getLocalizedString("Cancel")
        var Done = localizer.getLocalizedString("Done")
        
        func configurationTextField(textField: UITextField!)
        {
            //println("generating the TextField")
            textField.placeholder = EnterCategoryName
            tField = textField
            tField?.text = settngToEdit
        }
        func handleCancel(alertView: UIAlertAction!)
        {
            println("Cancelled !!")
        }
        
        var alert = UIAlertController(title: EnterCategoryName, message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: Cancel, style: UIAlertActionStyle.Cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: Done, style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            let defaults = NSUserDefaults.standardUserDefaults()
            var storedLanguages = defaults.objectForKey("languages") as? [String] ?? [String]()
            var updateLanguages : [String] = []
            for storedLanguage in storedLanguages
            {
                if storedLanguage == settngToEdit
                {
                    updateLanguages.append((self.tField!.text))
                }
                else
                {
                    updateLanguages.append(storedLanguage)
                }
            }
            
            defaults.setObject(updateLanguages, forKey: "languages")
            defaults.synchronize()
            self.settingItems = self.appDbWrapper?.getLanguages()
            self.tableView.reloadData()
            
        }))
        self.presentViewController(alert, animated: true, completion: {
            println("completion block")
        })

    }
    func buttonCategoryEditClicked(sender:UIButton)
    {
        var settingItemIndex : Int = sender.tag as Int
        var settngToEdit: String = self.settingItems![settingItemIndex] as! String
        var EnterCategoryName = localizer.getLocalizedString("Enter Category Name")
        var Cancel = localizer.getLocalizedString("Cancel")
        var Done = localizer.getLocalizedString("Done")
        func configurationTextField(textField: UITextField!)
        {
            
            textField.placeholder = EnterCategoryName
            tField = textField
            tField?.text = settngToEdit
        }
        func handleCancel(alertView: UIAlertAction!)
        {
            println("Cancelled !!")
        }
        
        var alert = UIAlertController(title: EnterCategoryName, message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: Cancel, style: UIAlertActionStyle.Cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: Done, style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            let defaults = NSUserDefaults.standardUserDefaults()
            var storedCategories = defaults.objectForKey("categories") as? [String] ?? [String]()
            var updateCategories : [String] = []
            for storedCategory in storedCategories
            {
                if storedCategory == settngToEdit
                {
                    updateCategories.append((self.tField!.text))
                }
                else
                {
                    updateCategories.append(storedCategory)
                }
            }
            
            defaults.setObject(updateCategories, forKey: "categories")
            defaults.synchronize()
            self.settingItems = self.appDbWrapper?.getCategoryNames()
            self.tableView.reloadData()
            
        }))
        self.presentViewController(alert, animated: true, completion: {
            println("completion block")
        })

        
    }
    
    func buttonDeleteCategoryClicked(sender:UIButton)
    {
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        var appRootPath:String = paths.firstObject as! String

        var categoryIndex : Int = sender.tag as Int
        var categoryToDelete: String = self.settingItems![categoryIndex] as! String
        var categoryPath : String = "\(appRootPath)/\(BaseData.rootPath)/\(categoryToDelete)"
        var filesOrFoldersInCategory: [FileInfo] = fHandler.getFilesFromDocumentsFolder(categoryPath)
        var fileCount : Int = 0
        var folderCount : Int = 0
        for file in filesOrFoldersInCategory
        {
            if (file.name.rangeOfString(".") != nil)
            {
                fileCount++
            }
            else
            {
                folderCount++
            }
        }
        
        var contains : String = "\n(\(folderCount)) Folders and (\(fileCount)) Files"
        
        var AreYouSureToDelete = localizer.getLocalizedString("Are You Sure To Delete")
        var Ok = localizer.getLocalizedString("Ok")
        
        var deleteConfirm = UIAlertController(title: AreYouSureToDelete, message: "\(categoryToDelete) Category Contains \(contains)", preferredStyle: UIAlertControllerStyle.Alert)
            deleteConfirm.addAction(UIAlertAction(title: Ok, style: .Default, handler: { (action: UIAlertAction!) in
            
                let defaults = NSUserDefaults.standardUserDefaults()
                var storedCategories = defaults.objectForKey("categories") as? [String] ?? [String]()
                var updateCategories : [String] = []
                for storedCategory in storedCategories
                {
                    if storedCategory != categoryToDelete
                    {
                        updateCategories.append(storedCategory)
                    }
                }
                
                defaults.setObject(updateCategories, forKey: "categories")
                defaults.synchronize()
                self.settingItems = self.appDbWrapper?.getCategoryNames()
                self.tableView.reloadData()
                
        }))
        deleteConfirm.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Cancel Logic here")
        }))
        presentViewController(deleteConfirm, animated: true, completion: nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        ActiveLanguage = (NSUserDefaults.standardUserDefaults().objectForKey("selectedLanguage") as? String)!
        ActiveLanguage = appDbWrapper!.getLanguageByCode(ActiveLanguage)
       // println(ActiveLanguage)
        
        self.title = localizer.getLocalizedString(settingName)
        var image : UIImage?
        
        switch settingName
        {
        case "Profile":
             image = UIImage(named: "Profile")!
        case "Categories":
             image = UIImage(named: "Categories")!
        case "Themes":
             image = UIImage(named: "Themes")!
        case "Languages":
            image = UIImage(named: "Languages")!
        case "Import Options":
            image = UIImage(named: "Imports")!
        case "Export Options":
            image = UIImage(named: "Exports")!
        case "Zip":
            image = UIImage(named: "Zip")!
        case "Document Types":
             image = UIImage(named: "DocTypes")!
        default:
            println("Default Setting")
        }
        
      
       // self.title = settingName
       // navigationController!.navigationBar.setBackgroundImage(image,forBarMetrics: UIBarMetrics.Default)
      //  navigationController?.toolbar.setBackgroundImage(image, forToolbarPosition: UIBarPosition.Bottom, barMetrics: UIBarMetrics.Default)
      
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
       
    }
    func btnDone()
    {
        goToSettings()
    }

    func goToSettings()
    {
        var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        var centerNavController = UINavigationController(rootViewController: centerViewController)
        var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.centerViewController = centerNavController
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
        

    }
    
    var tField:UITextField?
    var fHandler = FileHandler()
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addSettingItem(sender: UIBarButtonItem) {
        
        switch settingName
        {
            case "Languages":
                var EnterCategoryName = localizer.getLocalizedString("Enter Category Name")
                var Cancel = localizer.getLocalizedString("Cancel")
                var Done = localizer.getLocalizedString("Done")
                
                func configurationTextField(textField: UITextField!)
                {
                    //println("generating the TextField")
                    textField.placeholder = EnterCategoryName
                    tField = textField
                }
                
                var parentCategory = self.title
                
                func handleCancel(alertView: UIAlertAction!)
                {
                    println("Cancelled !!")
                }
                
                var alert = UIAlertController(title: EnterCategoryName, message: "", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addTextFieldWithConfigurationHandler(configurationTextField)
                alert.addAction(UIAlertAction(title: Cancel, style: UIAlertActionStyle.Cancel, handler:handleCancel))
                alert.addAction(UIAlertAction(title: Done, style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                    
                    var newLanguage:String = (self.tField!.text)
                   
                    let defaults = NSUserDefaults.standardUserDefaults()
                    var storedLanguages = defaults.objectForKey("languages") as? [String] ?? [String]()
                    if !contains(storedLanguages, newLanguage)
                    {
                        storedLanguages.append(newLanguage)
                    }
                    defaults.setObject(storedLanguages, forKey: "languages")
                    defaults.synchronize()
                    self.settingItems = self.appDbWrapper?.getLanguages()
                    self.tableView.reloadData()
                    
                }))
                self.presentViewController(alert, animated: true, completion: {
                    println("completion block")
                })
            
        case "Categories":
            var EnterCategoryName = localizer.getLocalizedString("Enter Category Name")
            var Cancel = localizer.getLocalizedString("Cancel")
            var Done = localizer.getLocalizedString("Done")
            func configurationTextField(textField: UITextField!)
            {
                //println("generating the TextField")
                textField.placeholder = EnterCategoryName
                tField = textField
            }
            
            var parentCategory = self.title
            
            func handleCancel(alertView: UIAlertAction!)
            {
                println("Cancelled !!")
            }
          
            var alert = UIAlertController(title: EnterCategoryName, message: "", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addTextFieldWithConfigurationHandler(configurationTextField)
            alert.addAction(UIAlertAction(title: Cancel, style: UIAlertActionStyle.Cancel, handler:handleCancel))
            alert.addAction(UIAlertAction(title: Done, style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                var appRootPath: String = ""
                
                let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
                appRootPath = paths.firstObject as! String
                
                
                //println("Item : \(self.tField!.text)")
                var newFolder:String = (self.tField!.text)
                self.fHandler.createFolder(newFolder, parentPath: "\(appRootPath)/\(BaseData.rootPath)")
                
                let defaults = NSUserDefaults.standardUserDefaults()
                var storedCategories = defaults.objectForKey("categories") as? [String] ?? [String]()
                if !contains(storedCategories, newFolder)
                {
                    storedCategories.append(newFolder)
                }
                defaults.setObject(storedCategories, forKey: "categories")
                defaults.synchronize()
                self.settingItems = self.appDbWrapper?.getCategoryNames()
                self.tableView.reloadData()
                
            }))
            self.presentViewController(alert, animated: true, completion: {
                println("completion block")
            })
        default:
            println("Default")
        }
    }

}


