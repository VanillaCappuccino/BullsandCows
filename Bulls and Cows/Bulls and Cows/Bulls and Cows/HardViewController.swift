//
//  HardViewController.swift
//  Bulls and Cows
//
//  Created by Mete Hergül on 31.08.2020.
//  Copyright © 2020 CSTECH. All rights reserved.
//

import UIKit

struct HardPredictionsData
{
    static var PlayerData: [[Int]] = []
    static var ComputerData: [[Int]] = []
}

class HardViewController: UIViewController {

    @IBOutlet weak var HardPlayerTable: UIView!
    @IBOutlet weak var HardComputerTable: UIView!
    @IBOutlet weak var HardNumberField: OneTimeNumberField!
    
    lazy var turnCount: Int = 1
    let Computer = ProcessedNumber(numb: 1111, mode: 4)
    lazy var cList = Computer.numgen(mode: 4)
    lazy var tbguessed: Int = Computer.randnum(space: cList)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        HardNumberField.configure()
    }
    
    
    
    
    
    @IBAction func HardTablesSwitch(_ sender: UISegmentedControl, forEvent event: UIEvent) {
        if sender.selectedSegmentIndex == 0
        {
            HardPlayerTable.alpha = 1
            HardComputerTable.alpha = 0
        }
        else
        {
            HardPlayerTable.alpha = 0
            HardComputerTable.alpha = 1
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
