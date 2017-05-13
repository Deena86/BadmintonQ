//
//  ViewController.swift
//  SimpleTableView
//
//  Created by Andrei Puni on 25/12/14.
//  Copyright (c) 2014 Andrei Puni. All rights reserved.
//

import UIKit

class ViewController1: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tblAdvance: UITableView!
    @IBOutlet var tableView1: UITableView!
    
    @IBOutlet weak var tblBeginners: UITableView!
    
    let arrayAdvance = ["Advance","Deena", "Karthik", "Suresh","Deena", "Karthik", "Suresh"];
    let arrayIntermediate = ["Intermediate","Saravanan","Zauffer","Ashok","Santosh","Sarava","Zauffer","Ashok","Santosh"];
    let arrayBeginner = ["Beginner","Sumaiya","Sasi","Seetharaman","Sumaiy","Sasi","Seetharam","Sumaiya","Sasi","Seetharaman"];
    let arraySkill = ["Advance","Intermediate","Begninner"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblAdvance.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tblAdvance.dataSource = self
        self.tblAdvance.delegate = self
        self.tableView1.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView1.dataSource = self
        self.tableView1.delegate = self
        self.tblBeginners.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tblBeginners.dataSource = self
        self.tblBeginners.delegate = self
        
        tblAdvance.estimatedRowHeight=10
        tblAdvance.rowHeight=UITableViewAutomaticDimension
        
        tableView1.estimatedRowHeight=10
        tableView1.rowHeight=UITableViewAutomaticDimension
        
        tblBeginners.estimatedRowHeight=10
        tblBeginners.rowHeight=UITableViewAutomaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 10
        {
            return arrayAdvance.count
            
        }
        else if tableView.tag == 20
        {
            
            return arrayIntermediate.count
        }
        else if tableView.tag == 30
        {
            return arrayBeginner.count
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        /*if tableView.tag == 10
        {
        return arrayAdvance.count
        }
        else if tableView.tag == 20
        {
        return arrayIntermediate.count
        }
        else if tableView.tag == 30
        {
        return arrayBeginner.count
        }*/
        
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      /*  var cell:UITableViewCell = self.tblAdvance.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell*/
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        
        
        if tableView.tag == 10
        {
            if (indexPath as NSIndexPath).row == 0 {
                cell.backgroundColor = UIColor.orange
                cell.textLabel!.adjustsFontSizeToFitWidth = true
                cell.textLabel!.textAlignment = .center;
              //  cell.textLabel!.minimumScaleFactor = 0.1
               // cell.textLabel!.minimumFontSize = 10.0
                
                cell.textLabel!.font = UIFont.systemFont(ofSize: 30.0)
                cell.textLabel!.text = arrayAdvance[(indexPath as NSIndexPath).row]
                //String(reportData[indexPath.row] as NSString)
            }
           // let cell:UITableViewCell = self.tblAdvance.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
            cell.textLabel!.font = UIFont.systemFont(ofSize: 10.0)
            cell.textLabel!.adjustsFontSizeToFitWidth = true
            cell.textLabel?.text = arrayAdvance[(indexPath as NSIndexPath).row]
            return cell
        }
        else if tableView.tag == 20
        {
            print((indexPath as NSIndexPath).row)
            if (indexPath as NSIndexPath).row == 0 {
                cell.backgroundColor = UIColor.yellow
                cell.textLabel!.adjustsFontSizeToFitWidth = true
                cell.textLabel!.textAlignment = .center;
                //  cell.textLabel!.minimumScaleFactor = 0.1
                // cell.textLabel!.minimumFontSize = 10.0
                
                cell.textLabel!.font = UIFont.systemFont(ofSize: 30.0)
                cell.textLabel!.text = arrayIntermediate[(indexPath as NSIndexPath).row]
                print("\((indexPath as NSIndexPath).row) + test \(arrayIntermediate[(indexPath as NSIndexPath).row]) " )
                //String(reportData[indexPath.row] as NSString)
            }
           // let cell:UITableViewCell = self.tableView1.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
            cell.textLabel!.font = UIFont.systemFont(ofSize: 10.0)
            cell.textLabel!.adjustsFontSizeToFitWidth = true
            cell.textLabel?.text = arrayIntermediate[(indexPath as NSIndexPath).row]
            return cell
        }
            
        else if tableView.tag == 30
        {
            if (indexPath as NSIndexPath).row == 0 {
                cell.backgroundColor = UIColor.green
                cell.textLabel!.adjustsFontSizeToFitWidth = true
                cell.textLabel!.textAlignment = .center;
                //  cell.textLabel!.minimumScaleFactor = 0.1
                // cell.textLabel!.minimumFontSize = 10.0
                
                cell.textLabel!.font = UIFont.systemFont(ofSize: 30.0)
                cell.textLabel!.text = arrayBeginner[(indexPath as NSIndexPath).row]
                print("\((indexPath as NSIndexPath).row) + test \(arrayBeginner[(indexPath as NSIndexPath).row]) " )
                //String(reportData[indexPath.row] as NSString)
            }
            cell.textLabel!.font = UIFont.systemFont(ofSize: 10.0)
            cell.textLabel!.adjustsFontSizeToFitWidth = true
            cell.textLabel?.text = arrayBeginner[(indexPath as NSIndexPath).row]
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView!, didSelectRowAt indexPath: IndexPath) {
       // print("You selected cell #\(indexPath.row)!")
    }
    
}
