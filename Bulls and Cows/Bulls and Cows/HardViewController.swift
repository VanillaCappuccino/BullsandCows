//
//  HardViewController.swift
//  Bulls and Cows
//
//  Created by Mete Hergül on 31.08.2020.
//  Copyright © 2020 CSTECH. All rights reserved.
//

import UIKit
import AudioToolbox

struct HardPredictionsData
{
    static var PlayerData: [[Int]] = []
    static var ComputerData: [[Int]] = []
}

class HardViewController: UIViewController {

    @IBOutlet weak var HardPlayerTable: UIView!
    @IBOutlet weak var HardComputerTable: UIView!
    @IBOutlet weak var HardNumberField: OneTimeNumberField!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var bullsCowsCounter: UILabel!
    @IBOutlet weak var StoreButton: UIButton!
    @IBOutlet weak var PredictButton: UIButton!
    @IBOutlet weak var predictionLabel: UILabel!
    
    override func viewDidLoad() {
        predictionLabel.text = "Number To Be Stored:"
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        HardNumberField.configure()
        StoreButton.alpha = 1
        PredictButton.alpha = 0
        StatusLabel.text = "Turn: \(turnCount)"
        bullsCowsCounter.text = "Bulls: 0, Cows: 0"
        let hardBeginAlert = UIAlertController(title: "Difficulty: Hard", message: "Please enter the number with four unique digits you would like the computer to try to guess.", preferredStyle: .alert)
        hardBeginAlert.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: nil))
        self.present(hardBeginAlert, animated: true)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        NotificationCenter.default.addObserver(self, selector: #selector(restartHard), name: NSNotification.Name(rawValue: "HardGameOver"), object: nil)
    }
    
    lazy var turnCount = 1
    var CompConds = ProcessedNumber(numb: 1111, mode: 4)
    lazy var space = CompConds.numgen(mode: 4)
    lazy var tbGuessed = CompConds.randnum(space: space)
    lazy var CStore: Int = 1111
    lazy var CSpace: [Int] = space
    lazy var predicted: [Int] = []
    
    @objc func restartHard ()
    {
        predictionLabel.text = "Number To Be Stored:"
        bullsCowsCounter.text = "Bulls: 0, Cows: 0"
        space = CompConds.numgen(mode: 4)
        tbGuessed = CompConds.randnum(space: space)
        turnCount = 1
        StatusLabel.text = "Turn: \(turnCount)"
        StoreButton.alpha = 1
        PredictButton.alpha = 0
        CStore = 1111
        CSpace = space
        predicted = []
    }
    
    @IBAction func restartButton(_ sender: UIButton, forEvent event: UIEvent) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HardGameOver"), object: nil)
        let hardRestart = UIAlertController(title: "Restart: Hard", message: "The game has been restarted.", preferredStyle: .alert)
        hardRestart.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: nil))
        self.present(hardRestart, animated: true)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    
    @IBAction func storeButton(_ sender: UIButton, forEvent event: UIEvent) {
        if let m: String = HardNumberField.text
        {
            if let n: Int = Int(m)
            {
                if CompConds.condcheck(numb: n, mode: 4)
                {
                    CStore = n
                    StoreButton.alpha = 0
                    PredictButton.alpha = 1
                    let hardStoredAlert = UIAlertController(title: "Number Stored", message: "The number \(CStore) has been stored. Do not worry, the computer will not know!", preferredStyle: .alert)
                    hardStoredAlert.addAction(UIAlertAction(title: "Understood!", style: .default, handler: nil))
                    self.present(hardStoredAlert, animated: true)
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    HardNumberField.clear()
                    predictionLabel.text = "Enter Your Prediction:"
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
        if let ns: String = HardNumberField.text
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
            HardNumberField.clear()
            let pmArray = CompConds.plusminus(origin: tbGuessed,number: relay)
            bullsCowsCounter.text = "Bulls: \(pmArray[0]), Cows: \(pmArray[1])"
            HardPredictionsData.PlayerData.append([relay,pmArray[0],pmArray[1]])
            pPlusCount = pmArray[0]
            print(CSpace)
            CGuess = CSpace.randomElement()!
            let pcArray: [Int] = CompConds.plusminus(origin: CStore, number: CGuess)
            print(pcArray[0],pcArray[1])
            CSpace = CompConds.compare(origin: CGuess, numbers: &CSpace, plus: pcArray[0], minus: pcArray[1])
            cPlusCount = pcArray[0]
            HardPredictionsData.ComputerData.append([CGuess,pcArray[0],pcArray[1]])
            turnCount += 1
            StatusLabel.text = "Turn: \(turnCount)"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HardButtonClicked"), object: nil)
        }
        else
        {
            HardNumberField.clear()
            StatusLabel.text = "Invalid prediction, please try again."
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        if pPlusCount == 4 && cPlusCount != 4
        {
            let easyOverAlert = UIAlertController(title: "Game Over", message: "You beat the computer in \(turnCount) turns. Congratulations!", preferredStyle: .alert)
            easyOverAlert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { action in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HardGameOver"), object: nil)
            }))
            self.present(easyOverAlert, animated: true)
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        else if pPlusCount != 4 && cPlusCount == 4
        {
            let easyOverAlert = UIAlertController(title: "Game Over", message: "You lost to the computer in \(turnCount) turns. Maybe next time!", preferredStyle: .alert)
            easyOverAlert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { action in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HardGameOver"), object: nil)
            }))
            self.present(easyOverAlert, animated: true)
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        if pPlusCount == 4 && cPlusCount == 4
        {
            let easyOverAlert = UIAlertController(title: "Game Over", message: "The computer and you were drawn in \(turnCount) turns. So close!", preferredStyle: .alert)
            easyOverAlert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { action in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HardGameOver"), object: nil)
            }))
            self.present(easyOverAlert, animated: true)
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    
    @IBAction func HardTablesSwitch(_ sender: UISegmentedControl, forEvent event: UIEvent) {
        if sender.selectedSegmentIndex == 0
        {
            UIView.animate(withDuration: 0.5) {
                self.HardPlayerTable.alpha = 1
                self.HardComputerTable.alpha = 0
            }
        }
        else
        {
            UIView.animate(withDuration: 0.5) {
                self.HardPlayerTable.alpha = 0
                self.HardComputerTable.alpha = 1
            }
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
