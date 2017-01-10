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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let ss = NFCycleScrollsView()
        self.view.addSubview(ss)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

