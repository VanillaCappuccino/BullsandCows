//
//  PracticeViewController.swift
//  Bulls and Cows
//
//  Created by Mete Hergül on 31.08.2020.
//  Copyright © 2020 CSTECH. All rights reserved.
//

import UIKit
import AudioToolbox

struct PracticePredictionsData
{
    static var PlayerData: [[Int]] = []
}


class PracticeViewController: UIViewController {

    @IBOutlet weak var PracticePlayerTable: UIView!
    @IBOutlet weak var NumberEntryField: OneTimeNumberField!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var bullsCowsCounter: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        NumberEntryField.configure()
        StatusLabel.text = "Turn: \(turnCount)"
        bullsCowsCounter.text = "Bulls: 0, Cows: 0"
        let practiceBeginAlert = UIAlertController(title: "Practice Mode", message: "This is the Practice mode. You can work on your guessing skills here!", preferredStyle: .alert)
        practiceBeginAlert.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: nil))
        self.present(practiceBeginAlert, animated: true)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        NotificationCenter.default.addObserver(self, selector: #selector(restartPractice), name: NSNotification.Name(rawValue: "PracticeGameOver"), object: nil )
    }
    
    let CompConds = ProcessedNumber(numb: 1111, mode: 4)
    lazy var space = CompConds.numgen(mode: 4)
    lazy var tbGuessed = CompConds.randnum(space: space)
    lazy var turnCount = 1
    lazy var predicted: [Int] = []
    
    @IBAction func restartButton(_ sender: UIButton, forEvent event: UIEvent) {
        restartPractice()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PracticeGameOver"), object: nil)
        let practiceRestart = UIAlertController(title: "Restart: Practice", message: "The game has been restarted.", preferredStyle: .alert)
        practiceRestart.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: nil))
        self.present(practiceRestart, animated: true)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    
    @IBAction func predictButton(_ sender: UIButton, forEvent event: UIEvent)
    {
        var valid: Bool = false
        var relay: Int = 1111
        var plusCount: Int = 0
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
            PracticePredictionsData.PlayerData.append([relay,pmArray[0],pmArray[1]])
            turnCount += 1
            StatusLabel.text = "Turn: \(turnCount)"
            plusCount = pmArray[0]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PracticeButtonClicked"), object: nil)
        }
        else
        {
            NumberEntryField.clear()
            StatusLabel.text = "Invalid prediction, please try again."
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        if plusCount == 4
        {
            let practiceOverAlert = UIAlertController(title: "Game Over", message: "You completed this hand in \(turnCount) turns. Congratulations!", preferredStyle: .alert)
            practiceOverAlert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { action in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PracticeGameOver"), object: nil)
            }))
            self.present(practiceOverAlert, animated: true)
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
        }
        
        
    }
    
    @objc func restartPractice ()
    {
        bullsCowsCounter.text = "Bulls: 0, Cows: 0"
        space = CompConds.numgen(mode: 4)
        tbGuessed = CompConds.randnum(space: space)
        turnCount = 1
        StatusLabel.text = "Turn: \(turnCount)"
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
