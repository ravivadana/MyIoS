//
//  PDFRenderer.swift
//  DocPort
//
//  Created by RAVIKUMAR on 11/11/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import Foundation
import CoreText

class PDFRenderer: NSObject {
    func drawPDF(filename: String,filesInFolder:[FileInfo]) {
        
        // Create the PDF context using the default page size of 612 x 792
        UIGraphicsBeginPDFContextToFile(filename, CGRectZero, nil)
        
        
        
        // self.drawLabels()
        for var i=0; i<filesInFolder.count; i++
        {
            // start a new page
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil)
            self.drawLogo(filesInFolder[i].fullPath)
        }
        
        
        let xOrigin = 50
        let yOrigin = 300
        
        let rowHeight   = 50
        let columnWidth = 120
        
        let numberOfRows    = 7
        let numberOfColumns = 4
        
        //        self.drawTableAt(CGPointMake(CGFloat(xOrigin), CGFloat(yOrigin)), withRowHeight: rowHeight, andColumnWidth: columnWidth, andRowcount: numberOfRows, andColumnCount: numberOfColumns)
        //
        //        self.drawTableDataAt(CGPointMake(CGFloat(xOrigin), CGFloat(yOrigin)), withRowHeight: rowHeight, andColumnWidth: columnWidth, andRowCount: numberOfRows, andColumnCount: numberOfColumns)
        
        UIGraphicsEndPDFContext()
        
    }
    
    func drawLogo(imagePath:String) {
        
        let objects  = NSBundle.mainBundle().loadNibNamed("ImageView", owner: nil, options: nil)
        let mainView = objects[0] as! UIView
        
        for view in mainView.subviews {
            
            if view.isKindOfClass(UIImageView) {
              let newPath = imagePath.stringByReplacingOccurrencesOfString("file://", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                var img = UIImage(contentsOfFile: newPath)
                if img != nil{
                    self.drawImage(image: img!, inRect: view.frame)
                }
                
            }
            
        }
        
    }
    func drawImage(image imageToDraw: UIImage, inRect rect: CGRect) {
        
        imageToDraw.drawInRect(rect)
        
    }

}