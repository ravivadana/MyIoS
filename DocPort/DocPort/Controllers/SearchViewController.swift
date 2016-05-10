//
//  SearchViewController.swift
//  DocPort
//
//  Created by RAVIKUMAR on 11/10/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource,UITableViewDelegate//, UISearchResultsUpdating
{
    
    var tableData : [String] = []
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    var plistAccess = PlistAccess()
    lazy var fHandler = FileHandler();
    var appRootPath: String = ""
    lazy var localizer = Localizer()
    @IBOutlet weak var tableView: UITableView!
    var searchItems : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        appRootPath = paths.firstObject as! String
        
        //tableData = fHandler.getAllFiles("\(appRootPath)/\(BaseData.rootPath)")
        
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
          //  controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        self.tableView.reloadData()
        //  var key : String = "Telugu"
        //var val: String = plistAccess.getPlistValue(key,language: "te")
        // println(val)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.resultSearchController.active) {
            return self.filteredTableData.count
        }
        else {
            return self.tableData.count
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var selectedCellValue = self.filteredTableData[indexPath.row]
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        var appRootPath:String = paths.firstObject as! String
        
        if selectedCellValue.rangeOfString(".pdf") != nil || selectedCellValue.rangeOfString(".docx") != nil{
            var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FileViewController") as! FileViewController
            var centerNavController = UINavigationController(rootViewController: centerViewController)
            var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer?.centerViewController = centerNavController
            var fileInfo = FileInfo()
            fileInfo.name = selectedCellValue
            var filePath: String = "\(appRootPath)/\(BaseData.rootPath)/\(selectedCellValue)"
            fileInfo.parentPath = filePath.stringByDeletingLastPathComponent
            fileInfo.fullPath=filePath
            centerViewController.file = fileInfo
            centerViewController.title=selectedCellValue.lastPathComponent
        }
        else
        {
            var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            var centerNavController = UINavigationController(rootViewController: centerViewController)
            var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer?.centerViewController = centerNavController
            centerViewController.folderPath = "\(appRootPath)/\(BaseData.rootPath)/\(selectedCellValue)"
            
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! CustomTableViewCell
        
        // 3
        if (self.resultSearchController.active) {
            
            var cellValue : String = filteredTableData[indexPath.row]
            let fullNameArr = cellValue.componentsSeparatedByString("/")
            var PathNative : String = ""
            for pathItem in fullNameArr
            {
                let nativeName = localizer.getLocalizedString(pathItem)
                if PathNative == ""
                {
                    PathNative += "\(nativeName)"
                }
                else
                {
                    PathNative += "/\(nativeName)"
                }
                
            }
            cell.textLabel?.text = PathNative
            
            return cell
        }
        else {
            
            var cellValue : String = tableData[indexPath.row]
            let fullNameArr = cellValue.componentsSeparatedByString("/")
            var PathNative : String = ""
            for pathItem in fullNameArr
            {
                let nativeName = localizer.getLocalizedString(pathItem)
                if PathNative == ""
                {
                    PathNative += "\(nativeName)"
                }
                else
                {
                    PathNative += "/\(nativeName)"
                }
                
            }
            cell.textLabel?.text = PathNative
            
            
            return cell
        }
        
    }
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        tableData = fHandler.getAllFiles("\(appRootPath)/\(BaseData.rootPath)")
        filteredTableData.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text)
        let array = (tableData as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredTableData = array as! [String]
        
        self.tableView.reloadData()
    }
    
    
}
