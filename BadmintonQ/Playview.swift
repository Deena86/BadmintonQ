//
//  Queueview.swift
//  BadmintonQ
//
//  Created by Deenadayal Loganathan on 10/6/15.
//  Copyright (c) 2015 Deena. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class Playview: UITableViewController {
   // let url:String="http://ec2-52-91-103-107.compute-1.amazonaws.com/api/"
    var dictPlayerName :[String:Int] = [:]
    @IBOutlet var tblQueue: UITableView!
    var arrayPlaying = [String]()
    var intClubid:Int = 0
    var dictPlaydata:JSON = []
    var intNoCourts:Int = 0
    var k=0;
    var refreshControl2: UIRefreshControl!
    var customView: UIView!
    var isAnimating = false
    var currentColorIndex = 0
    var currentLabelIndex = 0
    var labelsArray: Array<UILabel> = []
    var timer: Timer!
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    let prefs = UserDefaults.standard
    
    @IBOutlet weak var barButton: UIButton!
  
   let cars = ["Advacne", "Intermediate", "Beginner"]
    lazy fileprivate var activityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "imgShuttle")!
        return CustomActivityIndicatorView(image: image)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if((prefs.object(forKey: "CLUBID")) != nil)
        {
            intClubid = prefs.integer(forKey: "CLUBID")
        }
        
        if((prefs.object(forKey: "NOCOURTS")) != nil)
        {
            intNoCourts = prefs.integer(forKey: "NOCOURTS")
        }
        
        
        let navBar = self.navigationController!.navigationBar
        navBar.barTintColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1)
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
     
       
        refreshControl2 = UIRefreshControl()
        refreshControl2.backgroundColor = UIColor.clear
        refreshControl2.tintColor = UIColor.clear
        tblQueue.addSubview(refreshControl2)
        loadCustomRefreshContents()
        
        tblQueue.estimatedRowHeight=500
        tblQueue.rowHeight = UITableViewAutomaticDimension

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
       
        let intPlayingcourt = self.arrayPlaying.count / 4
        
        return intPlayingcourt
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return  1
    }
    override func viewWillAppear(_ animated: Bool) {
       
        dataload()
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       //let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let cellIdentifier = "Playviewcell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! Playviewcell
      
        if (self.arrayPlaying.isEmpty == false && self.k != self.arrayPlaying.count)
        {
         
            
        
            
            
            (cell.contentView.viewWithTag(10) as! UILabel).text  = String(self.arrayPlaying[k]) + "/" + String(arrayPlaying[k+1])
            (cell.contentView.viewWithTag(20)as! UILabel).text  =  String(self.arrayPlaying[k+2]) + "/" + String(arrayPlaying[k+3])

            
            self.k = self.k + 4
      
        }
      
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        
        // Ensure that this is a safe cast
        
       // print(cars)
        
        if self.arrayPlaying.isEmpty == false
        {
            return "Court -" + String(section+1);
        }
        
        // This should never happen, but is a fail safe
        return "unknown"
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "cellHeader") as! CustomTableviewcell
        
       if self.arrayPlaying.isEmpty == false
       {
        headerCell.lblHeader2.text = "Court -" + String(section+1);
        if (section % 2 == 0){
        
        headerCell.backgroundColor = UIColor.orange
        }
        else
        {
            
            headerCell.backgroundColor = UIColor.green
        }
        }
        return headerCell
    }
    
    



    @IBAction func btnLogoff(_ sender: AnyObject) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        if  ((FBSDKAccessToken.current()) != nil)
        {
            fbLoginManager.logOut()
            
            let alert = UIAlertController(title: "Logged Off!", message:"You have logged out", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                // Put here any code that you would like to execute when
                // the user taps that OK button (may be empty in your case if that's just
                // an informative alert)
                self.performSegue(withIdentifier: "segLogoff", sender: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true){}
            
            
            
        }
        
        
        
        
    }
    
    
    @IBAction func btnPlayView(_ sender: AnyObject) {
        
        let menuVC = storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
        menuVC.modalPresentationStyle = .custom
        menuVC.transitioningDelegate = self
        if menuVC is GuillotineAnimationDelegate {
            presentationAnimator.animationDelegate = menuVC as? GuillotineAnimationDelegate
        }
        presentationAnimator.supportView = self.navigationController?.navigationBar
        presentationAnimator.presentButton = sender as! UIView
       // presentationAnimator.duration = 0.6
        self.present(menuVC, animated: true, completion: nil)
        

        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var intQueueID1:Int = 0
        var intQueueID2:Int = 0
        var intQueueID3:Int = 0
        var intQueueID4:Int = 0
        var intScore1:Int = 0
        var intScore2:Int = 0
        
        let currentCell = tableView.cellForRow(at: indexPath) as! Playviewcell
        
       

     
        if (Commonutil.isStringNumerical(String(currentCell.txtAScore1.text!)) == true)
        {
           intScore1 = Int(currentCell.txtAScore1.text!)!
        }
        
        if (Commonutil.isStringNumerical(String(describing: currentCell.txtBScore1.text)) == true)
        {
            intScore2 = Int(currentCell.txtBScore1.text!)!
        }
        
    if ((intScore1 == 0) && (intScore2 == 0))
     {
          let alertscore = UIAlertController(title:"Enter Score", message:"Please enter score to close the game",preferredStyle: .alert)
       let okaction = UIAlertAction(title: "Okay", style: .default) { _ in
        }
        alertscore.addAction(okaction)
       
        self.present(alertscore, animated: true){}
    }
    else
    {
            
       
        
        let alert = UIAlertController(title: "Game Closed!", message:"Do you want to close this game?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            
            
         
          
     
          if (indexPath as NSIndexPath).section == 0
          {
            if self.dictPlayerName.keys.contains(self.arrayPlaying[(indexPath as NSIndexPath).section]) == true
            {
                intQueueID1 = Int(self.dictPlayerName[self.arrayPlaying[(indexPath as NSIndexPath).section]]!)
              
            }
            
            if self.dictPlayerName.keys.contains(self.arrayPlaying[(indexPath as NSIndexPath).section+1]) == true
            {
                intQueueID2 = Int(self.dictPlayerName[self.arrayPlaying[(indexPath as NSIndexPath).section+1]]!)
                
            }
            
            if self.dictPlayerName.keys.contains(self.arrayPlaying[(indexPath as NSIndexPath).section+2]) == true
            {
               intQueueID3 = Int(self.dictPlayerName[self.arrayPlaying[(indexPath as NSIndexPath).section+2]]!)
                
            }
            
            if self.dictPlayerName.keys.contains(self.arrayPlaying[(indexPath as NSIndexPath).section+3]) == true
            {
               intQueueID4 = Int(self.dictPlayerName[self.arrayPlaying[(indexPath as NSIndexPath).section+3]]!)
                
            }
          }
          else
          {
            if self.dictPlayerName.keys.contains(self.arrayPlaying[(indexPath as NSIndexPath).section*4]) == true
            {
                intQueueID1 = Int(self.dictPlayerName[self.arrayPlaying[(indexPath as NSIndexPath).section*4]]!)
               
            }
            
            if self.dictPlayerName.keys.contains(self.arrayPlaying[((indexPath as NSIndexPath).section*4)+1]) == true
            {
                intQueueID2 = Int(self.dictPlayerName[self.arrayPlaying[((indexPath as NSIndexPath).section*4)+1]]!)
                
            }
            
            if self.dictPlayerName.keys.contains(self.arrayPlaying[((indexPath as NSIndexPath).section*4)+2]) == true
            {
               intQueueID3 = Int(self.dictPlayerName[self.arrayPlaying[((indexPath as NSIndexPath).section*4)+2]]!)
               
            }
            
            if self.dictPlayerName.keys.contains(self.arrayPlaying[((indexPath as NSIndexPath).section*4)+3]) == true
            {
               intQueueID4 = Int(self.dictPlayerName[self.arrayPlaying[((indexPath as NSIndexPath).section*4)+3]]!)
                
            }
          }
          
            var boolWon1:Bool = false
            var boolWon2:Bool = false
         
         if intScore1 > intScore2
         {
            boolWon1 = true
            
         }
            else
         {
            boolWon2 = true
            
         }
       
            
         
            
            
            let myDictOfDict:NSDictionary = [
                "Queue1" : ["QueueID": intQueueID1, "Score": intScore1,"Won":boolWon1]
                ,   "Queue2" : ["QueueID": intQueueID2, "Score": intScore1,"Won":boolWon1]
                ,   "Queue3" : ["QueueID": intQueueID3, "Score": intScore2,"Won":boolWon2]
                ,   "Queue4" : ["QueueID": intQueueID4, "Score": intScore2,"Won":boolWon2]
            ]
           
         
           
           //self.dataload()
            BadmintonQData.post(myDictOfDict,Method: "POST", url: url+"/GameClose") { (succeeded: Bool, msg: String) -> () in
                let alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
                
                if(succeeded) {
                   
                    alert.title = "Success!"
                    alert.message = msg
                    
                }
                else {
                    alert.title = "Failed : ("
                    alert.message = msg
                }
                
                // Move to the UI thread
                DispatchQueue.main.async(execute: { () -> Void in
                    // Show the alert
                    self.performSegue(withIdentifier: "unwindToMenu", sender: self)
                    alert.show()
                    //self.performSegueWithIdentifier("SegQueue", sender: nil)
                })
            }
            
            
        }
            
    
        let noAction =  UIAlertAction(title: "No", style: .default) { _ in
            
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true){}
        
        //self.performSegueWithIdentifier("segQ", sender: nil)
        }
        }
    
        func addLoadingIndicator () {
            self.view.addSubview(activityIndicator)
            activityIndicator.center = self.view.center
        }
    
        func dataload ()
        {
            self.k = 0
            addLoadingIndicator()
            activityIndicator.startAnimating()
            BadmintonQData.getData (url+"/QueueMe/"+String(intClubid)  , success:{(iTunesData) -> Void in
                self.dictPlaydata = JSON(data: iTunesData!)
                for (index, object) in self.dictPlaydata {
                    
                    if object["QStatusID"].stringValue == "4"
                    {
                                                self.arrayPlaying.append(object["PlayerName"].stringValue)
                        self.dictPlayerName[object["PlayerName"].stringValue] = Int(object["QueueID"].stringValue)
                    }
                    
                }
                
                //self.arrayPlaying = Array(self.dictPlayerName.keys)
                
                
                
               
                
                DispatchQueue.main.async(execute: { () -> Void in
                    // Show the alert
                  self.activityIndicator.stopAnimating()
                  self.activityIndicator.isHidden = true
                  self.tblQueue.reloadData()
                    //self.performSegueWithIdentifier("SegQueue", sender: nil)
                })
                
                
                
                
                
                // More soon...
            })
            
        }
    

    
    func loadCustomRefreshContents() {
        let refreshContents = Bundle.main.loadNibNamed("Refresh", owner: self, options: nil)
        customView = refreshContents?[0] as! UIView
        customView.frame = refreshControl2.bounds
        
        for i in 0 ..< customView.subviews.count {
           
            labelsArray.append(customView.viewWithTag(i + 1) as! UILabel)
        }
        
        refreshControl2.addSubview(customView)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl2.isRefreshing {
            if !isAnimating {
                doSomething1()
                animateRefreshStep1()
            }
        }
    }
    
    func animateRefreshStep1() {
        isAnimating = true
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            self.labelsArray[self.currentLabelIndex].transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
            self.labelsArray[self.currentLabelIndex].textColor = self.getNextColor()
            
            }, completion: { (finished) -> Void in
                
                UIView.animate(withDuration: 0.05, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                    self.labelsArray[self.currentLabelIndex].transform = CGAffineTransform.identity
                    self.labelsArray[self.currentLabelIndex].textColor = UIColor.black
                    
                    }, completion: { (finished) -> Void in
                        self.currentLabelIndex += 1
                        
                        if self.currentLabelIndex < self.labelsArray.count {
                            self.animateRefreshStep1()
                        }
                        else {
                            self.animateRefreshStep2()
                        }
                })
        })
    }
    
    
    
    func getNextColor() -> UIColor {
        var colorsArray: Array<UIColor> = [UIColor.magenta, UIColor.brown, UIColor.yellow, UIColor.red, UIColor.green, UIColor.blue, UIColor.orange]
        
        if currentColorIndex == colorsArray.count {
            currentColorIndex = 0
        }
        
        let returnColor = colorsArray[currentColorIndex]
        currentColorIndex += 1
        
        return returnColor
    }
    
    
    func animateRefreshStep2() {
        UIView.animate(withDuration: 0.35, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            self.labelsArray[0].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelsArray[1].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelsArray[2].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelsArray[3].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelsArray[4].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelsArray[5].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelsArray[6].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelsArray[7].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelsArray[8].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelsArray[9].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: { (finished) -> Void in
                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                    self.labelsArray[0].transform = CGAffineTransform.identity
                    self.labelsArray[1].transform = CGAffineTransform.identity
                    self.labelsArray[2].transform = CGAffineTransform.identity
                    self.labelsArray[3].transform = CGAffineTransform.identity
                    self.labelsArray[4].transform = CGAffineTransform.identity
                    self.labelsArray[5].transform = CGAffineTransform.identity
                    self.labelsArray[6].transform = CGAffineTransform.identity
                    self.labelsArray[7].transform = CGAffineTransform.identity
                    self.labelsArray[8].transform = CGAffineTransform.identity
                    self.labelsArray[9].transform = CGAffineTransform.identity
                    
                    
                    }, completion: { (finished) -> Void in
                        if self.refreshControl2.isRefreshing {
                            self.currentLabelIndex = 0
                            self.animateRefreshStep1()
                        }
                        else {
                            self.isAnimating = false
                            self.currentLabelIndex = 0
                            for i in 0 ..< self.labelsArray.count {
                                self.labelsArray[i].textColor = UIColor.black
                                self.labelsArray[i].transform = CGAffineTransform.identity
                            }
                        }
                })
        })
    }
    
    func doSomething1() {
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(Playview.endOfWork), userInfo: nil, repeats: true)
        self.arrayPlaying.removeAll()
        self.dictPlayerName.removeAll()
        self.k = 0
        dataload()
        
    }
    
    func endOfWork() {
        refreshControl2.endRefreshing()
        
        timer.invalidate()
        timer = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    
               
        
        
    }
    
}

extension Playview: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}
