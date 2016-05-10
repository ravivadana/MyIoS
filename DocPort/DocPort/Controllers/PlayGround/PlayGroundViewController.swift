//
//  PlayGroundViewController.swift
//  DocPort
//
//  Created by RAVIKUMAR on 11/11/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import UIKit

class PlayGroundViewController: BaseViewController {

    @IBAction func backTapped(sender: UIBarButtonItem) {
        
        var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var rootViewController = appDelegate.window?.rootViewController
        var mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var centerViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        var leftSideViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LeftSideViewController") as! LeftSideViewController
        var rightSideViewViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("RightSideViewController") as! RightSideViewController
        
        
        var leftSideNav = UINavigationController(rootViewController: leftSideViewController)
        var centerNav = UINavigationController(rootViewController: centerViewController)
        var rightSideNav = UINavigationController(rootViewController: rightSideViewViewController)
        
        appDelegate.centerContainer = MMDrawerController(centerViewController: centerNav, leftDrawerViewController: leftSideNav, rightDrawerViewController: rightSideNav)
        
        
        
        appDelegate.centerContainer?.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
        appDelegate.centerContainer?.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView
        
        appDelegate.window?.rootViewController = appDelegate.centerContainer
        appDelegate.window?.makeKeyAndVisible()
       
    }
    @IBOutlet weak var webView: UIWebView!
    
    var imagesSource : String = ""
    var filesInFolder : [FileInfo] = []
    var fHandler = FileHandler()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var boolToCreateImagesToPdf = false
        filesInFolder = fHandler.getFilesFromDocumentsFolder(imagesSource)
        
        for file in filesInFolder
        {
            if file.name.rangeOfString(".") != nil
            {
                boolToCreateImagesToPdf=true
                break
            }
        }
        if boolToCreateImagesToPdf == true
        {
             createPdf(filesInFolder)
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    func createPdf(filesInFolder:[FileInfo])
    {
       
        var pdfRenderer = PDFRenderer()
        var outputFilePath : String = "\(imagesSource)/output.pdf"
        pdfRenderer.drawPDF(outputFilePath, filesInFolder: filesInFolder)
        
        let url = NSURL(fileURLWithPath: outputFilePath)
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);

       
    }
}
