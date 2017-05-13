//
//  viewPop.swift
//  BadmintonQ
//
//  Created by Deenadayal Loganathan on 12/25/15.
//  Copyright © 2015 Deena. All rights reserved.
//

protocol MyDelegate{
    func DoSomething(_ arrSelectedPlayers:NSArray,intSelect:Int)
}
import UIKit

class viewPop: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var delegate:MyDelegate?
    var inputTextDelegate:String = ""
    
    @IBOutlet weak var tblPop: UITableView!
    var arryPlayers = [[String]]()
    var intSkill:Int = 2
    var intSelectedPlayer:Int = 0
    var arrySwapedPlayers = [[String]]()
    var intFromQueueId = 0
    var intToQueueID = 0
    var dictQueuedata:JSON = []
   // let url:String="http://ec2-52-91-103-107.compute-1.amazonaws.com/api/"
    override func viewDidLoad() {
        super.viewDidLoad()
        print(intSelectedPlayer)
        print(arryPlayers)
       
        tblPop.delegate = self
        tblPop.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
  
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
               return arryPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPop", for: indexPath)
        
        
        cell.textLabel?.text = String(arryPlayers[(indexPath as NSIndexPath).row
            ][0])
      
        
        return cell
        
        
    }
    
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
       // let abc = arryPlayers[indexPath.row][0]
        //NSString(arryPlayers[indexPath.row][0])
         intToQueueID = Commonutil.findQueueid(arryPlayers[indexPath.row][0] as NSString, dict: self.dictQueuedata)
        
        arrySwapedPlayers =  arryPlayers
        
        
        
        
       //arrySwapedPlayers[intSelectedPlayer] = arryPlayers[indexPath.row]
      //  arrySwapedPlayers[ndexPath.row] =
       
        BadmintonQData.post([:],Method: "POST", url: url+"SwapPlayer/"+String(intFromQueueId)+"/"+String(intToQueueID)) { (succeeded: Bool, msg: String) -> () in
            let alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
            
            if(succeeded) {
                alert.title = "Success!"
                alert.message = "Player has been Skipped"
                
            }
            else {
                alert.title = "Failed : ("
                alert.message = msg
            }
            
            // Move to the UI thread
            DispatchQueue.main.async(execute: { () -> Void in
                // Show the alert
                alert.show()
               
                //  self.tblQueue.reloadData()
            })
        }
       
        
        
        if let delegate = self.delegate {
            delegate.DoSomething(arrySwapedPlayers as NSArray,intSelect: self.intSkill)
            self.dismiss(animated: true, completion: nil)
            
        }
        
        
    }

}


