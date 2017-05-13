//
//  Queueview.swift
//  BadmintonQ
//
//  Created by Deenadayal Loganathan on 12/19/15.
//  Copyright © 2015 Deena. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class Queueview1:UITableViewController, UIPopoverPresentationControllerDelegate, MyDelegate {
    
    @IBOutlet weak var barButton: UIButton!
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    @IBOutlet var tblQueue: UITableView!
    var arrayAdvance = [[String]]()
    var arrayIntermediate = [[String]]()
    var refreshControl1: UIRefreshControl!
    var arrayBeginner = [[String]]()
    var arrayAll = [[String]]()
    var arrayPlaying = [String]()
    var arrayWaiting = [[String]]()
    let arraySkill = ["Dummy","Begninner","Intermediate","Advance","All","Queue"];
    var intSkill:Int = 4;
    var popoverController : UIPopoverController? = nil
    var intSelect:Int = -1
    var arraySelectedPlayers = [[String]]()
    var customView: UIView!
    var isAnimating = false
    var currentColorIndex = 0
    var currentLabelIndex = 0
    var labelsArray: Array<UILabel> = []
    var timer: Timer!
    var intClubid:Int = 0
    var intNoCourts:Int = 0
    var dictQueuedata:JSON = []
    let prefs = UserDefaults.standard
    var hostNavigationBarHeight: CGFloat!
    var hostTitleText: NSString!
    var dictWaitQueuedata:JSON = []
    var intLoginPlayerid:Int = 0
   // let url:String="http://ec2-52-91-103-107.compute-1.amazonaws.com/api/"
    
    @IBOutlet weak var btnAdvance: UIBarButtonItem!
    @IBOutlet weak var btnIntermediate: UIBarButtonItem!
    @IBOutlet weak var btnBeginner: UIBarButtonItem!
    
    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    lazy fileprivate var activityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "imgShuttle")!
        return CustomActivityIndicatorView(image: image)
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = false;
        
        if (self.prefs.object(forKey: "Loginuser") == nil)
        {
            if Commonutil.logoff() == true
            {
                self.performSegue(withIdentifier: "segLogoff", sender: nil)
            }

        }
        
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
        
        if intSelect == 3
        {
          
            arrayAll = arraySelectedPlayers
        }
            
        else if intSelect == 0
        {
            arrayAdvance = arraySelectedPlayers
        }
        
        else if intSelect == 1
        {
            arrayIntermediate = arraySelectedPlayers
        }
        else if intSelect == 2
        {
            arrayBeginner = arraySelectedPlayers
        }

        refreshControl1 = UIRefreshControl()
        refreshControl1.backgroundColor = UIColor.clear
        refreshControl1.tintColor = UIColor.clear
        tblQueue.addSubview(refreshControl1)
        loadCustomRefreshContents()
        
        
        if intClubid == 23
        {
            btnAdvance.title = "Elite"
            btnBeginner.title = "Intermediate"
            btnIntermediate.title = "Advance"
           /* @IBOutlet weak var btnAdvance: UIBarButtonItem!
            @IBOutlet weak var btnIntermediate: UIBarButtonItem!
            @IBOutlet weak var btnBeginner: UIBarButtonItem!*/
        }



    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if intSkill == 3
        {
          return arrayAdvance.count
            
        }
        else if intSkill == 2
        {
            
            return arrayIntermediate.count
        }
        else if intSkill == 1
        {
            return arrayBeginner.count
        }
        else if intSkill == 4
        {
            return arrayAll.count
        }
        else if intSkill == 5
        {
            
            return arrayWaiting.count
            
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
    if intClubid != 23
    {
        if intSkill == 3
        {
            
            if let carsArray = arraySkill as [String]?
            {
                return carsArray[intSkill]
            }
        }
        else if intSkill == 2
        {
            if let carsArray = arraySkill as [String]?
            {
                return carsArray[intSkill]
            }
        }
        else if intSkill == 1
        {
            if let carsArray = arraySkill as [String]?
            {
                return carsArray[intSkill]
            }
        }
        
        else if intSkill == 4
        {
            if let carsArray = arraySkill as [String]?
            {
                return carsArray[intSkill]
            }
        }
        
    }
    else{
        switch (intSkill)
        {
        case 3:
            
              return "Elite"
        case 2:
            return "Advance"
        case 1:
            return "Intermediate"
            
        default:
            
                return "Unknow"
            
            
        }
        
        }
  
        
        // This should never happen, but is a fail safe
        return "unknown"
    }


    @IBAction func btnMenu(_ sender: AnyObject) {
        
        let menuVC = storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
        menuVC.modalPresentationStyle = .custom
        menuVC.transitioningDelegate = self
        if menuVC is GuillotineAnimationDelegate {
            presentationAnimator.animationDelegate = menuVC as? GuillotineAnimationDelegate
        }
        presentationAnimator.supportView = self.navigationController?.navigationBar
        presentationAnimator.presentButton = sender as! UIView
        //presentationAnimator.duration = 0.6
        self.present(menuVC, animated: true, completion: nil)
        



        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellQ", for: indexPath)
        if intSkill == 3
        {
            (cell.contentView.viewWithTag(20) as! UILabel).text = String(arrayAdvance[(indexPath as NSIndexPath).row][0])
            (cell.contentView.viewWithTag(10) as! UILabel).text = String(arrayAdvance[(indexPath as NSIndexPath).row][1])
            //cell.textLabel?.text =
            return cell
        }
        else if intSkill == 2
        {
            //cell.textLabel?.text =
            (cell.contentView.viewWithTag(20) as! UILabel).text = arrayIntermediate[(indexPath as NSIndexPath).row][0]
            (cell.contentView.viewWithTag(10) as! UILabel).text = arrayIntermediate[(indexPath as NSIndexPath).row][1]
            return cell
        }
        
        else if intSkill == 1
        {
            (cell.contentView.viewWithTag(20) as! UILabel).text = arrayBeginner[(indexPath as NSIndexPath).row][0]
            (cell.contentView.viewWithTag(10) as! UILabel).text = arrayBeginner[(indexPath as NSIndexPath).row][1]
            //cell.textLabel?.text = arrayBeginner[indexPath.row]
            return cell
        }
        
        else if intSkill == 4
        {
            (cell.contentView.viewWithTag(20) as! UILabel).text = arrayAll[(indexPath as NSIndexPath).row][0]
            (cell.contentView.viewWithTag(10) as! UILabel).text = arrayAll[(indexPath as NSIndexPath).row][1]

            //cell.textLabel?.text = arrayAll[indexPath.row]
            return cell
        }
        
        else if intSkill == 5
        {
            (cell.contentView.viewWithTag(20) as! UILabel).text = arrayWaiting[(indexPath as NSIndexPath).row][0]
            (cell.contentView.viewWithTag(10) as! UILabel).text = arrayWaiting[(indexPath as NSIndexPath).row][1]
            //cell.textLabel?.text = arrayWaiting[indexPath.row]
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }

       return cell
      

        
    }


    @IBAction func btnToolWait(_ sender: AnyObject) {
        dataload()
        intSkill = 5
        tblQueue.setEditing(false, animated: true)
        tblQueue.reloadData()
        
    }
    @IBAction func btnToolAdvance(_ sender: AnyObject) {
        dataload()
        intSkill = 3
        tblQueue.reloadData()
    }
    
   
    @IBAction func btnToolIntermediate(_ sender: AnyObject) {
        dataload()
        intSkill = 2
        tblQueue.reloadData()
    }
    
    
    @IBAction func btnToolAll(_ sender: AnyObject) {
        dataload()
        intSkill = 4
        tblQueue.reloadData()
    }
    
    @IBAction func btnToolBeginner(_ sender: AnyObject) {
        dataload()
        intSkill = 1
        tblQueue.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "cellHeader") as! CustomTableviewcell
        
        if intClubid != 23
        {
        switch (intSkill) {
        case 3:
            headerCell.lblHeader.text = "Advance";
            headerCell.backgroundColor = UIColor.orange
            //return sectionHeaderView
        case 2:
            headerCell.lblHeader.text = "Intermediate";
            headerCell.backgroundColor = UIColor.yellow
        case 1:
            headerCell.lblHeader.text = "Beginner";
            headerCell.backgroundColor = UIColor.green
            //return sectionHeaderView
        case 4:
            headerCell.lblHeader.text = "All";
            headerCell.backgroundColor = UIColor.green
            //return sectionHeaderView
        case 5:
            headerCell.lblHeader.text = "Waiting";
            headerCell.backgroundColor = UIColor.blue
        default:
            headerCell.lblHeader.text = "Other";
        }
        }
        else
        {
            switch (intSkill) {
            case 3:
                headerCell.lblHeader.text = "Elite";
                headerCell.backgroundColor = UIColor.orange
            //return sectionHeaderView
            case 2:
                headerCell.lblHeader.text = "Advance";
                headerCell.backgroundColor = UIColor.yellow
            case 1:
                headerCell.lblHeader.text = "Intermediate";
                headerCell.backgroundColor = UIColor.green
            //return sectionHeaderView
            case 4:
                headerCell.lblHeader.text = "All";
                headerCell.backgroundColor = UIColor.green
            //return sectionHeaderView
            case 5:
                headerCell.lblHeader.text = "Waiting";
                headerCell.backgroundColor = UIColor.blue
            default:
                headerCell.lblHeader.text = "Other";
            }
   
        }
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
   /* override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if intSkill == 5
        {
            return false
        }
        else
        {
            return true
        }
    }*/
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let selectedCellSourceview:UITableViewCell = tableView.cellForRow(at: indexPath)!
      
        // 3
        var searchstring:NSString = ""
        switch (self.intSkill) {
        case 3:
           searchstring = self.arrayAdvance[(indexPath as NSIndexPath).row][0] as NSString
        case 2:
            searchstring = self.arrayIntermediate[(indexPath as NSIndexPath).row][0] as NSString
        case 1:
            searchstring = self.arrayBeginner[(indexPath as NSIndexPath).row][0] as NSString
        case 5:
            searchstring = self.arrayWaiting[(indexPath as NSIndexPath).row][0] as NSString
        //return sectionHeaderView
        default:
           searchstring = self.arrayAll[(indexPath as NSIndexPath).row][0] as NSString
        }
        var  queueid = 0
        let editPlayerId = Commonutil.findPlayerid(searchstring, dict: self.dictQueuedata)
        if intSkill == 5
        {
          queueid = Commonutil.findQueueid(searchstring, dict: self.dictQueuedata)
        }
        else{
           queueid = Commonutil.findQueueid(searchstring, dict:self.dictWaitQueuedata)
            
        }
      
        let SwapAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Swap" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            // 2
            var alertController = UIAlertController()
        if editPlayerId == self.intLoginPlayerid
        {
            
            
             alertController = UIAlertController(title: "Player Swap", message: "Do you want to Swap your position", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action) in
              // self.tblQueue.endEditing(true)
            }
            alertController.addAction(cancelAction)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let popoverContent = storyBoard.instantiateViewController(withIdentifier: "viewPop") as! viewPop
                
                switch (self.intSkill) {
                case 3:
                    popoverContent.arryPlayers = self.arrayAdvance           //return sectionHeaderView
                case 2:
                    popoverContent.arryPlayers = self.arrayIntermediate
                case 1:
                    popoverContent.arryPlayers = self.arrayBeginner
                //return sectionHeaderView
                case 4:
                    popoverContent.arryPlayers = self.arrayAll
                case 5:
                    popoverContent.arryPlayers = self.arrayWaiting
                //return sectionHeaderView
                default:
                    popoverContent.arryPlayers = self.arrayBeginner
                }
                popoverContent.delegate = self
                popoverContent.intSelectedPlayer = (indexPath as NSIndexPath).row
                popoverContent.intSkill = self.intSkill
                popoverContent.intFromQueueId = queueid
                popoverContent.dictQueuedata = self.dictQueuedata
                let nav = UINavigationController(rootViewController: popoverContent)
                nav.modalPresentationStyle = UIModalPresentationStyle.popover
                let popover = nav.popoverPresentationController
                popoverContent.preferredContentSize = CGSize(width: 200,height: 300)
                popover!.delegate = self
                popover!.sourceView = self.view
                popover!.permittedArrowDirections = .any
                popover!.sourceView = selectedCellSourceview.contentView
                // popover!.sourceRect = CGRectMake(100,100,0,0)
                popover!.sourceRect = (selectedCellSourceview.bounds)
                
                self.present(nav, animated: true, completion: nil)
                
               
            }
            alertController.addAction(yesAction)
            
            
        }
            else
        {
             alertController = UIAlertController(title: "Player Swap", message: "You cannot swap another player", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Okay", style: .cancel) { (action) in
                // self.tblQueue.endEditing(true)
            }
            alertController.addAction(cancelAction)
        }
        
            self.present(alertController, animated: true) {
                // ...
            }
  
           
        })
        
        let DeleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            
        
            if  queueid != 0
            {
                let alertController = UIAlertController(title: "Delete Player", message: "Do you want to delete a player", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action) in
                     self.tblQueue.endEditing(true)
                }
                alertController.addAction(cancelAction)
                
                let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                    
                    self.editPlayers(queueid, function: "DeleteQueue", method: "POST")
                }
                alertController.addAction(yesAction)
                
                self.present(alertController, animated: true) {
                    // ...
                }
                
                
                
              
       
                
            }
            
        })
        
        
        let SkipAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Skip" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
           var alertController = UIAlertController()
        if editPlayerId == self.intLoginPlayerid
        {
           if  queueid != 0
           {
            
            alertController = UIAlertController(title: "Skip Player", message: "Do you want to Skip a player", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action) in
                self.tblQueue.endEditing(true)
            }
            alertController.addAction(cancelAction)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                
                 self.editPlayers(queueid, function: "SkipPlayer", method: "POST")
            }
            alertController.addAction(yesAction)
            
            
           
            
          
     
            }
        }
        else{
             alertController = UIAlertController(title: "Player Skip", message: "You cannot Skip another player", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Okay", style: .cancel) { (action) in
                // self.tblQueue.endEditing(true)
            }
            alertController.addAction(cancelAction)
            
        }
            self.present(alertController, animated: true) {
                // ...
            }
            
         
        })
        // 5
        if intSkill == 5
        {
            return [DeleteAction,SkipAction,SwapAction]
            
        }
        else
        {
          return [DeleteAction]
        }
        
        
 
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
     
        
        
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        //...
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       /* if segue.identifier == "segPlay"
        
        {
            let destinationVC = segue.destinationViewController as! Playview
            
            destinationVC.intClubid = intClubid
            destinationVC.intNoCourts = intNoCourts
        }*/
        
       
        
       
        
    }
    
    func DoSomething(_ arrSelectedPlayers:NSArray,intSelect:Int) {
        
        
        if intSelect == -1
        {
           /* arrayBeginner = ["Sumaiya","Sasi","Seetharaman","Sumaiya","Sasi","Seetharaman","Sumaiya","Sasi","Seetharaman"];
            arrayIntermediate = ["Saravanan","Zauffer","Ashok","Santosh","Saravanan","Zauffer","Ashok","Santosh"];
            arrayAdvance = ["Deena", "Karthik", "Suresh"];*/
        }
        else if intSelect == 3
        {
            arrayAdvance = arrSelectedPlayers as! [[String]]
        }
            
        else if intSelect == 2
        {
            arrayIntermediate = arrSelectedPlayers as! [[String]]
        }
        else if intSelect == 1
        {
            arrayBeginner = arrSelectedPlayers as! [[String]]
        }
        else if intSelect == 4
        {
            arrayAll = arrSelectedPlayers as! [[String]]
        }
        
        dataload()
        
        //tblQueue.reloadData()

     
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
          
            let alertView = UIAlertController(title: "Shuffle", message: "Do you want shuffle the players in this group?", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alertAction) -> Void in
                self.ShufflePlayers()
            }))
            alertView.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            present(alertView, animated: true, completion: nil)
        }
    }
    
    func ShufflePlayers()
    {
       
        
        switch (self.intSkill) {
        case 3:
           self.arrayAdvance.shuffleInPlace()
            tblQueue.reloadData()
        case 2:
            self.arrayIntermediate.shuffleInPlace()
            tblQueue.reloadData()
        case 1:
            self.arrayBeginner.shuffleInPlace()
            tblQueue.reloadData()
            //return sectionHeaderView
        default:
            self.arrayBeginner.shuffleInPlace()
            tblQueue.reloadData()
        }
   
        
    }
    
    
    @IBAction func btnQueueview(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "segPlay", sender: nil)
    }
    
        
    @IBAction func btnLogoff(_ sender: AnyObject) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        if  ((FBSDKAccessToken.current()) != nil)
        {
            fbLoginManager.logOut()
            
            
            
        }
        else if(prefs.bool(forKey: "ISLOGGEDIN") == true)
        {
            
            prefs.removeObject(forKey: "USERNAME")
            prefs.removeObject(forKey: "ISLOGGEDIN")
            prefs.removeObject(forKey: "Playerid")
            prefs.synchronize()
            
        }
        
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
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl1.isRefreshing {
            if !isAnimating {
                doSomething1()
                animateRefreshStep1()
            }
        }
    }
    
    
    func loadCustomRefreshContents() {
        let refreshContents = Bundle.main.loadNibNamed("Refresh", owner: self, options: nil)
        customView = refreshContents?[0] as! UIView
        customView.frame = refreshControl1.bounds
        //let cntSubview = customView.subviews.count + 1
        for i in 0 ..< customView.subviews.count  {
           
            labelsArray.append(customView.viewWithTag(i + 1) as! UILabel)
        }
        
        refreshControl1.addSubview(customView)
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
                        if self.refreshControl1.isRefreshing {
                            self.currentLabelIndex = 0
                            self.animateRefreshStep1()
                        }
                        else {
                            self.isAnimating = false
                            self.currentLabelIndex = 0
                            //let lblArrayCnt =
                            for i in 0 ..< self.labelsArray.count
                            {
                                self.labelsArray[i].textColor = UIColor.black
                                self.labelsArray[i].transform = CGAffineTransform.identity
                            }
                        }
                })
        })
    }
    
    func doSomething1() {
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(Queueview1.endOfWork), userInfo: nil, repeats: true)
        dataload()
      
    }
    
    func endOfWork() {
        refreshControl1.endRefreshing()
        
        timer.invalidate()
        timer = nil
    }
    
    func addLoadingIndicator () {
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
    }
    
    @IBAction func unwindToMenu(_ segue: UIStoryboardSegue) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       dataload()
        
    }
    
    func dataload()
    {
        self.arrayAll.removeAll()
        self.arrayIntermediate.removeAll()
        self.arrayBeginner.removeAll()
        self.arrayAdvance.removeAll()
        self.arrayWaiting.removeAll()
        addLoadingIndicator()
        activityIndicator.startAnimating()
        BadmintonQData.getData (url+"QueueMe/"+String(intClubid)  , success:{(iTunesData) -> Void in
            self.dictQueuedata = JSON(data: iTunesData!)
            
            
            
            // let json = JSON(data: dataFromNetworking)
            for (index, object) in self.dictQueuedata {
                
                if object["QStatusID"].stringValue == "4"
                {
                    self.arrayPlaying.append(object["PlayerName"].stringValue)
                }
                /*else if (object["QStatusID"].stringValue == "1" || object["QStatusID"].stringValue == "3")
                {
                 // self.arrayWaiting.append(object["PlayerName"].stringValue)
                    
                }*/
                else
                {
                    var row = [String]()
                    // self.arrayAll[Int(index)!][0] =
                    row.append(String(object["PlayerName"].stringValue))
                    row.append(self.GetStatus(Int(object["QStatusID"].stringValue)!))
                    
                    self.arrayWaiting.append(row)
                    

                    //self.arrayAll.append(object["PlayerName"].stringValue)
                    //self.arrayWaiting.append(object["PlayerName"].stringValue)
                  //  self.arrayWaiting[Int(index)!][0] = String([object["PlayerName"].stringValue])
                   // self.arrayWaiting[Int(index)!][1] = GetStatus(Int([object["QStatusID"].stringValue])!)
                    
                   
                }
                
            }
            
           
            
            
            DispatchQueue.main.async(execute: { () -> Void in
                // Show the alert
                self.tblQueue.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                //self.performSegueWithIdentifier("SegQueue", sender: nil)
            })
            
            // More soon...
        })
        
            BadmintonQData.getData (url+"Queue/"+String(intClubid)  , success:{(iTunesData) -> Void in
            self.dictWaitQueuedata = JSON(data: iTunesData!)
            
            self.arrayWaiting.removeAll()
            
            
            
            // let json = JSON(data: dataFromNetworking)
            for (index, object) in self.dictWaitQueuedata{
                
                if (object["QStatusID"].stringValue != "4")
                {
                    var row = [String]()
                   // self.arrayAll[Int(index)!][0] =
                    row.append(String(object["PlayerName"].stringValue))
                    row.append(self.GetStatus(Int(object["QStatusID"].stringValue)!))
                    
                    self.arrayAll.append(row)
                    

                
                
                
                    if object["SkillsetID"].stringValue == "1"
                    {
                        var row = [String]()
                        
                        row.append(String(object["PlayerName"].stringValue))
                        row.append(self.GetStatus(Int(object["QStatusID"].stringValue)!))
                        self.arrayBeginner.append(row)
                        
                        
                        
                    }
                        
                    else if object["SkillsetID"].stringValue == "2"
                    {
                        var row = [String]()
                        
                        row.append(String(object["PlayerName"].stringValue))
                        row.append(self.GetStatus(Int(object["QStatusID"].stringValue)!))
                        self.arrayIntermediate.append(row)
                       
                    }
                    else if object["SkillsetID"].stringValue == "3"
                    {
                        var row = [String]()
                        
                        row.append(String(object["PlayerName"].stringValue))
                        row.append(self.GetStatus(Int(object["QStatusID"].stringValue)!))
                        self.arrayAdvance.append(row)
                       
                        
                    }
                }
                }
            
            DispatchQueue.main.async(execute: { () -> Void in
                // Show the alert
                self.tblQueue.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                //self.performSegueWithIdentifier("SegQueue", sender: nil)
            })
            
            })
            
                
                
    }
    
        

       
       /* if (intSkill == 5 || self.arrayWaiting .isEmpty)
        {
        
        }*/
       
   
    func editPlayers(_ Queueid:Int,function:NSString,method:String)  {
       
        //print("url \(self.url+(function as String)+"/"+String(Queueid))")
        BadmintonQData.post([:],Method: method, url: url+(function as String)+"/"+String(Queueid)) { (succeeded: Bool, msg: String) -> () in
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
                self.dataload()
              //  self.tblQueue.reloadData()
            })
        }
 
        
    }
    
    
  /*  func findQueueid(searchstring:NSString, dict:JSON) -> (Int)
    {
    
        for (index,object) in dict
        {
            if object["PlayerName"].stringValue == searchstring
            {
                
              return object["QueueID"].int!
            }
        }
    
        return 0
    }*/
    

    func GetStatus(_ statusid:Int) -> String {
        switch statusid {
        case 1:
            return "Waiting"
        case 2:
            return "Next"
        case 3:
            return "Skipped"
        default:
            return ""
        }

    }
 


}



extension Queueview1: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}




