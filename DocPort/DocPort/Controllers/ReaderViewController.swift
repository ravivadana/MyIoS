//
//  ReaderViewController.swift
//  DocPort
//
//  Created by RAVIKUMAR on 18/10/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import UIKit
import AVFoundation

class ReaderViewController: BaseViewController {
    var filePathToRead : String = ""
    var activityIndicator:UIActivityIndicatorView!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func backTapped(sender: UIBarButtonItem) {
        BackTapped()
    }
    func BackTapped()
    {
        var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FileViewController") as! FileViewController
        var centerNavController = UINavigationController(rootViewController: centerViewController)
        var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.centerViewController = centerNavController
        
        var backPath = filePathToRead
        var fileInfo = FileInfo()
        fileInfo.name = filePathToRead.lastPathComponent
        fileInfo.fullPath = filePathToRead
        centerViewController.file = fileInfo
    }
    override func viewDidAppear(animated: Bool) {
       super.viewDidAppear(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        println("\(filePathToRead)")
        if filePathToRead.pathExtension == "jpg" ||
            filePathToRead.pathExtension == "jpeg" ||
            filePathToRead.pathExtension == "gif" ||
            filePathToRead.pathExtension == "png" ||
            filePathToRead.pathExtension == "ico"
        {
             ImageContentReader()
        }
        else if filePathToRead.pathExtension == "pdf"
        {
            PdfContentReader()
        }
        else if filePathToRead.pathExtension == "doc" ||
                filePathToRead.pathExtension == "docx"
        {
            MsDocContentReader()
        }
        else if filePathToRead.pathExtension == "txt"
        {
            TextContentReader()
        }
       
    }
    func TextContentReader()
    {
        
    }
    func MsDocContentReader()
    {
         ImageContentReader()
    }
    func PdfContentReader()
    {
        
    }
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
    }
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }

   func ImageContentReader()
   {

    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    func performImageRecognition(image: UIImage) {
        
        // 1
        let tesseract = G8Tesseract()
        
        // 2
        tesseract.language = "eng"
        
        // 3
        tesseract.engineMode = .TesseractCubeCombined
        
        // 4
        tesseract.pageSegmentationMode = .Auto
        
        // 5
        tesseract.maximumRecognitionTime = 60.0
        
        // 6
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        
        // 7
        textView.text = tesseract.recognizedText
        removeActivityIndicator()
        
        var synth=AVSpeechSynthesizer()
        var myUtterance = AVSpeechUtterance(string: "")
        
        myUtterance = AVSpeechUtterance(string: textView.text)
        myUtterance.rate = 0.001
        synth.speakUtterance(myUtterance)
        
        textView.editable = true
        
        // 8
        // removeActivityIndicator()
        
    }
    
    let image = UIImage(contentsOfFile: filePathToRead )
    if image != nil
    {
        let scaledImage = scaleImage(image!, 640)
        addActivityIndicator()
        performImageRecognition(scaledImage)

    }
    
   }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}
