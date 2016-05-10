//
//  LeftSideAccordianViewController.swift
//  DocPort
//
//  Created by RAVIKUMAR on 21/11/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import UIKit

class LeftSideAccordianViewController: BaseViewController,UIActionSheetDelegate
{
    
    var sectionTitleArray : NSMutableArray = NSMutableArray()
    var sectionContentDict : NSMutableDictionary = NSMutableDictionary()
    var arrayForBool : NSMutableArray = NSMutableArray()
    var localizer = Localizer()
    var addTapped:Bool = false
    
    @IBAction func searchTapped(sender: AnyObject) {
        var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
        var centerNavController = UINavigationController(rootViewController: centerViewController)
        var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.centerViewController = centerNavController
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
    }
  
    @IBAction func addProfileTapped(sender: AnyObject) {
        var AddProfileLabel = localizer.getLocalizedString("Add Profile")
        var UpdateCategories = localizer.getLocalizedString("Update Categories")
        var AddFolder = localizer.getLocalizedString("Add Folder")
        var AddFileFromLibrary = localizer.getLocalizedString("Add File From Library")
        var AddTextFile = localizer.getLocalizedString("Add Text File")
        var Cancel = localizer.getLocalizedString("Cancel")
        var ChooseOption=localizer.getLocalizedString("Choose Option")
        
        addTapped=true
        //let actionSheet = UIActionSheet(title: ChooseOption, delegate: self, cancelButtonTitle: Cancel, destructiveButtonTitle: nil, otherButtonTitles: AddProfile)
        
        //actionSheet.showInView(self.view)

        AddProfile();
    }
  
    
    @IBOutlet weak var tableView: UITableView!
    var appRootPath : String = ""
    var profilesArray = [Profile]()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        appRootPath = paths.firstObject as! String
        var fHandler = FileHandler()
        var profiles = fHandler.getFilesFromDocumentsFolder("\(appRootPath)/\(BaseData.rootPath)")
        
        for profile in profiles{
            var p = Profile()
            p.name = profile.name
            var categories : [FileInfo] = []
            var profileFolderPath = profile.fullPath
            categories = fHandler.getFilesFromDocumentsFolder(profileFolderPath.stringByReplacingOccurrencesOfString("file://", withString: ""))
            for category in categories
            {
                if category.name.rangeOfString(".") == nil{
                    p.categories.append(category.name)
                }
            }
            profilesArray.append(p)
        }

        for var pi=0; pi<profilesArray.count; pi++
        {
            var p = profilesArray[pi]
            arrayForBool.addObject("0")
            sectionTitleArray.addObject(p.name)
            var tmp1 : NSMutableArray = NSMutableArray()

            for var i = 0; i < p.categories.count; i++
            {
               tmp1.addObject(p.categories[i])
                var string1 = sectionTitleArray .objectAtIndex(pi) as? String
                [sectionContentDict .setValue(tmp1, forKey:string1! )]
            }
            
        }
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
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
                println("UpdateCategories")
                //UpdateCategories()
            case 3:
                  println("AddFolder")
            case 4:
                println("4")
                //   addFileFromLibrary()
            default:
                println("Other Selected")
                //Some code here..
                
            }
        }
        
    }

    func AddProfile()
    {
        var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var rootViewController = appDelegate.window?.rootViewController
        var mainStoryBoard : UIStoryboard = UIStoryboard(name: "Setup", bundle: nil)
        var centerViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("SetupViewController") as! SetupViewController
        var setupLeftViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("SetupLeftAccordianViewController") as! SetupLeftAccordianViewController
        var setupRightViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("SetupLeftAccordianViewController") as! SetupLeftAccordianViewController
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitleArray.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if(arrayForBool .objectAtIndex(section).boolValue == true)
        {
            var tps = sectionTitleArray.objectAtIndex(section) as! String
            var count1 = (sectionContentDict.valueForKey(tps)) as! NSArray
            return count1.count
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ABC"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(arrayForBool .objectAtIndex(indexPath.section).boolValue == true){
            return 50
        }
        return 2;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
       // headerView.backgroundColor = UIColor.blackColor()
        if let userSelectedColorData  =  NSUserDefaults.standardUserDefaults().objectForKey("UserSelectedColor") as? NSData {
            if let userSelectedColor = NSKeyedUnarchiver.unarchiveObjectWithData(userSelectedColorData) as? UIColor {
                headerView.backgroundColor = userSelectedColor
            }
        }
        headerView.tag = section
        
        var sectionHeader : String = (sectionTitleArray.objectAtIndex(section) as? String)!
        
        var profileFolderPath = "\(appRootPath)/\(BaseData.rootPath)/\(sectionHeader)"
        let profilePicFullPath = profileFolderPath.stringByAppendingPathComponent("profile_pic.png")
        var profilePicImage = UIImage(contentsOfFile: profilePicFullPath)
        
        let headerImgString = UIImageView(frame: CGRect(x: 5, y: 5, width: 40, height: 40)) as UIImageView
        headerImgString.image = profilePicImage
        headerView .addSubview(headerImgString)
        
        let headerString = UILabel(frame: CGRect(x: 60, y: 10, width: tableView.frame.size.width-10, height: 30)) as UILabel
        headerString.text = sectionTitleArray.objectAtIndex(section) as? String
        headerView .addSubview(headerString)
        
        let headerTapped = UITapGestureRecognizer (target: self, action:"sectionHeaderTapped:")
        headerView .addGestureRecognizer(headerTapped)
        
        return headerView
    }
    
    func sectionHeaderTapped(recognizer: UITapGestureRecognizer) {
       // println("Tapping working")
       // println(recognizer.view?.tag)
        
        var indexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection:(recognizer.view?.tag as Int!)!)
        if (indexPath.row == 0) {
            
            var collapsed = arrayForBool .objectAtIndex(indexPath.section).boolValue
            collapsed       = !collapsed;
            
            arrayForBool .replaceObjectAtIndex(indexPath.section, withObject: collapsed)
            //reload specific section animated
            var range = NSMakeRange(indexPath.section, 1)
            var sectionToReload = NSIndexSet(indexesInRange: range)
            self.tableView .reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let CellIdentifier = "Cell"
        var cell :UITableViewCell
        cell = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! UITableViewCell
        
        var manyCells : Bool = arrayForBool .objectAtIndex(indexPath.section).boolValue
        
        if (!manyCells) {
            //  cell.textLabel.text = @"click to enlarge";
        }
        else{
            var content = sectionContentDict .valueForKey(sectionTitleArray.objectAtIndex(indexPath.section) as! String) as! NSArray
            cell.textLabel?.text = content .objectAtIndex(indexPath.row) as? String
            //cell.backgroundColor = UIColor .greenColor()
        }
        
        return cell
    }
    
    
}
