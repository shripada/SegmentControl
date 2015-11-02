//
//  ViewController.swift
//  SegmentControl
//
//  Created by Shripada Hebbar on 31/10/15.
//  Copyright © 2015 Shripada Hebbar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }


  @IBAction func segmentControlStateChanged(sender: SegmentControl) {
    print("Selected segment = \(sender.selectedIndex)")
    
  }
}

