//
//  HardPlayerTableViewController.swift
//  Bulls and Cows
//
//  Created by Mete Hergül on 31.08.2020.
//  Copyright © 2020 CSTECH. All rights reserved.
//

import UIKit

class HardPlayerTableViewController: UIViewController, UITableViewDataSource {

    var data: [[Int]] = HardPredictionsData.PlayerData
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HardPlayerCell", for: indexPath) as! PCTableViewCell
        
        cell.number.text = "\(data[indexPath.row][0])"
        cell.bulls.text = "\(data[indexPath.row][1])"
        cell.cows.text = "\(data[indexPath.row][2])"
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPlayerTable), name: NSNotification.Name(rawValue: "HardButtonClicked"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(restartTable), name: NSNotification.Name(rawValue: "HardGameOver"), object: nil)
    }
    
    @objc func reloadPlayerTable()
    {
        data = HardPredictionsData.PlayerData
        tableView.reloadData()
    }
    
    @objc func restartTable()
    {
        HardPredictionsData.PlayerData = []
        data = HardPredictionsData.PlayerData
        tableView.reloadData()
    }

}
