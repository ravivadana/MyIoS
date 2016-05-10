//
//  LeftSideViewController.swift
//  DocPort
//
//  Created by RAVIKUMAR on 24/09/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import UIKit

class RightSideViewController: BaseViewController, UITableViewDataSource,UITableViewDelegate {
    var localizer = Localizer()
    @IBOutlet weak var tableView: UITableView!
    var menuItems:[String]? = ["Categories","Themes","Languages"]
    @IBOutlet weak var menuItemLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = localizer.getLocalizedString("Settings")
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
         tableView.reloadData()
        self.title =  localizer.getLocalizedString("Settings")
         tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menuItems!.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! CustomTableViewCell
        switch menuItems![indexPath.row]
        {
            
        case "Profile":
            var image : UIImage = UIImage(named: "Profile")!
            cell.imageView?.image = image
        case "Categories":
            var image : UIImage = UIImage(named: "Categories")!
            cell.imageView?.image = image
        case "Themes":
                var image : UIImage = UIImage(named: "Themes")!
                cell.imageView?.image = image
        case "Languages":
            var image : UIImage = UIImage(named: "Languages")!
            cell.imageView?.image = image
        case "Import Options":
            var image : UIImage = UIImage(named: "Imports")!
            cell.imageView?.image = image
        case "Export Options":
            var image : UIImage = UIImage(named: "Exports")!
            cell.imageView?.image = image
        case "Zip":
            var image : UIImage = UIImage(named: "Zip")!
            cell.imageView?.image = image
        case "Document Types":
            var image : UIImage = UIImage(named: "DocTypes")!
            cell.imageView?.image = image
        default:
            println("Default Setting")
        }
        
        cell.textLabel?.text =  localizer.getLocalizedString(menuItems![indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var selectedCellValue = menuItems![indexPath.row]
        
        if selectedCellValue == "Profile"
        {
            var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        }
        else
        {
            var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingViewController") as! SettingViewController
            var centerNavController = UINavigationController(rootViewController: centerViewController)
            var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer?.centerViewController = centerNavController
            appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: false, completion: nil)
            centerViewController.settingName=selectedCellValue
            
            var ActiveLanguage : String = (NSUserDefaults.standardUserDefaults().objectForKey("selectedLanguage") as? String)!
            var  appDbWrapper = AppDbWrapper()
            ActiveLanguage = appDbWrapper.getLanguageByCode(ActiveLanguage)
            centerViewController.ActiveLanguage = ActiveLanguage

        }
        
       
    }
    
}
