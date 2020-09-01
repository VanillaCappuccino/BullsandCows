//
//  PracticeTableViewController.swift
//  Bulls and Cows
//
//  Created by Mete Hergül on 31.08.2020.
//  Copyright © 2020 CSTECH. All rights reserved.
//

import UIKit

class PracticeTableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data: [[Int]] = PracticePredictionsData.PlayerData
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PracticePlayerCell", for: indexPath) as! PracticeTableViewCell
        
        cell.number.text = "\(data[indexPath.row][0])"
        cell.bulls.text = "\(data[indexPath.row][1])"
        cell.cows.text = "\(data[indexPath.row][2])"
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(updatePracticeTable), name: NSNotification.Name(rawValue: "PracticeButtonClicked"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(restartTable), name: NSNotification.Name(rawValue: "PracticeGameOver"), object: nil)
    }
    
    @objc func updatePracticeTable()
    {
        data = PracticePredictionsData.PlayerData
        tableView.reloadData()
    }
    
    @objc func restartTable()
    {
        PracticePredictionsData.PlayerData = []
        data = PracticePredictionsData.PlayerData
        tableView.reloadData()
    }

}
