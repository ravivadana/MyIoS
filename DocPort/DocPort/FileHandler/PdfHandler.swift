//
//  PdfHandler.swift
//  DocPort
//
//  Created by RAVIKUMAR on 04/11/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import Foundation

class PdfHandler
{
    func getPdfPagesCount(url:NSURL) -> Int
    {
        var noOfPages : Int = 0
        var pdf:CGPDFDocumentRef = CGPDFDocumentCreateWithURL(url as CFURLRef);
        noOfPages = CGPDFDocumentGetNumberOfPages(pdf)
        return noOfPages
    }
    func getImageFromPdf(url:NSURL,pageNumber:Int) -> UIImage
    {
       
        var pdf:CGPDFDocumentRef = CGPDFDocumentCreateWithURL(url as CFURLRef);
        
        
        var firstPage = CGPDFDocumentGetPage(pdf, pageNumber)
        
        var width:CGFloat = 300.0;
        
        var pageRect:CGRect = CGPDFPageGetBoxRect(firstPage, kCGPDFMediaBox);
        var pdfScale:CGFloat = width/pageRect.size.width;
        pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale);
        pageRect.origin = CGPointZero;
        
        UIGraphicsBeginImageContext(pageRect.size);
        
        var context:CGContextRef = UIGraphicsGetCurrentContext();
        
        // White BG
        CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
        CGContextFillRect(context,pageRect);
        
        CGContextSaveGState(context);
        
        // ***********
        // Next 3 lines makes the rotations so that the page look in the right direction
        // ***********
        CGContextTranslateCTM(context, 0.0, pageRect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextConcatCTM(context, CGPDFPageGetDrawingTransform(firstPage, kCGPDFMediaBox, pageRect, 0, true));
        
        CGContextDrawPDFPage(context, firstPage);
        CGContextRestoreGState(context);
        
        var thm:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return thm;
    }
}
