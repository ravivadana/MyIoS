//
//  FileViewController.swift
//  DocPort
//
//  Created by RAVIKUMAR on 25/09/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import UIKit


class FileViewController: BaseViewController {

    @IBOutlet weak var fileViewer: UIWebView!
    var file = FileInfo()
    var fHandler = FileHandler()
     var pdfHander = PdfHandler()
    func saveImage (image: UIImage, path: String ) -> Bool{
        
        var imageHandler = ImageHandler()
        // var profileThumbnail = imageHandler.getImageThumbNail(path) as UIImage
        
        let pngImageData = UIImagePNGRepresentation(image)
        //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = pngImageData.writeToFile(path, atomically: true)
        
        return result
        
    }
    @IBAction func play(sender: AnyObject) {
        
       // println(file.fullPath)
        let myUrl = NSURL(string: "file://\(file.fullPath)")!
        var fileExtension = myUrl.pathExtension
        
        if fileExtension!.lowercaseString == "pdf"
        {
            var readerFolderPath  = ""
            if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
                let dir = dirs[0] //documents directory
                readerFolderPath = fHandler.createFolder("Reader", parentPath: dir)
            }

            var imageFileFullPath : String = ""
            var noOfPagesInPdf = pdfHander.getPdfPagesCount(myUrl)
            for i in 1...noOfPagesInPdf
            {
                var image : UIImage = pdfHander.getImageFromPdf(myUrl,pageNumber: i)

                var fileName = "image\(i).jpeg"
                imageFileFullPath = "\(readerFolderPath)/\(fileName)"
                var imageWrteSuccess = saveImage(image,path: imageFileFullPath)
                println(imageFileFullPath)
            }
        
            var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ReaderViewController") as! ReaderViewController
            var centerNavController = UINavigationController(rootViewController: centerViewController)
            var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer?.centerViewController = centerNavController
            
            centerViewController.filePathToRead = "\(readerFolderPath)/image\(1).png"
        }
        else
        {
            if fileExtension!.lowercaseString == "jpep" ||
                fileExtension!.lowercaseString == "jpg" ||
                fileExtension!.lowercaseString == "gif" ||
                fileExtension!.lowercaseString == "png" ||
                fileExtension!.lowercaseString == "ico"
            {
                var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ReaderViewController") as! ReaderViewController
                var centerNavController = UINavigationController(rootViewController: centerViewController)
                var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.centerContainer?.centerViewController = centerNavController
                
                centerViewController.filePathToRead = file.fullPath
            }
        }
        
        
    }
   
    
    @IBAction func backTapped(sender: UIBarButtonItem) {
        var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        var centerNavController = UINavigationController(rootViewController: centerViewController)
        var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.centerViewController = centerNavController
        centerViewController.title = file.category
        centerViewController.folderPath = file.parentPath
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = file.name
        let url = NSURL(fileURLWithPath: file.fullPath)
        let requestObj = NSURLRequest(URL: url!);
        fileViewer.loadRequest(requestObj);
         self.navigationController!.toolbarHidden=false;
        
        var pdfDoc: CGPDFDocumentRef!
        var numberOfPages: Int = 0
        let pdfURL = url//NSBundle.mainBundle().URLForResource("myPDFDocument", withExtension: "pdf")
        pdfDoc = CGPDFDocumentCreateWithURL(pdfURL)
        numberOfPages = CGPDFDocumentGetNumberOfPages(pdfDoc) as Int
      
        println(numberOfPages)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.title = file.name.lastPathComponent
        
    }
}
