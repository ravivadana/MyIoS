//
//  LeftSideViewController.swift
//  DocPort
//
//  Created by RAVIKUMAR on 24/09/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import UIKit

class LeftSideViewController: BaseViewController,UITableViewDelegate,UIActionSheetDelegate, UITableViewDataSource,UIGestureRecognizerDelegate{
    var localizer = Localizer()
    var profiles : [FileInfo] = []
    @IBOutlet weak var tableView: UITableView!
    var fHandler : FileHandler?
    var appRootPath : String = ""
    var leftBtn:UIButton?
    var profilesArray = [Profile]()
    var addTapped : Bool = false
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Doc Port"
        
//        
//        let tapR : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "gotoSectionHeaderTapped:")
//        tapR.delegate = self
//       // println("\(tapR.)")
//        tapR.numberOfTapsRequired = 1
//        tapR.numberOfTouchesRequired = 1
//        self.view.addGestureRecognizer(tapR)
        
    }
    func gotoSectionHeaderTapped(sender:AnyObject)
    {
        
        println("gotoSectionHeaderTapped")
    }
    
    @IBAction func searchTapped(sender: AnyObject) {
        var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
        var centerNavController = UINavigationController(rootViewController: centerViewController)
        var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.centerViewController = centerNavController
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        //centerViewController.folderPath = "\(appRootPath)/\(BaseData.rootPath)/\(selectedProfileName)/\(selectedCategory)"
    }
    
    @IBAction func profileAddTapped(sender: AnyObject)
    {
        
        var AddProfile = localizer.getLocalizedString("Add Profile")
        var UpdateCategories = localizer.getLocalizedString("Update Categories")
        var AddFolder = localizer.getLocalizedString("Add Folder")
        var AddFileFromLibrary = localizer.getLocalizedString("Add File From Library")
        var AddTextFile = localizer.getLocalizedString("Add Text File")
        var Cancel = localizer.getLocalizedString("Cancel")
        var ChooseOption=localizer.getLocalizedString("Choose Option")
        
        addTapped=true
        let actionSheet = UIActionSheet(title: ChooseOption, delegate: self, cancelButtonTitle: Cancel, destructiveButtonTitle: nil, otherButtonTitles: AddProfile, UpdateCategories)
        
        actionSheet.showInView(self.view)

        

    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        
        if addTapped == true
        {
            println("\(buttonIndex)")
            switch (buttonIndex){
                
            case 0:
                println("Cancel")
            case 1:
                AddProfile();
            case 2:
                UpdateCategories()
            case 3:
                AddFolder()
            case 4:
                 println("4")
             //   addFileFromLibrary()
            default:
                println("Other Selected")
                //Some code here..
                
            }
        }

    }
    func AddFolder()
    {
        
    }
    func UpdateCategories()
    {
        var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingViewController") as! SettingViewController
        var centerNavController = UINavigationController(rootViewController: centerViewController)
        var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.centerViewController = centerNavController
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: false, completion: nil)
        centerViewController.settingName = "Categories"
         appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
        var ActiveLanguage : String = (NSUserDefaults.standardUserDefaults().objectForKey("selectedLanguage") as? String)!
        var  appDbWrapper = AppDbWrapper()
        ActiveLanguage = appDbWrapper.getLanguageByCode(ActiveLanguage)
        centerViewController.ActiveLanguage = ActiveLanguage
        
    }
    

    func AddProfile()
    {
        var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var rootViewController = appDelegate.window?.rootViewController
        var mainStoryBoard : UIStoryboard = UIStoryboard(name: "Setup", bundle: nil)
        var centerViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("SetupViewController") as! SetupViewController
        var setupLeftViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("SetupLeftViewController") as! SetupLeftViewController
        var setupRightViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("SetupLeftViewController") as! SetupLeftViewController
        
        var setupLeftSideNav = UINavigationController(rootViewController: setupLeftViewController)
        var centerNav = UINavigationController(rootViewController: centerViewController)
        var setupRightSideNav = UINavigationController(rootViewController: setupRightViewController)
        var centerContainer :MMDrawerController?
        
        centerContainer = MMDrawerController(centerViewController: centerNav, leftDrawerViewController: setupLeftSideNav, rightDrawerViewController: nil)
        
        centerContainer?.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
        centerContainer?.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView
        
        appDelegate.window?.rootViewController = centerContainer
        appDelegate.window?.makeKeyAndVisible()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        initializeLeftView()
        tableView.reloadData()
    }
    func initializeLeftView()
    {
        profilesArray = [Profile]()
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        appRootPath = paths.firstObject as! String
        fHandler = FileHandler()
        profiles = fHandler!.getFilesFromDocumentsFolder("\(appRootPath)/\(BaseData.rootPath)")
        
        for profile in profiles{
            var p = Profile()
            p.name = profile.name
            var categories : [FileInfo] = []
            var profileFolderPath = profile.fullPath
            categories = fHandler!.getFilesFromDocumentsFolder(profileFolderPath.stringByReplacingOccurrencesOfString("file://", withString: ""))
            for category in categories
            {
                if category.name.rangeOfString(".") == nil{
                     p.categories.append(category.name)
                }
            }
            profilesArray.append(p)
        }
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return profilesArray.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return profilesArray[section].categories.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! UITableViewCell
        
        var cellValue = profilesArray[indexPath.section].categories[indexPath.row]
        cell.textLabel?.text = localizer.getLocalizedString(cellValue)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        var sectionHeader : String = profilesArray[section].name
        var profileFolderPath = "\(appRootPath)/\(BaseData.rootPath)/\(sectionHeader)"
        let profilePicFullPath = profileFolderPath.stringByAppendingPathComponent("profile_pic.png")
        var profilePicImage = UIImage(contentsOfFile: profilePicFullPath)
        var view = UIView(frame: CGRectMake(0,0,200,60))
        
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.image = profilePicImage
        view.addSubview(imageView)
        

        
        var btn = UIButton(frame: CGRect(x: 41, y: 0, width: view.bounds.width+50, height: 40))
        btn.setTitle(sectionHeader, forState: UIControlState.Normal)
        btn.titleLabel?.textAlignment = NSTextAlignment.Justified
        
        if let userSelectedColorData  = NSUserDefaults.standardUserDefaults().objectForKey("UserSelectedColor") as? NSData {
            if let userSelectedColor = NSKeyedUnarchiver.unarchiveObjectWithData(userSelectedColorData) as? UIColor {
                // view.backgroundColor = userSelectedColor
                btn.backgroundColor = userSelectedColor
            }
        }
        
        
        //  UIButton.font = UIFont(name: label.font.fontName, size: 20)
        
        btn.addTarget(self, action: "headerTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(btn)
        
        return view
    }
    func headerTapped(sender:UIButton)
    {
        var profileName : String  = ""
        profileName = sender.titleLabel!.text!
        
        var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var rootViewController = appDelegate.window?.rootViewController
        var mainStoryBoard : UIStoryboard = UIStoryboard(name: "Setup", bundle: nil)
        var centerViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("SetupViewController") as! SetupViewController
        var setupLeftViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("SetupLeftViewController") as! SetupLeftViewController
        var setupRightViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("SetupLeftViewController") as! SetupLeftViewController
        
        var setupLeftSideNav = UINavigationController(rootViewController: setupLeftViewController)
        var centerNav = UINavigationController(rootViewController: centerViewController)
        var setupRightSideNav = UINavigationController(rootViewController: setupRightViewController)
        var centerContainer :MMDrawerController?
        
        centerContainer = MMDrawerController(centerViewController: centerNav, leftDrawerViewController: setupLeftSideNav, rightDrawerViewController: nil)
        
        centerContainer?.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
        centerContainer?.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView
        centerViewController.profileName = profileName
        
        appDelegate.window?.rootViewController = centerContainer
        appDelegate.window?.makeKeyAndVisible()
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var selectedSectionIndex = indexPath.section
        var selectedRowIndexInSection = indexPath.row
        
        var selectedProfileName = profilesArray[selectedSectionIndex].name
        var selectedCategory = profilesArray[selectedSectionIndex].categories[selectedRowIndexInSection]
        
        var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        var centerNavController = UINavigationController(rootViewController: centerViewController)
        var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.centerViewController = centerNavController
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        centerViewController.folderPath = "\(appRootPath)/\(BaseData.rootPath)/\(selectedProfileName)/\(selectedCategory)"
        
        
    }
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.Delete) {
//            // handle delete (by removing the data from your array and updating the tableview)
//        }
//    }
}
