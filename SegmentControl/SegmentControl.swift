//
//  SegmentView.swift
//  SegmentControl
//
//  Created by Shripada Hebbar on 31/10/15.
//
//  Copyright © 2015 Shripada Hebbar. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

import Foundation
import UIKit

//Segment view allows an assortment of button objects to bring an effect of
//the standard UI Kit segmented control. Note that this is not an in place
//replacement to that of standard control. Instead, visually it provides similar
//functionality and much more customization with respect to the appearance.

@IBDesignable
class SegmentControl : UIControl {

  var segments : [UIButton] = []

  //MARK: Configurable properties
  //Border encompassing the segment view
  @IBInspectable var borderWidth: CGFloat = 2 {
    didSet {
      layer.borderWidth = borderWidth
      updateButtonStatus()
    }
  }

  //Border color
  @IBInspectable
  var borderColor: UIColor? = UIColor.redColor(){
    didSet {
      layer.borderColor = borderColor?.CGColor
    }
  }

  //Number of segments in the segment view
  @IBInspectable var segmentCount : Int = 1{
    didSet {

      //Remove all currently added segment buttons
      for button in segments {
        button.removeFromSuperview()
      }
      segments.removeAll()

      for index in 0..<segmentCount {
        let button = buttonForIndex(index)
        addSubview(button)
        segments.append(button)
      }

      updateButtonStatus()
    }
  }

  //The color of the selected segment
  @IBInspectable var segmentSelectedColor : UIColor = UIColor.redColor() {
    didSet {
      updateButtonStatus()
    }
  }

  //Color of the segment when the segment is deselected
  @IBInspectable var normalSegmentColor : UIColor = UIColor.whiteColor() {
    didSet {
      updateButtonStatus()
    }
  }

  //Color of text when the segment is selected
  @IBInspectable var selectedTextColor : UIColor = UIColor.whiteColor() {
    didSet {
      updateButtonStatus()
    }
  }

  //Normal text color
  @IBInspectable var normalTextColor : UIColor = UIColor.blackColor() {
    didSet {
      updateButtonStatus()
    }
  }

  //Highlight Text color when user is trying to select
  @IBInspectable var highlightTextColor : UIColor = UIColor.grayColor() {
    didSet {
      updateButtonStatus()
    }
  }

  //Index of currently selected index.
  @IBInspectable var selectedIndex : Int = 0 {
    didSet {
      updateButtonStatus()
    }
  }

  //This is a trick used to enable setting the title of independent segments in one go
  //from within interface builder. Suppose you have 3 segments and their titles are
  //'One', 'Two', 'Three', then you will need to supply "One|Two|Three" as the concatenated text
  @IBInspectable var concatenatedTitle: String = "Segment0" {
    didSet{
      setIndividualTitlesFromConcatenatedTitle()
    }
  }

  //Title font
  var titleFont:UIFont = UIFont(name: "helvetica", size: 12)! {
    didSet{
      updateButtonStatus()
    }
  }

  //MARK: Helper methods

  func setIndividualTitlesFromConcatenatedTitle() {

    let individualTitles = concatenatedTitle.componentsSeparatedByString("|")
    var index = 0
    for button in segments {
      if button.tag < individualTitles.count {
         button.setTitle(individualTitles[index++], forState: UIControlState.Normal)
        button.titleLabel?.font = titleFont
      }
    }
  }

  func buttonForIndex(index: Int) -> UIButton {

    let button =  UIButton(type:UIButtonType.Custom)

    button.setTitle("Segment\(index)", forState: UIControlState.Normal)
    button.setTitleColor(highlightTextColor, forState: UIControlState.Highlighted)
    button.tag = index

    //Set button frame
    button.frame = segmentFrameForIndex(index)

    button.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)

    return button

  }

  func segmentFrameForIndex(index : Int) -> CGRect {
    let width = (frame.width - borderWidth * 2 ) / CGFloat(segmentCount)
    let height = frame.height - borderWidth * 2
    let x = borderWidth + CGFloat(index) * width
    let y = borderWidth

    return CGRect(x: x, y: y, width: width, height: height)

  }

  func updateButtonStatus() {
    for button in segments {
      if(selectedIndex == button.tag) {
        button.backgroundColor = segmentSelectedColor
        button.setTitleColor(selectedTextColor, forState: UIControlState.Normal)
      }else {
        button.backgroundColor = normalSegmentColor
        button.setTitleColor(normalTextColor, forState: UIControlState.Normal)
      }

      button.setTitleColor(highlightTextColor, forState: UIControlState.Highlighted)

      //Set frames as well
      button.frame = segmentFrameForIndex(button.tag)
    }
  }

  func buttonTapped(button:UIButton) {
    selectedIndex = button.tag
      //Fire target action
    sendActionsForControlEvents(allControlEvents())
   }

  override func layoutSubviews() {

    super.layoutSubviews()

    var index = 0
    for button in segments {
      button.frame = segmentFrameForIndex(index++)
    }
  }

  
}