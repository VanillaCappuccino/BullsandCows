//
//  EasyViewController.swift
//  Bulls and Cows
//
//  Created by Mete Hergül on 31.08.2020.
//  Copyright © 2020 CSTECH. All rights reserved.
//

import UIKit

class EasyViewController: UIViewController {

    @IBOutlet weak var EasyPlayerTable: UIView!
    @IBOutlet weak var EasyComputerTable: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func easyTablesSwitch(_ sender: UISegmentedControl, forEvent event: UIEvent) {
        if sender.selectedSegmentIndex == 0
        {
            EasyPlayerTable.alpha = 1
            EasyComputerTable.alpha = 0
        }
        else
        {
            EasyComputerTable.alpha = 1
            EasyPlayerTable.alpha = 0
        }
    }
    
    


}
