//
//  EasyViewController.swift
//  Bulls and Cows
//
//  Created by Mete Hergül on 31.08.2020.
//  Copyright © 2020 CSTECH. All rights reserved.
//

import UIKit
import AudioToolbox

struct EasyPredictionsData
{
    static var PlayerData: [[Int]] = []
    static var ComputerData: [[Int]] = []
}

class EasyViewController: UIViewController {

    @IBOutlet weak var EasyPlayerTable: UIView!
    @IBOutlet weak var EasyComputerTable: UIView!
    @IBOutlet weak var NumberEntryField: OneTimeNumberField!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var bullsCowsCounter: UILabel!
    @IBOutlet weak var storeButton: UIButton!
    @IBOutlet weak var predictButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NumberEntryField.configure()
        self.hideKeyboardWhenTappedAround()
        StatusLabel.text = "Turn: \(turnCount)"
        bullsCowsCounter.text = "Bulls: 0, Cows: 0"
        storeButton.alpha = 1
        predictButton.alpha = 0
        let easyBeginAlert = UIAlertController(title: "Difficulty: Easy", message: "Please enter the number with four unique digits you would like the computer to try to guess.", preferredStyle: .alert)
        easyBeginAlert.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: nil))
        self.present(easyBeginAlert, animated: true)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        NotificationCenter.default.addObserver(self, selector: #selector(restartEasy), name: NSNotification.Name(rawValue: "EasyGameOver"), object: nil)
    }
    
    lazy var turnCount = 1
    var CompConds = ProcessedNumber(numb: 1111, mode: 4)
    lazy var space = CompConds.numgen(mode: 4)
    lazy var tbGuessed = CompConds.randnum(space: space)
    lazy var CStore: Int = 1111
    lazy var CSpace: [Int] = space
    lazy var predicted: [Int] = []
    
    @objc func restartEasy ()
    {
        
        EasyPredictionsData.ComputerData = []
        bullsCowsCounter.text = "Bulls: 0, Cows: 0"
        space = CompConds.numgen(mode: 4)
        tbGuessed = CompConds.randnum(space: space)
        turnCount = 1
        StatusLabel.text = "Turn: \(turnCount)"
        storeButton.alpha = 1
        predictButton.alpha = 0
        CStore = 1111
        CSpace = space
        predicted = []
    }
    
    @IBAction func easyRestartButton(_ sender: UIButton, forEvent event: UIEvent) {
        restartEasy()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EasyGameOver"), object: nil)
    }

    @IBAction func storeButton(_ sender: UIButton, forEvent event: UIEvent) {
        if let m: String = NumberEntryField.text
        {
            if let n: Int = Int(m)
            {
                if CompConds.condcheck(numb: n, mode: 4)
                {
                    CStore = n
                    storeButton.alpha = 0
                    predictButton.alpha = 1
                    let easyStoredAlert = UIAlertController(title: "Number Stored", message: "The number \(CStore) has been stored. Do not worry, the computer will not know!", preferredStyle: .alert)
                    easyStoredAlert.addAction(UIAlertAction(title: "Understood!", style: .default, handler: nil))
                    self.present(easyStoredAlert, animated: true)
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
            }
            else
            {
                StatusLabel.text = "Invalid entry, please try again."
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }
    
    @IBAction func predictButton(_ sender: UIButton, forEvent event: UIEvent) {
        var valid: Bool = false
        var relay: Int = 1111
        var pPlusCount: Int = 0
        var cPlusCount: Int = 0
        var CGuess: Int =  0
        if let ns: String = NumberEntryField.text
        {
            if let number: Int = Int(ns)
            {
                valid = CompConds.condcheck(numb: number, mode: 4) && !predicted.contains(number)
                relay = number
            }
        }
        if valid
        {
            predicted.append(relay)
            NumberEntryField.clear()
            let pmArray = CompConds.plusminus(origin: tbGuessed,number: relay)
            bullsCowsCounter.text = "Bulls: \(pmArray[0]), Cows: \(pmArray[1])"
            EasyPredictionsData.PlayerData.append([relay,pmArray[0],pmArray[1]])
            pPlusCount = pmArray[0]
            print(CSpace)
            CGuess = CSpace.randomElement()!
            let pcArray: [Int] = CompConds.plusminus(origin: CStore, number: CGuess)
            print(pcArray[0],pcArray[1])
            CSpace = CompConds.easyCompare(origin: CGuess, numbers: &CSpace, plus: pcArray[0], minus: pcArray[1])
            cPlusCount = pcArray[0]
            EasyPredictionsData.ComputerData.append([CGuess,pcArray[0],pcArray[1]])
            turnCount += 1
            StatusLabel.text = "Turn: \(turnCount)"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EasyButtonClicked"), object: nil)
        }
        else
        {
            NumberEntryField.clear()
            StatusLabel.text = "Invalid prediction, please try again."
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        if pPlusCount == 4 && cPlusCount != 4
        {
            let easyOverAlert = UIAlertController(title: "Game Over", message: "You beat the computer in \(turnCount) turns. Congratulations!", preferredStyle: .alert)
            easyOverAlert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { action in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EasyGameOver"), object: nil)
            }))
            self.present(easyOverAlert, animated: true)
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        else if pPlusCount != 4 && cPlusCount == 4
        {
            let easyOverAlert = UIAlertController(title: "Game Over", message: "You lost to the computer in \(turnCount) turns. Maybe next time!", preferredStyle: .alert)
            easyOverAlert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { action in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EasyGameOver"), object: nil)
            }))
            self.present(easyOverAlert, animated: true)
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        if pPlusCount == 4 && cPlusCount == 4
        {
            let easyOverAlert = UIAlertController(title: "Game Over", message: "The computer and you were drawn in \(turnCount) turns. So close!", preferredStyle: .alert)
            easyOverAlert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { action in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EasyGameOver"), object: nil)
            }))
            self.present(easyOverAlert, animated: true)
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
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
