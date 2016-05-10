//
//  SetupLeftViewController.swift
//  DocPort
//
//  Created by RAVIKUMAR on 25/10/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import UIKit

class Profile
{
    var name : String = ""
    var categories : [String] = []
}
class SetupLeftViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate{

    var profiles : [FileInfo] = []
    @IBOutlet weak var tableView: UITableView!
    var fHandler : FileHandler?
    var appRootPath : String = ""
    var leftBtn:UIButton?
    var profilesArray = [Profile]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Doc Port"
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        initializeLeftView()
        tableView.reloadData()
        
        
        
        let tapR : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "gotoSectionHeaderTapped:")
        tapR.delegate = self
        tapR.numberOfTapsRequired = 1
        tapR.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapR)
    
    }
    func gotoSectionHeaderTapped(sender:UITableViewHeaderFooterView)
    {
        
        var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SetupViewController") as! SetupViewController
        var centerNavController = UINavigationController(rootViewController: centerViewController)
        var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.centerViewController = centerNavController
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: false, completion: nil)
        
       
         //println("\(sender.contentView.subviews))")
    }
    func initializeLeftView()
    {
       // self.tableView.tableHeaderView?.frame = CGRect(x: 10, y: 50, width: 200, height: 80)
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
                if category.name.rangeOfString(".") == nil
                {
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

        cell.textLabel?.text = cellValue
       return cell
        
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        var sectionHeader : String = profilesArray[section].name
        var profileFolderPath = "\(appRootPath)/\(BaseData.rootPath)/\(sectionHeader)"
        let profilePicFullPath = profileFolderPath.stringByAppendingPathComponent("profile_pic.png")
        var profilePicImage = UIImage(contentsOfFile: profilePicFullPath)
        var view = UIView(frame: CGRectMake(0,0,200,80))
        
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        imageView.image = profilePicImage
        view.addSubview(imageView)
        
        var btn = UIButton(frame: CGRect(x: 55, y: 0, width: view.bounds.width+50, height: 60))
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
        
       // view.frame = CGRect(x: 0, y: 40, width: 200, height: 400)
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
}
