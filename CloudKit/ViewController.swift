//
//  ViewController.swift
//  CloudKit
//
//  Created by Shrikar Archak on 10/11/14.
//  Copyright (c) 2014 Shrikar Archak. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
    let cloudKitHelper = CloudKitHelper()


    @IBOutlet weak var inputText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveInCloud(sender: UIButton) {
        cloudKitHelper.saveRecord(self.inputText.text)
        self.inputText.text = nil
    }

}

