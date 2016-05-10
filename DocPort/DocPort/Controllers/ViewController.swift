//
//  ViewController.swift
//  DocPort
//
//  Created by RAVIKUMAR on 24/09/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import UIKit
import Photos

class ViewController: BaseViewController, UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {

    var albumFound : Bool = false
    var assetCollection: PHAssetCollection = PHAssetCollection()
    var photosAsset: PHFetchResult!
    var assetThumbnailSize:CGSize!
    var picker = UIPickerView()
    var pickerData  = NSArray()
    var profilePic = UIImageView()
    
    @IBOutlet var noPhotosLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
   lazy var fHandler = FileHandler();
   lazy var imageHandelr = ImageHandler()
   var filesInFolder : [FileInfo] = []
    var folderPath:String = ""
    var appRootPath: String = ""
    var addTapped:Bool = false
    var localizer = Localizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        var files:[FileInfo] = []
        var documentsDir: String
       
        filesInFolder = fHandler.getFilesFromDocumentsFolder(folderPath)
        if folderPath == ""
        {
            let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
            var appRootPath:String = paths.firstObject as! String
            var folderPathDefault : String = "\(appRootPath)/\(BaseData.rootPath)"
            filesInFolder = fHandler.getFilesFromDocumentsFolder(folderPathDefault)
            
            if filesInFolder.count > 0
            {
                for folderItem in filesInFolder
                {
                    if folderItem.name.rangeOfString(".") == nil
                    {
                       
                        for fi in filesInFolder
                        {
                            if fi.name.rangeOfString(".") == nil
                            {
                                folderPathDefault = "\(folderPathDefault)/\(fi.name)"
                                filesInFolder = fHandler.getFilesFromDocumentsFolder(folderPathDefault)
                                for fii in filesInFolder
                                {
                                    if fii.name.rangeOfString(".") == nil
                                    {
                                        folderPath = "\(folderPathDefault)/\(fii.name)"
                                        println(folderPath)
                                        filesInFolder = fHandler.getFilesFromDocumentsFolder(folderPath)
                                        tableView.reloadData()
                                        break;
                                    }
                                }
                                break;
                            }
                        }
                        break
                    }
                }
            }
        }
        var backButton = UIButton()
        self.view.addSubview(backButton)
    }
    func goBackToParentFolder()
    {
        
        var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        var centerNavController = UINavigationController(rootViewController: centerViewController)
        var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.centerViewController = centerNavController
        centerViewController.folderPath = folderPath.stringByDeletingLastPathComponent
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.title = localizer.getLocalizedString(folderPath.lastPathComponent)
        
        
        
        
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filesInFolder.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! CustomTableViewCell
        var cellValue: String = filesInFolder[indexPath.row].name
        if cellValue.rangeOfString("profile_pic") == nil
        {
            var image : UIImage = UIImage(named: "folder")!
            if cellValue.rangeOfString(".pdf") != nil {
                var fileFullPath: String = "\(folderPath)/\(cellValue)"
                var filePathUrl = NSURL()
                filePathUrl = NSURL(fileURLWithPath: fileFullPath)!
                image = imageHandelr.getPdfThumbnail(filePathUrl, pageNumber: 1)
                
                
                cell.imageView!.frame =  CGRectMake(0, 0, 130, 100)
                cell.imageView!.backgroundColor = UIColor.grayColor()
                cell.imageView!.layer.cornerRadius = 8.0
                cell.imageView!.clipsToBounds = true
                cell.imageView?.image = image
            }
            else if cellValue.rangeOfString(".docx") != nil || cellValue.rangeOfString(".doc") != nil
            {
                image  = UIImage(named: "doc")!
                cell.imageView!.frame =  CGRectMake(0, 0, 150, 100)
                cell.imageView!.backgroundColor = UIColor.grayColor()
                cell.imageView!.layer.cornerRadius = 8.0
                cell.imageView!.clipsToBounds = true
                cell.imageView?.image = image
            }
            else if cellValue.rangeOfString(".jpg") != nil || cellValue.rangeOfString(".jpeg") != nil ||
                cellValue.rangeOfString(".png") != nil ||
                cellValue.rangeOfString(".gif") != nil ||
                cellValue.rangeOfString(".tif") != nil ||
                cellValue.rangeOfString(".ico") != nil
            {
                var fileFullPath: String = "\(folderPath)/\(cellValue)"
                //image  = UIImage(named: "image")!
                image = imageHandelr.getImageThumbNail(fileFullPath)
                
                //cell.imageView!.frame =  CGRectMake(0, 0, 80, 100)
                cell.imageView!.backgroundColor = UIColor.grayColor()
                cell.imageView!.layer.cornerRadius = 8.0
                cell.imageView!.clipsToBounds = true
                cell.imageView?.image = image
            }
            else
            {
                cell.imageView?.image = image
            }
            
            
            if localizer.getLocalizedString(cellValue) != ""
            {
                cell.textLabel?.text = localizer.getLocalizedString(cellValue)
            }
            else
            {
                cell.textLabel?.text = cellValue
            }
            
            
            
            let buttonMore : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            buttonMore.frame = CGRectMake(120, 60, 25, 24)
            let cellMoreHeight: CGFloat = 44.0
            buttonMore.center = CGPoint(x: view.bounds.width - 20, y: cellMoreHeight / 2.0)
            
            buttonMore.layer.cornerRadius = 12
            var imageMore  = UIImage(named: "more")!
            buttonMore.setBackgroundImage(imageMore, forState: UIControlState.Normal)
            
            buttonMore.tag = indexPath.row
            cell.textLabel?.text = localizer.getLocalizedString(cellValue)
            buttonMore.addTarget(self, action: "buttonMoreClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            buttonMore.tag = indexPath.row
            cell.addSubview(buttonMore)

        }
        
        return cell
    }
    var selectedRowFullPath : String = ""
    func buttonMoreClicked(sender:UIButton)
    {
        addTapped=false
        var selectRowIndex : Int = sender.tag as Int
        selectedRowFullPath = self.filesInFolder[selectRowIndex].fullPath
        println(selectedRowFullPath)
        
        
        var Back = localizer.getLocalizedString("Back")
        var Rename = localizer.getLocalizedString("Rename")
        var MoveToPlayGround = localizer.getLocalizedString("Move to Play Ground")
        var Delete = localizer.getLocalizedString("Delete")
        var Export = localizer.getLocalizedString("Export")
        var Cancel = localizer.getLocalizedString("Cancel")
        var ChooseOption = localizer.getLocalizedString("Choose Option")
        
        if folderPath.stringByDeletingLastPathComponent.stringByDeletingLastPathComponent.rangeOfString("AppData") != nil
        {
            let actionSheet = UIActionSheet(title: ChooseOption, delegate: self, cancelButtonTitle: Cancel, destructiveButtonTitle: nil, otherButtonTitles: Back,Rename,MoveToPlayGround,Delete,Export)
            actionSheet.showInView(self.view)
        }
        else
        {
            let actionSheet = UIActionSheet(title: ChooseOption, delegate: self, cancelButtonTitle: Cancel, destructiveButtonTitle: nil, otherButtonTitles: Rename,MoveToPlayGround,Delete,Export)
            actionSheet.showInView(self.view)

        }
     
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var selectedCellValue = filesInFolder[indexPath.row].name
       
        
        
        if selectedCellValue.rangeOfString(".pdf") != nil ||
            selectedCellValue.rangeOfString(".docx") != nil ||
            selectedCellValue.rangeOfString(".jpg")  != nil ||
            selectedCellValue.rangeOfString(".png") != nil ||
            selectedCellValue.rangeOfString(".gif") != nil
        {
            var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FileViewController") as! FileViewController
            var centerNavController = UINavigationController(rootViewController: centerViewController)
            var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer?.centerViewController = centerNavController
            //appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            var fileInfo = FileInfo()
            fileInfo.name = selectedCellValue
            
            fileInfo.category = folderPath
            var filePath: String = fHandler.getFileFullPath(folderPath, fileName: selectedCellValue)
            
            fileInfo.fullPath=filePath
            fileInfo.parentPath = folderPath
            
            centerViewController.file = fileInfo
            
            centerViewController.title=selectedCellValue
        }
        else
        {
            var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            var centerNavController = UINavigationController(rootViewController: centerViewController)
            var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer?.centerViewController = centerNavController
            centerViewController.title="\(folderPath)/\(selectedCellValue)"
            centerViewController.folderPath = "\(folderPath)/\(selectedCellValue)"
            
        }
        
         //ActivePathStack.append(selectedCellValue)
       // println(ActivePathStack)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func leftSideBarButtonTapped(sender: UIBarButtonItem) {
        var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    @IBAction func rightSideBarButtonTapped(sender: UIBarButtonItem) {
        var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
    }

    
    @IBAction func addTapped(sender: UIBarButtonItem) {
        
        var AddFolder = localizer.getLocalizedString("Add Folder")
        var AddFile = localizer.getLocalizedString("Add File")
        var AddFileFromLibrary = localizer.getLocalizedString("Add File From Library")
        var AddTextFile = localizer.getLocalizedString("Add Text File")
        var Cancel = localizer.getLocalizedString("Cancel")
        var ChooseOption=localizer.getLocalizedString("Choose Option")
        
        addTapped=true
        let actionSheet = UIActionSheet(title: ChooseOption, delegate: self, cancelButtonTitle: Cancel, destructiveButtonTitle: nil, otherButtonTitles: AddFolder, AddTextFile,AddFile,AddFileFromLibrary)
        
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
                createSubCategory()
            case 2:
                println("Add Text File")
            case 3:
                addFile()
            case 4:
                addFileFromLibrary()
            default:
                println("Other Selected")
                //Some code here..
                
            }
        }
        else
        {
            println(buttonIndex)
            let fullNameArr = folderPath.componentsSeparatedByString("/")
            if fullNameArr.count > 1
            {
                switch (buttonIndex){
                    case 0:
                        println("Cancel")
                    case 1:
                        goBackToParentFolder()
                        println("Back")
                    case 2:
                        println("Rename")
                    case 3:
                        
                        moveToPlayGround(selectedRowFullPath)
                        println("MoveToPlayGround")
                    case 4:
                        println("Delete")
                        deleteFileOrFolder(selectedRowFullPath)
                    case 5:
                        println("Export")
                    default:
                        println("Other Selected")
                    //Some code here..
                }
            }
            else
            {
                switch (buttonIndex){
                case 0:
                    println("Cancel")
                case 1:
                    println("Rename")
                case 2:
                    println("Move")
                case 3:
                    println("Delete")
                    deleteFileOrFolder(selectedRowFullPath)
                case 4:
                    println("Export")
                default:
                    println("Other Selected")
                    //Some code here..
                }
            }
        }
        
    }
    func moveToPlayGround(folderPath:String)
    {
        var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var rootViewController = appDelegate.window?.rootViewController
        var mainStoryBoard : UIStoryboard = UIStoryboard(name: "PlayGround", bundle: nil)
        var centerViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("PlayGroundViewController") as! PlayGroundViewController
        var setupLeftViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("PlayGroundViewController") as! PlayGroundViewController
        var setupRightViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("PlayGroundViewController") as! PlayGroundViewController
        
        var setupLeftSideNav = UINavigationController(rootViewController: setupLeftViewController)
        var centerNav = UINavigationController(rootViewController: centerViewController)
        var setupRightSideNav = UINavigationController(rootViewController: setupRightViewController)
        var centerContainer :MMDrawerController?
        
        centerContainer = MMDrawerController(centerViewController: centerNav, leftDrawerViewController: nil, rightDrawerViewController: nil)
        
        centerContainer?.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
        centerContainer?.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView
        centerViewController.imagesSource = folderPath.stringByReplacingOccurrencesOfString("file://", withString: "")

        
        
        appDelegate.window?.rootViewController = centerContainer
        appDelegate.window?.makeKeyAndVisible()
    }
    func deleteFileOrFolder(path:String)
    {
        var folderOrFileToDelete : String = self.selectedRowFullPath.lastPathComponent
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        var appRootPath:String = paths.firstObject as! String
        
        
        var fileOrFolderPath : String = "\(folderPath)/\(folderOrFileToDelete)"
        var filesOrFoldersInFolder: [FileInfo] = fHandler.getFilesFromDocumentsFolder(fileOrFolderPath)
        var fileCount : Int = 0
        var folderCount : Int = 0
        for file in filesOrFoldersInFolder
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
        folderOrFileToDelete = localizer.getLocalizedString(folderOrFileToDelete)
        let fullNameArr = folderPath.componentsSeparatedByString("/")
        var defaultCategoryNameNative : String = ""
        for naviveName in  fullNameArr
        {
            defaultCategoryNameNative =  defaultCategoryNameNative + "/" + localizer.getLocalizedString(naviveName)
        }
        
        var Folders = localizer.getLocalizedString("Folders")
        var Files = localizer.getLocalizedString("Files")
        var And =  localizer.getLocalizedString("And")
        var Folder = localizer.getLocalizedString("Folder")
        var contains : String = "\n(\(folderCount)) \(Folders) and (\(fileCount)) \(Files)"
        
        var deleteConfirmMessage : String
        if folderOrFileToDelete.rangeOfString(".pdf") != nil
        {
            deleteConfirmMessage = "\(defaultCategoryNameNative)/\(folderOrFileToDelete)"
        }
        else
        {
            deleteConfirmMessage = "\(folderOrFileToDelete) \(Folder) Contains \(contains)"
        }
        var AreYouSureToDelete = localizer.getLocalizedString("Are You Sure To Delete")
        var Ok = localizer.getLocalizedString("Ok")
        var Cancel = localizer.getLocalizedString("Cancel")
        
        var deleteConfirm = UIAlertController(title: "\(AreYouSureToDelete) \(folderOrFileToDelete)", message: deleteConfirmMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        
        
        deleteConfirm.addAction(UIAlertAction(title: Ok, style: .Default, handler: { (action: UIAlertAction!) in
            self.filesInFolder = self.fHandler.getFilesFromDocumentsFolder(fileOrFolderPath)
           
            if self.fHandler.deleteFileOrFolder(fileOrFolderPath)
            {
                fileOrFolderPath=fileOrFolderPath.stringByDeletingLastPathComponent
                self.filesInFolder = self.fHandler.getFilesFromDocumentsFolder(fileOrFolderPath)
                self.tableView.reloadData()
            }
            
        }))
        deleteConfirm.addAction(UIAlertAction(title: Cancel, style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Cancel Logic here")
        }))
        presentViewController(deleteConfirm, animated: true, completion: nil)
      
        

    }
    var tField:UITextField?
    
    func addFile()
    {
        func configurationTextField(textField: UITextField!)
        {
            //println("generating the TextField")
            textField.placeholder = "Enter Source Url"
            tField = textField
        }
        
        var parentCategory:String = folderPath
        func handleCancel(alertView: UIAlertAction!)
        {
            println("Cancelled !!")
        }
        
        var alert = UIAlertController(title: "Enter Url", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        var AreYouSureToDelete = localizer.getLocalizedString("Are You Sure to Delete")
        var Done = localizer.getLocalizedString("Done")
        var Cancel = localizer.getLocalizedString("Cancel")
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: Cancel, style: UIAlertActionStyle.Cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: Done, style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            
           
            var sourceUrl:String = (self.tField!.text)
            var destFilePath : String = "\(parentCategory)/\(sourceUrl.lastPathComponent)"
            println(destFilePath)
            self.fHandler.moveFile(sourceUrl, destinationFilePath: destFilePath)
            self.tableView.reloadData()
            var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            var centerNavController = UINavigationController(rootViewController: centerViewController)
            var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer?.centerViewController = centerNavController
            centerViewController.folderPath = parentCategory
            centerViewController.title = parentCategory
           
            
        }))
        self.presentViewController(alert, animated: true, completion: {
            println("completion block")
        })
    }

    func addFileFromLibrary()
    {
        let picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary)!
        picker.delegate = self
        picker.allowsEditing = false
        self.presentViewController(picker, animated: true, completion: nil)
    }
    var tFieldNative:UITextField?
    func createSubCategory()
    {
        func configurationTextField(textField: UITextField!)
        {
            //println("generating the TextField")
            textField.placeholder = "Enter an item"
            tField = textField
        }
        
        func configurationNativeTextField(textField: UITextField!)
        {
            textField?.placeholder = "Telugu Name"
            tFieldNative = textField
        }
        
       var parentCategory = self.title
        
        func handleCancel(alertView: UIAlertAction!)
        {
            println("Cancelled !!")
        }
        
        var alert = UIAlertController(title: "Enter Input", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        var Done = localizer.getLocalizedString("Done")
        var Cancel = localizer.getLocalizedString("Cancel")
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        if !localizer.isActiveLanguageEnglish
        {
          alert.addTextFieldWithConfigurationHandler(configurationNativeTextField)
        }
        alert.addAction(UIAlertAction(title: Cancel, style: UIAlertActionStyle.Cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: Done, style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
           
            //println("Item : \(self.tField!.text)")
            var newCategory:String = (self.tField!.text)
            var newCategoryNative : String = ""
            if let temp = (self.tFieldNative?.text)
            {
                newCategoryNative = temp
            }
            self.UpdateNativeCategoryName(newCategoryNative)
            self.fHandler.createFolder(newCategory, parentPath: self.folderPath)
            self.tableView.reloadData()
            var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            var centerNavController = UINavigationController(rootViewController: centerViewController)
            var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer?.centerViewController = centerNavController
            centerViewController.folderPath = self.folderPath
           // centerViewController.title = self.categoryPath
            
            var pListAccess = PlistAccess();
            pListAccess.addItemToPlist(newCategory, val: newCategoryNative, language: "te")

        }))
        self.presentViewController(alert, animated: true, completion: {
            
            println("completion block")
        })
    }
    func UpdateNativeCategoryName(newCategoryNative:String)
    {
        
        var ActiveLanguage : String = (NSUserDefaults.standardUserDefaults().objectForKey("selectedLanguage") as? String)!
        var languageFolderName : String = "\(ActiveLanguage).lproj"
       
        
        if ActiveLanguage != "en"
        {
            if newCategoryNative != NSLocalizedString(newCategoryNative, comment: "")
            {
                
            }
        }
       
    }
    func saveImage (image: UIImage, path: String ) -> Bool{
        
        var imageHandler = ImageHandler()
        // var profileThumbnail = imageHandler.getImageThumbNail(path) as UIImage
        
        //let pngImageData = UIImagePNGRepresentation(image)
        let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = jpgImageData.writeToFile(path, atomically: true)
        
        if  result == true
        {
            var folderPath=path.stringByDeletingLastPathComponent
            self.filesInFolder = self.fHandler.getFilesFromDocumentsFolder(folderPath)
            self.tableView.reloadData()
        }
        return result
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject: AnyObject]) {
        
        if let image: UIImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            
            //Implement if allowing user to edit the selected image
            //let editedImage = info.objectForKey("UIImagePickerControllerEditedImage") as UIImage
            
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0), {
                PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                    let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
                    let assetPlaceholder = createAssetRequest.placeholderForCreatedAsset
                    if let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection, assets: self.photosAsset) {
                        albumChangeRequest.addAssets([assetPlaceholder!])
                    }
                    }, completionHandler: {(success, error)in
                        dispatch_async(dispatch_get_main_queue(), {
                            NSLog("Adding Image to Library -> %@", (success ? "Sucess":"Error!"))
                            picker.dismissViewControllerAnimated(true, completion: nil)
                        })
                })
                
            })
           // profilePic = UI
            //profilePic.frame =  CGRectMake(0,0,50,50)
            //profilePic.image = image
            
            
            let fullPath = folderPath.stringByAppendingPathComponent("image.png")
            
            saveImage(image,path: fullPath)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK - Picker delegate
    
    func pickerView(_pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return pickerData.objectAtIndex(row) as! NSString as String
    }
    
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerData.count
    }

}

