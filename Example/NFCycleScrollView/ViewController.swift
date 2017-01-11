//
//  ViewController.swift
//  NFCycleScrollView
//
//  Created by Jiang PengCheng on 01/10/2017.
//  Copyright (c) 2017 Jiang PengCheng. All rights reserved.
//

import UIKit
import NFCycleScrollView

class ViewController: UIViewController {

    @IBOutlet weak var mBanner: NFCycleScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.automaticallyAdjustsScrollViewInsets = false
        self.mBanner.config(views: ["discover_banner1", "discover_banner2", "discover_banner3"], width: UIScreen.main.bounds.size.width, height: 200)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

