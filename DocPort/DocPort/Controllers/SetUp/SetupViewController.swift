//
//  SetupViewController.swift
//  DocPort
//
//  Created by RAVIKUMAR on 23/10/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import UIKit
import Photos
class SetupViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    var albumFound : Bool = false
    var assetCollection: PHAssetCollection = PHAssetCollection()
    var photosAsset: PHFetchResult!
    var assetThumbnailSize:CGSize!
    
    @IBOutlet var noPhotosLabel: UILabel!

    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var displayName: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var countries: UIPickerView!
    @IBOutlet weak var education: UICheckbox!
    @IBOutlet weak var profession: UICheckbox!
    @IBOutlet weak var property: UICheckbox!
    var appRootPath : String = ""
     var fHandler : FileHandler?
    var picker = UIPickerView()
    var pickerData  = NSArray()
    var countriesArray: NSMutableArray =  NSMutableArray()
    var actionView: UIView = UIView()
    var window: UIWindow? = nil
    @IBOutlet weak var countryLabel: UITextField!
 
    var profileName : String = ""
  override func viewDidLoad() {
    
    super.viewDidLoad()
        initialize()
    // create tap gesture recognizer
    let tapGesture = UITapGestureRecognizer(target: self, action: "tapProfileGesture:")
    
    // add it to the image view;
    profilePic.addGestureRecognizer(tapGesture)
    // make sure imageView can be interacted with by user
    profilePic.userInteractionEnabled = true
    if  profileName != ""
    {
         initializeData()
    }
   
    
}
    func initializeData()
    {
        var profileFolderPath : String = ""
        profileFolderPath = "\(appRootPath)/\(BaseData.rootPath)/\(profileName)/"
        var profileImage : UIImage
        profileImage = UIImage(contentsOfFile: "\(profileFolderPath)/profile_pic.png")!
        profilePic.image = profileImage
        displayName.text = profileName
        var fInfos = [FileInfo()]
        fInfos=fHandler!.getFilesFromDocumentsFolder(profileFolderPath)
        self.education.isChecked = false
        self.profession.isChecked = false
        self.property.isChecked = false
        
        for finfo in fInfos
        {
            if  finfo.name.uppercaseString == "EDUCATION"
            {
                self.education.isChecked = true
            }
            if  finfo.name.uppercaseString == "PROFESSION"
            {
                self.profession.isChecked = true
            }
            if  finfo.name.uppercaseString == "PROPERTY"
            {
                self.property.isChecked = true
            }
        }
        
        
    }
    func tapProfileGesture(sender:AnyObject)
    {
        let picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary)!
        picker.delegate = self
        picker.allowsEditing = false
        self.presentViewController(picker, animated: true, completion: nil)
    }
override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
}

    func initialize()
    {
        var delegate = UIApplication.sharedApplication()
        var myWindow: UIWindow? = delegate.keyWindow
        var myWindow2: NSArray = delegate.windows
        
        if let myWindow: UIWindow = UIApplication.sharedApplication().keyWindow
        {
            window = myWindow
        }
        else
        {
            window = myWindow2[0] as? UIWindow
        }
        
        picker.backgroundColor = UIColor.whiteColor()
        actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height.0, UIScreen.mainScreen().bounds.size.width, 260.0)
        countriesArray.insertObject("", atIndex: 0)
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        appRootPath = paths.firstObject as! String
        var rootPathStrings :[String] = appRootPath.componentsSeparatedByString("/")
        var userName : String = rootPathStrings[2]
        userName.replaceRange(userName.startIndex...userName.startIndex, with: String(userName[userName.startIndex]).capitalizedString)
        
        
        fHandler = FileHandler()
        var profiles = fHandler!.getFilesFromDocumentsFolder("\(appRootPath)/\(BaseData.rootPath)")
        if profiles.count == 0
        {
            displayName.text = userName
        }
        
        var lb = UIBarButtonItem(title: "Home", style: .Plain, target: self, action: "SkipToLanchApp:")
        self.navigationItem.leftBarButtonItem = lb
        
        var rb = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "SetupContinue:")
        self.navigationItem.rightBarButtonItem = rb
        
        
        for code in NSLocale.ISOCountryCodes() as! [String] {
            let id = NSLocale.localeIdentifierFromComponents([NSLocaleCountryCode: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayNameForKey(NSLocaleIdentifier, value: id) ?? "Country not found for code: \(code)"
            countriesArray.addObject(name)
        }
    
    }
    func saveImage (image: UIImage, path: String ) -> Bool{
    
        var imageHandler = ImageHandler()
       // var profileThumbnail = imageHandler.getImageThumbNail(path) as UIImage
        
    let pngImageData = UIImagePNGRepresentation(image)
    //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
    let result = pngImageData.writeToFile(path, atomically: true)
    
    return result
    
    }
func SetupContinue(sender:AnyObject)
{
    
  println("Continue Setup...")
    
    var doYouWantAddAnotherProfile = "Do You Want To Add Another Profile"
    var Ok = "Ok"
    var Skip = "Skip"
    
    var createNewConfirm = UIAlertController(title: "\(doYouWantAddAnotherProfile)", message: "", preferredStyle: UIAlertControllerStyle.Alert)
    createNewConfirm.addAction(UIAlertAction(title: Ok, style: .Default, handler: { (action: UIAlertAction!) in
        var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SetupViewController") as! SetupViewController
        var centerNavController = UINavigationController(rootViewController: centerViewController)
        var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.centerViewController = centerNavController
        self.CreateProfile()
        self.profilePic = UIImageView()
        var defaultPic = UIImage(named: "default_profile_pic")
        self.profilePic?.image = defaultPic!
        self.displayName.text = ""
        self.education.isChecked = false
        self.profession.isChecked = false
        self.property.isChecked = false
    
    }))
    createNewConfirm.addAction(UIAlertAction(title: Skip, style: .Default, handler: { (action: UIAlertAction!) in
        println("Handle Cancel Logic here")
        self.SkipToLanchApp(self)
    }))
    
    presentViewController(createNewConfirm, animated: true, completion: nil)
}
    func SkipToLanchApp(sender:AnyObject)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        var isInitialSetupCompleted = defaults.objectForKey("isInitialSetupCompleted") as? Bool
        isInitialSetupCompleted  = true
        defaults.setObject(isInitialSetupCompleted, forKey: "isInitialSetupCompleted")
        defaults.synchronize()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.InitializeApp()
    }
    func CreateProfile()
    {
        var profileName : String = ""
        var profileMobile : String = ""
        var profileEmail : String = ""
        var profileCity : String = ""
        var profileCountry : String = ""
        profileName = displayName.text
        profileMobile = mobile.text
        profileEmail = email.text
        profileCity = city.text
        //profileCountry = country.text as String
        //Create User Profile Folder
        fHandler = FileHandler()
        fHandler!.createFolder(profileName, parentPath: "\(appRootPath)/\(BaseData.rootPath)")
        
        
        //Create the Categories for the above Created Profile
        
        if education.isChecked             {
            var usersPath = "\(appRootPath)/\(BaseData.rootPath)/\(profileName)"
            fHandler!.createFolder("\(BaseData.defaultCategories[0])", parentPath:usersPath )
        }
        if profession.isChecked             {
            var usersPath = "\(appRootPath)/\(BaseData.rootPath)/\(profileName)"
            fHandler!.createFolder("\(BaseData.defaultCategories[1])", parentPath:usersPath )
        }
        if property.isChecked             {
            var usersPath = "\(appRootPath)/\(BaseData.rootPath)/\(profileName)"
            fHandler!.createFolder("\(BaseData.defaultCategories[2])", parentPath:usersPath )
        }
        println("\(education.isChecked) ")
        
        
        var profileFolderPath = "\(appRootPath)/\(BaseData.rootPath)/\(profileName)"
        let fullPath = profileFolderPath.stringByAppendingPathComponent("profile_pic.png")
      
        saveImage(profilePic.image!,path: fullPath)
    }
override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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


@IBAction func countrySelect(sender: AnyObject) {
    let kSCREEN_WIDTH  =    UIScreen.mainScreen().bounds.size.width
    
    picker.frame = CGRectMake(0.0, 44.0,kSCREEN_WIDTH, 216.0)
    picker.dataSource = self
    picker.delegate = self
    picker.showsSelectionIndicator = true;
    picker.backgroundColor = UIColor.whiteColor()
    
    var pickerDateToolbar = UIToolbar(frame: CGRectMake(0, 0, kSCREEN_WIDTH, 44))
    pickerDateToolbar.barStyle = UIBarStyle.Black
    pickerDateToolbar.barTintColor = UIColor.blackColor()
    pickerDateToolbar.translucent = true
    
    var barItems = NSMutableArray()
    
    var labelCancel = UILabel()
    labelCancel.text = "Cancel"
    var titleCancel = UIBarButtonItem(title: labelCancel.text, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelPickerSelectionButtonClicked:"))
    barItems.addObject(titleCancel)
    
    var flexSpace: UIBarButtonItem
    flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
    barItems.addObject(flexSpace)
    
    pickerData = countriesArray
    picker.selectRow(1, inComponent: 0, animated: false)
    
    let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("countryDoneClicked:"))
    barItems.addObject(doneBtn)
    
    pickerDateToolbar.setItems(barItems as [AnyObject], animated: true)
    
    actionView.addSubview(pickerDateToolbar)
    actionView.addSubview(picker)
    
    if ((window) != nil) {
        window!.addSubview(actionView)
    }
    else
    {
        self.view.addSubview(actionView)
    }
    
    UIView.animateWithDuration(0.2, animations: {
        
        self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 260.0, UIScreen.mainScreen().bounds.size.width, 260.0)
        
    })

    }


func cancelPickerSelectionButtonClicked(sender: UIBarButtonItem) {
    
    UIView.animateWithDuration(0.2, animations: {
        
        self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 260.0)
        
        }, completion: { _ in
            for obj: AnyObject in self.actionView.subviews {
                if let view = obj as? UIView
                {
                    view.removeFromSuperview()
                }
            }
    })
}

func countryDoneClicked(sender: UIBarButtonItem) {
    
    
    var myRow = picker.selectedRowInComponent(0)
    countryLabel?.text = pickerData.objectAtIndex(myRow) as! NSString as String
    
    if countryLabel?.text == "" {
        countryLabel?.text = "No country"
    }
    
    UIView.animateWithDuration(0.2, animations: {
        
        self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 260.0)
        
        }, completion: { _ in
            for obj: AnyObject in self.actionView.subviews {
                if let view = obj as? UIView
                {
                    view.removeFromSuperview()
                }
            }
    })
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
            profilePic.frame =  CGRectMake(0,0,50,50)
            profilePic.image = image
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    
}
