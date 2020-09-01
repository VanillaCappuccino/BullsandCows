//
//  EasyComputerTableViewController.swift
//  Bulls and Cows
//
//  Created by Mete Hergül on 31.08.2020.
//  Copyright © 2020 CSTECH. All rights reserved.
//

import UIKit

class EasyComputerTableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var data:[[Int]] = EasyPredictionsData.ComputerData
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EasyComputerCell", for: indexPath) as! EasyComputerTableViewCell
        
        cell.numbers.text = "\(data[indexPath.row][0])"
        cell.bulls.text = "\(data[indexPath.row][1])"
        cell.cows.text = "\(data[indexPath.row][2])"
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadComputerTable), name: NSNotification.Name(rawValue: "EasyButtonClicked"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(restartTable), name: NSNotification.Name(rawValue: "EasyGameOver"), object: nil)
    }
    
    @objc func reloadComputerTable()
    {
        data = EasyPredictionsData.ComputerData
        tableView.reloadData()
    }
    
    @objc func restartTable()
    {
        EasyPredictionsData.ComputerData = []
        data = EasyPredictionsData.ComputerData
        tableView.reloadData()
    }

}
