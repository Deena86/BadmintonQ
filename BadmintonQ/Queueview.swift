//
//  Queueview.swift
//  BadmintonQ
//
//  Created by Deenadayal Loganathan on 12/19/15.
//  Copyright © 2015 Deena. All rights reserved.
//

import UIKit

class Queueview: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    let arrayAdvance = ["Deena", "Karthik", "Suresh"];
    let arrayIntermediate = ["Saravanan","Zauffer","Ashok","Santosh","Saravanan","Zauffer","Ashok","Santosh"];
    let arrayBeginner = ["Sumaiya","Sasi","Seetharaman","Sumaiya","Sasi","Seetharaman","Sumaiya","Sasi","Seetharaman"];
    let arraySkill = ["Advance","Intermediate","Begninner"];


    @IBOutlet weak var tblAdvance: UITableView!
    @IBOutlet weak var tblIntermediate: UITableView!
    @IBOutlet weak var tblBeginner: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblAdvance.delegate = self
        tblAdvance.dataSource = self
    
       // self.tblAdvance.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellQ")
        tblIntermediate.delegate = self
        tblIntermediate.dataSource = self
        tblBeginner.dataSource = self
        tblBeginner.delegate = self
        tblAdvance.estimatedRowHeight=50
        tblAdvance.rowHeight=UITableViewAutomaticDimension
        tblAdvance.isScrollEnabled = true
        tblIntermediate.estimatedRowHeight=200
        tblIntermediate.rowHeight=UITableViewAutomaticDimension
        tblIntermediate.isScrollEnabled = true
        tblIntermediate.estimatedRowHeight=200
        tblBeginner.rowHeight=UITableViewAutomaticDimension
        tblBeginner.isScrollEnabled = true
        self.tblAdvance.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tblIntermediate.register(UITableViewCell.self, forCellReuseIdentifier: "cellQ")
        self.tblIntermediate.register(UITableViewCell.self, forCellReuseIdentifier: "celQ")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        

        if tableView.tag == 10
        {
            let cell:UITableViewCell = self.tblAdvance.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
            cell.textLabel?.text = arrayAdvance[(indexPath as NSIndexPath).row]
            return cell
        }
        else if tableView.tag == 20
        {
            let cell:UITableViewCell = self.tblIntermediate.dequeueReusableCell(withIdentifier: "cellQ")! as UITableViewCell
            cell.textLabel?.text = arrayIntermediate[(indexPath as NSIndexPath).row]
            return cell
        }
            
        else if tableView.tag == 30
        {
            let cell:UITableViewCell = self.tblBeginner.dequeueReusableCell(withIdentifier: "celQ")! as UITableViewCell
            cell.textLabel?.text = arrayBeginner[(indexPath as NSIndexPath).row]
            return cell
        }
        
        return cell
        
        
    }
    


}
