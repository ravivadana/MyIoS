//
//  UICheckbox.swift
//  DocPort
//
//  Created by RAVIKUMAR on 25/10/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//

import UIKit

class UICheckbox: UIButton {
    let checkecd = UIImage(named: "check") as UIImage?
    let unchecked = UIImage(named: "uncheck") as UIImage?
    var isChecked : Bool = false
        {
            didSet
            {
                if isChecked == true
                {
                    self.setImage(checkecd, forState: .Normal)
                }
                else
                {
                    self.setImage(unchecked, forState: .Normal)
                }
        }
    }
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
    func buttonClicked(sender:UIButton)
    {
        if sender == self{
            if isChecked == true
            {
                isChecked = false
            }
            else
            {
                isChecked = true
            }
        }
    }
}
