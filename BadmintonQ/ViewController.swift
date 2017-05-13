//
//  ViewController.swift
//  BadmintonQ
//
//  Created by Deenadayal Loganathan on 4/16/15.
//  Copyright (c) 2015 Deena. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit



class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ValidationDelegate{
    var clubname  :[String:(Int,Int)] = [:]
    var dictPlayerName :[String:Int] = [:]
    var dictPlayerSkill :[String:Int] = [:]
    let prefs = UserDefaults.standard
    var  selclubname :[String]=[]
    var selplayername : [String] = []
    var  autocompletetableview:UITableView=UITableView()
    let txtBadmintonclb = UITextField()  as UITextField!
    let btnAddClub=UIButton(type: UIButtonType.contactAdd)
    let txtPlayerNm = UITextField() as  UITextField!
    let lblError = UILabel() as UILabel
    let btnAddPlyr = UIButton(type: UIButtonType.contactAdd)
    let  itmSkill = ["Beginner","Intermediate","Advance"]
    var segSkill = UISegmentedControl() as UISegmentedControl
    let btnGetNQ  =  UIButton(type: UIButtonType.system)
    var intSkill:Int = 1;
    @IBOutlet weak var barButton: UIButton!
    var intClubid:Int = 0
    var intNoCourts:Int = 0
    var intPlayerid:Int = 0
    var segMenu:Int = 0
    let validator = Validator()
    var view_constraint_V:NSArray = NSArray()
    var strLoginEmail = ""
    var intLoginPlayerid:Int = 0
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
        
    lazy fileprivate var activityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "imgShuttle")!
        return CustomActivityIndicatorView(image: image)
    }()

    
    func numberOfSections(in tableView: UITableView) -> Int {
        do{
        return 1
        }
        catch
        {
            
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do{
        return   selclubname.count
        }
        catch{
            
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        do{
        var autofill : UITableViewCell?
        
        if  autofill  == nil
        {
            autofill = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "autofill")
        }
        
        autofill!.textLabel?.text  = selclubname[(indexPath as NSIndexPath).row]
       

        return   autofill!;
        }
        catch{
        
        }
    }
    
      override func viewDidLoad()
      {
        super.viewDidLoad()
        
       if  ((self.prefs.object(forKey: "Loginuser") == nil) && ((FBSDKAccessToken.current()) != nil))
       {
         getFBdata()
        }
       else if (self.prefs.object(forKey: "Loginuser") == nil) {
         if Commonutil.logoff() == true
         {
            self.performSegue(withIdentifier: "segLogoff", sender: nil)
         }
        
        }
        autocompletetableview.delegate=self
        autocompletetableview.dataSource=self
        autocompletetableview.isScrollEnabled=true

        txtBadmintonclb?.delegate=self
        txtPlayerNm?.delegate=self
        txtPlayerNm?.tag = 20
        txtBadmintonclb?.tag = 10
        autocompletetableview.isHidden=true
        self.view.addSubview(autocompletetableview)
        
        let navBar = self.navigationController!.navigationBar
        navBar.barTintColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1)
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
 
       
        
        btnAddClub.addTarget(self, action: #selector(ViewController.AddClub(_:)), for: UIControlEvents.touchUpInside)
        btnAddPlyr.addTarget(self, action: #selector(ViewController.AddPlyr(_:)), for: UIControlEvents.touchUpInside)
        btnGetNQ.addTarget(self, action: #selector(ViewController.GetinQueue(_:)), for: UIControlEvents.touchUpInside)
       

         segSkill  = UISegmentedControl(items: itmSkill)
    
   
        segSkill.selectedSegmentIndex =  0
        segSkill.addTarget(self, action: #selector(ViewController.changeSkill(_:)), for: .valueChanged)
        makeLayout()
        segSkill.setEnabled(false,forSegmentAt:0)
        segSkill.setEnabled(false,forSegmentAt:1)
        segSkill.setEnabled(false,forSegmentAt:2)
       // segSkill.selectedSegmentIndex =  0

        
        validator.registerField(txtPlayerNm!,errorLabel:lblError, rules: [RequiredRule()])
        validator.registerField(txtBadmintonclb!,errorLabel:lblError, rules: [RequiredRule()])
        
        
        
        validator.styleTransformers(success:{ (validationRule) -> Void in
            
            // clear error label
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            validationRule.textField.layer.borderColor = UIColor.green.cgColor
            validationRule.textField.layer.borderWidth = 0.5
            
            }, error:{ (validationError) -> Void in
                validationError.errorLabel?.isHidden = false
                validationError.errorLabel?.text = validationError.errorMessage
                validationError.textField.layer.borderColor = UIColor.red.cgColor
                validationError.textField.layer.borderWidth = 1.0
                
        })
        if prefs.object(forKey: "SelClubName") != nil
        {
            
           if String(describing: prefs.object(forKey: "SelClubName")!) == "Kimberton Badminton Club"
        {
            self.segSkill.setTitle("Intermediate", forSegmentAt: 0)
            self.segSkill.setTitle("Advance", forSegmentAt: 1)
            self.segSkill.setTitle("Elite", forSegmentAt: 2)
        }
        }
        
     
        
    }
    func  makeLayout()  {
     
        
        let viewsDictionary:[String:UIView] = ["txtBadmintonclb":txtBadmintonclb,"autocompletetableview":autocompletetableview,"btnAddClub":btnAddClub,"txtPlayerNm":txtPlayerNm,"btnAddPlyr":btnAddPlyr,"segSkill":segSkill,"btnGetNQ":btnGetNQ,"lblError":lblError] as [String : Any] as! [String : UIView]
        let metricsDictionary = ["txtviewHeight": 30,"txtviewWidth":80,"btnAddHeight":30.0,"btnAddWidth":10.0,"segSkillHeight":20,"segSkillWidth":80,"btnGetNQHeight":20,"btnGetNQWidth":60,"lblErrorHeight":20,"lblErrorWidth":60]
        
        txtPlayerNm?.translatesAutoresizingMaskIntoConstraints = false
        btnAddPlyr.translatesAutoresizingMaskIntoConstraints = false
        txtBadmintonclb?.translatesAutoresizingMaskIntoConstraints = false
        autocompletetableview.translatesAutoresizingMaskIntoConstraints = false
        btnAddClub.translatesAutoresizingMaskIntoConstraints = false
        segSkill.translatesAutoresizingMaskIntoConstraints = false
        btnGetNQ.translatesAutoresizingMaskIntoConstraints = false
       lblError.translatesAutoresizingMaskIntoConstraints = false
     
        view.addSubview(txtBadmintonclb!)
        view.addSubview(btnAddClub)
        view.addSubview(txtPlayerNm!)
        view.addSubview(btnAddPlyr)
        view.addSubview(segSkill)
        view .addSubview(btnGetNQ)
        view.addSubview(lblError)
        txtBadmintonclb?.placeholder="Enter your Club"
        txtBadmintonclb?.borderStyle=UITextBorderStyle.roundedRect
        txtPlayerNm?.placeholder="Enter your Name"
        txtPlayerNm?.borderStyle=UITextBorderStyle.roundedRect
        btnGetNQ.setTitle("Get in the Queue", for: UIControlState())
        lblError.text = "error message here"
        lblError.textAlignment = NSTextAlignment.center
        lblError.textColor = UIColor.red
        let textField_H:Array = NSLayoutConstraint.constraints(withVisualFormat: "H:[txtBadmintonclb(>=txtviewWidth@20)]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        let textField_V:Array = NSLayoutConstraint.constraints(withVisualFormat: "V:[txtBadmintonclb(<=txtviewHeight)]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        let textFieldPlyr_H:Array = NSLayoutConstraint.constraints(withVisualFormat: "H:[txtPlayerNm(>=txtviewWidth@20)]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        let textFieldPlyr_V:Array = NSLayoutConstraint.constraints(withVisualFormat: "V:[txtPlayerNm(<=txtviewHeight)]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        
        let btnaddClub_H:Array = NSLayoutConstraint.constraints(withVisualFormat: "H:[btnAddClub(>=btnAddWidth)]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        let btnaddClub_V:Array = NSLayoutConstraint.constraints(withVisualFormat: "V:[btnAddClub(<=btnAddHeight)]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        
        let btnaddPlyr_H:Array = NSLayoutConstraint.constraints(withVisualFormat: "H:[btnAddPlyr(>=btnAddWidth)]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        let btnaddPlyr_V:Array = NSLayoutConstraint.constraints(withVisualFormat: "V:[btnAddPlyr(<=btnAddHeight)]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        
        let segSkill_H:Array = NSLayoutConstraint.constraints(withVisualFormat: "H:[segSkill(>=segSkillWidth@20)]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        let segSkill_V:Array = NSLayoutConstraint.constraints(withVisualFormat: "V:[segSkill(<=segSkillHeight)]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        
        let  btnGetNQ_H:Array = NSLayoutConstraint.constraints(withVisualFormat: "H:[btnGetNQ(>=btnGetNQWidth@20)]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        let btnGetNQ_V:Array = NSLayoutConstraint.constraints(withVisualFormat: "V:[btnGetNQ(<=btnGetNQHeight)]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        
        let  lblError_H:Array = NSLayoutConstraint.constraints(withVisualFormat: "H:[lblError(>=lblErrorWidth@20)]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        let lblError_V:Array = NSLayoutConstraint.constraints(withVisualFormat: "V:[lblError(<=lblErrorHeight)]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        
        
       view.addConstraints(textField_H)
       view.addConstraints(textField_V)
       view.addConstraints(btnaddClub_H)
        view.addConstraints(btnaddClub_V)
        view.addConstraints(textFieldPlyr_H)
        view.addConstraints(textFieldPlyr_V)
        view.addConstraints(btnaddPlyr_H)
        view.addConstraints(btnaddPlyr_V)
        view.addConstraints(segSkill_H)
        view.addConstraints(segSkill_V)
        view .addConstraints(btnGetNQ_H)
       view.addConstraints(btnGetNQ_V)
       view.addConstraints(lblError_H)
        view.addConstraints(lblError_V)

    let view_constraint_H:NSArray = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[txtBadmintonclb]-[btnAddClub]-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: viewsDictionary) as NSArray
        let view_constraintPlyr_H:NSArray = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[txtPlayerNm]-[btnAddPlyr]-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: viewsDictionary) as NSArray
        
        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation
        if orientation.isLandscape {
           view_constraint_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[txtBadmintonclb]-20-[txtPlayerNm]-20-[segSkill]-10-[btnGetNQ]-20-[lblError]", options: NSLayoutFormatOptions.alignAllLeading, metrics: nil, views: viewsDictionary) as NSArray
            
        } else {
          
            view_constraint_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[txtBadmintonclb]-70-[txtPlayerNm]-70-[segSkill]-30-[btnGetNQ]-30-[lblError]", options: NSLayoutFormatOptions.alignAllLeading, metrics: nil, views: viewsDictionary) as NSArray
        }
        
        
        let seg_constraint_H:NSArray = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[segSkill]-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: viewsDictionary) as NSArray
        let btnGetNQ_constraint_H:NSArray = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[btnGetNQ]-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: viewsDictionary) as NSArray
        let lblError_constraint_H:NSArray = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[lblError]-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: viewsDictionary) as NSArray
        
        view.addConstraints(view_constraint_H as! [NSLayoutConstraint])
       view.addConstraints(view_constraint_V as! [NSLayoutConstraint])
         view.addConstraints(view_constraintPlyr_H as! [NSLayoutConstraint])
        view.addConstraints(seg_constraint_H as! [NSLayoutConstraint])
         view.addConstraints(btnGetNQ_constraint_H as! [NSLayoutConstraint])
        view.addConstraints(lblError_constraint_H as! [NSLayoutConstraint])
        
        lblError.isHidden = true

        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Your Menu View Controller vew must know the following data for the proper animatio
       
        if (segue.identifier == "segQ")
        {
            
            let destinationVC = segue.destination as! UINavigationController
            let targetController = destinationVC.viewControllers[0] as! Queueview1
            targetController.intSkill = intSkill
            targetController.intClubid = intClubid
            targetController.intNoCourts = intNoCourts
            targetController.intLoginPlayerid = intLoginPlayerid
        }
    }
    
    func  searchAutocompleteEntriesWithSubstring(_ substring:NSString, tag:Int){
        selclubname.removeAll()
     

        var  index:NSRange?
        if tag == 10
        {
        for (clubnm,clubid) in clubname
        {
            let  str:NSString? = NSString(utf8String: clubnm)
            index =     str!.range(of: substring as String, options: NSString.CompareOptions.caseInsensitive)
            if (index?.location == 0)
            {
                selclubname.append(clubnm)
                
            }
        }
        }
        else if tag == 20
        {
            for (playnm,playerid) in dictPlayerName
            {
                let  str:NSString? = NSString(utf8String: playnm)
                index =     str!.range(of: substring as String, options: NSString.CompareOptions.caseInsensitive)
                if (index?.location == 0)
                {
                    selclubname.append(playnm)
                    
                }
            }
        }
       
        autocompletetableview.reloadData()
    }
    
    func   textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        

        if textField.tag == 10 {
            
            if (UIDevice.current.orientation.isLandscape) {
                autocompletetableview.frame=CGRect(x: 0, y: 50, width: 320, height: 100)
            }
            else{
            autocompletetableview.frame=CGRect(x: 0, y: 90, width: 320, height: 140)
            }
            self.searchAutocompleteEntriesWithSubstring((textField.text!+string  as NSString),tag: Int(textField.tag))
        }
        
        else if textField.tag == 20
        {
           
            if (UIDevice.current.orientation.isLandscape) {
                autocompletetableview.frame=CGRect(x: 0, y: 140, width: 320, height: 140)
            }
            else{
            autocompletetableview.frame=CGRect(x: 0, y: 180, width: 320, height: 140)
            }
           self.searchAutocompleteEntriesWithSubstring((textField.text!+string  as NSString),tag: Int(textField.tag))
        }
        
       autocompletetableview.isHidden=false
       
       
        //self.searchAutocompleteEntriesWithSubstring((textField.text!+string  as NSString))
        return  true;
        
       
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let  selectedcell:UITableViewCell=tableView.cellForRow(at: indexPath)!

        
        prefs.set(1, forKey: "ISLOGGEDIN")
        
        prefs.synchronize()
        
        if txtBadmintonclb?.isEditing == true
        {
           self.txtBadmintonclb?.text = selectedcell.textLabel!.text;
           prefs.set(selectedcell.textLabel!.text, forKey: "SelClubName")
            Getclubid(String(validatingUTF8: selectedcell.textLabel!.text!)!)
            
         
            
        }
        else if txtPlayerNm?.isEditing == true
        {
            self.txtPlayerNm?.text = selectedcell.textLabel!.text;
            prefs.set(selectedcell.textLabel!.text, forKey: "SelPlayerName")
            
            for (playnm,playerid) in dictPlayerName
            {
                if playnm == String(selectedcell.textLabel!.text!)
                {
                    intPlayerid = playerid
                    
                    //prefs.setInteger(intPlayerid, forKey: "SELPLAYERID")
                }
            }
            
            for (playnm,skilset) in dictPlayerSkill
            {
                if playnm == String(selectedcell.textLabel!.text!)
                {
                    //intPlayerid = playerid
                    if Int(skilset-1) != -1
                    {
                        intSkill = skilset
                    segSkill.selectedSegmentIndex = Int(skilset-1)
                    prefs.set(Int(skilset-1), forKey: "SEGSKILL")
                    
                    }
                    else{
                        if intClubid == 23
                        {
                        segSkill.setEnabled(true,forSegmentAt:0)
                        segSkill.setEnabled(true,forSegmentAt:1)
                        segSkill.setEnabled(true,forSegmentAt:2)
                        }
 
                    }
                    //prefs.setInteger(intPlayerid, forKey: "SELPLAYERID")
                }
            }
        
        }
        
        if intClubid == 23
        {
            segSkill.setTitle("Intermediate", forSegmentAt: 0)
            segSkill.setTitle("Advance", forSegmentAt: 1)
            segSkill.setTitle("Elite", forSegmentAt: 2)
        }
        else
        {
            segSkill.setTitle("Beginner", forSegmentAt: 0)
            segSkill.setTitle("Intermediate", forSegmentAt: 1)
            segSkill.setTitle("Advance", forSegmentAt: 2)
            segSkill.setEnabled(true,forSegmentAt:0)
            segSkill.setEnabled(true,forSegmentAt:1)
            segSkill.setEnabled(true,forSegmentAt:2)
        }
        
        autocompletetableview.isHidden=true;
    }
    
    
    @IBAction func btnMenu(_ sender: AnyObject) {
        
        if intClubid == 0
        {
        
        let alertscore = UIAlertController(title:"Select a Club!!!", message:"Please select a Club",preferredStyle: .alert)
        let okaction = UIAlertAction(title: "Okay", style: .default) { _ in
        }
        alertscore.addAction(okaction)
        self.present(alertscore, animated: true){}
            return
        }
        
        
        let menuViewController = storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
        menuViewController.modalPresentationStyle = .custom
        menuViewController.transitioningDelegate = self
        
        presentationAnimator.animationDelegate = menuViewController as? GuillotineAnimationDelegate
        presentationAnimator.supportView = navigationController!.navigationBar
        presentationAnimator.presentButton = sender as! UIView
        presentationAnimator.srcControllerNm = "Home"
        present(menuViewController, animated: true, completion: nil)
    
       /* let menuVC = storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
        menuVC.modalPresentationStyle = .custom
        menuVC.transitioningDelegate = self
        if menuVC is GuillotineAnimationDelegate {
            presentationAnimator.animationDelegate = menuVC as? GuillotineAnimationDelegate
        
        }
        presentationAnimator.supportView = self.navigationController?.navigationBar
        presentationAnimator.presentButton = sender as! UIView
        presentationAnimator.srcControllerNm = "Home"
       // presentationAnimator.duration = 0.6
        self.present(menuVC, animated: true, completion: nil)*/

        
    }
    func GetinQueue(_ sender:UIButton)
    {
        
       
        
        validator.validate(self)
        
       
    }
    
    func AddClub(_ sender:UIButton)
    {
        self.performSegue(withIdentifier: "segAddClub", sender: nil)
    }
    
    func AddPlyr(_ sender:UIButton)
    {
        self.performSegue(withIdentifier: "segAddPlyr", sender: nil)
    }
    
    func changeSkill(_ sender: AnyObject) {
        
            intSkill = segSkill.selectedSegmentIndex+1
          //  prefs.setInteger(intSkill, forKey: "SEGSKILL")
    }
    
    
   
    
    @IBAction func btnLogoff(_ sender: AnyObject) {
       // self.performSegueWithIdentifier("segLogoff", sender: nil)
     /*   let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
       if  ((FBSDKAccessToken.currentAccessToken()) != nil)
       {
        fbLoginManager.logOut()
        
       
        
        
        
        }
        else if(prefs.boolForKey("ISLOGGEDIN") == true)
       {
       
        prefs.removeObjectForKey("USERNAME")
        prefs.removeObjectForKey("ISLOGGEDIN")
        prefs.removeObjectForKey("Playerid")
        prefs.synchronize()
        
        }*/
        
        
        
        if Commonutil.logoff() == true
        {
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
    func addLoadingIndicator () {
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // navigationItem.title = "One"
        
        addLoadingIndicator()
        activityIndicator.startAnimating()

        
        BadmintonQData.getData (url+"Club", success:{(iTunesData) -> Void in
            let json = JSON(data: iTunesData!)
            
            
            
            // let json = JSON(data: dataFromNetworking)
            for (index, object) in json {
                // self.clubname.append(object["ClubName"].stringValue)
                self.clubname[object["ClubName"].stringValue] = (Int(object["ClubID"].stringValue)!,Int(object["NoOfCourts"].stringValue)!)
                }
            
            if (self.prefs.object(forKey: "SelClubName") != nil) {
                
                
                self.Getclubid(String(validatingUTF8: String(describing: self.prefs.object(forKey: "SelClubName")!))!)
                
            }
            
            
             // More soon...
        })
        
     
        BadmintonQData.getData (url+"Player", success:{(iTunesData) -> Void in
            let json = JSON(data: iTunesData!)
            if (self.prefs.object(forKey: "Loginuser") != nil)
            {
             self.intLoginPlayerid = Commonutil.findLoginPlayerid(self.prefs.object(forKey: "Loginuser")! as! NSString, dict: json)
            }
            
            for (index, object) in json {
                self.dictPlayerName[object["PlayerName"].stringValue] = Int(object["PlayerID"].stringValue)
                self.dictPlayerSkill[object["PlayerName"].stringValue] = Int(object["SkillsetID"].stringValue)
            }
            
            if (self.prefs.object(forKey: "SelClubName") != nil) {
                
                
                self.Getclubid(String(validatingUTF8: String(describing: self.prefs.object(forKey: "SelClubName")!))!)
             
            }
            
            
            
            
            DispatchQueue.main.async(execute: { () -> Void in
                // Show the alert
                
                
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                //self.performSegueWithIdentifier("SegQueue", sender: nil)
            })
        })
        
        
       // txtBadmintonclb.text = ""
       // txtPlayerNm.text = ""
        
        if (prefs.object(forKey: "SelClubName") != nil) {
           
            txtBadmintonclb?.text = String(describing: prefs.object(forKey: "SelClubName")!)
            Getclubid(String(validatingUTF8: String(describing: prefs.object(forKey: "SelClubName")!))!)
          

        }
        
        if (prefs.object(forKey: "SelPlayerName") != nil) {
            txtPlayerNm?.text = String(describing: prefs.object(forKey: "SelPlayerName")!)
        }
        
        segSkill.selectedSegmentIndex = prefs.integer(forKey: "SEGSKILL")
        intSkill = prefs.integer(forKey: "SEGSKILL") + 1
       
        
        
        

       
    }
    
    @IBAction func cancelToPlayersViewController(_ segue:UIStoryboardSegue)
    {
       
    }
    
    @IBAction func savePlayerDetail(_ segue:UIStoryboardSegue)
    {
        
    }
    
    func validationSuccessful() {
       
        
        if txtBadmintonclb?.text != ""
            
        {
            Getclubid(String(describing: txtBadmintonclb?.text!))
            
        }
        
        if txtPlayerNm?.text != ""
            
        {
            for (playnm,playerid) in dictPlayerName
            {
                if playnm == txtPlayerNm?.text!
                {
                    intPlayerid = playerid
                }
            }
            
        }
        
        
        if (intClubid == 0 || intPlayerid == 0)
        {
            let alertscore = UIAlertController(title:"Configure!!!", message:"Player or Club has not been configured",preferredStyle: .alert)
            let okaction = UIAlertAction(title: "Okay", style: .default) { _ in
            }
            alertscore.addAction(okaction)
            
            self.present(alertscore, animated: true){}
        }
        
        else{
        
            do{
                
            
         try
        BadmintonQData.post(["ClubID":intClubid,"PlayerID":intPlayerid,"SkillsetID":intSkill,"Score":0,"QStatusID":1],Method: "POST", url: url+"Queue") { (succeeded: Bool, msg: String) -> () in
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
                alert.show()
            })
        }
        
            }
            
            catch
            {
              let alert = UIAlertView(title: "Success!", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "Okay.")
                alert.title = "Failed"
                alert.message = error.localizedDescription
                alert.show()
            }
        self.performSegue(withIdentifier: "segQ", sender: nil)
        }
    }
    func validationFailed(_ errors:[UITextField:ValidationError]) {
        // turn the fields to red
        for (field, error) in validator.errors {
            field.layer.borderColor = UIColor.red.cgColor
            field.layer.borderWidth = 1.0
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
         let viewsDictionary = ["txtBadmintonclb":txtBadmintonclb,"autocompletetableview":autocompletetableview,"btnAddClub":btnAddClub,"txtPlayerNm":txtPlayerNm,"btnAddPlyr":btnAddPlyr,"segSkill":segSkill,"btnGetNQ":btnGetNQ,"lblError":lblError] as [String : Any]
        if (UIDevice.current.orientation.isLandscape) {
            // ----- Landscape -----
            view.removeConstraints(view_constraint_V as! [NSLayoutConstraint])
           // view.removeConstraints(view_constraint_H2 as! [NSLayoutConstraint])
            if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.compact) {
                // --- Compact ---
               view_constraint_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-60-[txtBadmintonclb]-60-[txtPlayerNm]-60-[segSkill]-20-[btnGetNQ]-20-[lblError]", options: NSLayoutFormatOptions.alignAllLeading, metrics: nil, views: viewsDictionary) as NSArray
               
            }
            else {
                // --- Large ---
                view_constraint_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[txtBadmintonclb]-70-[txtPlayerNm]-70-[segSkill]-30-[btnGetNQ]-30-[lblError]", options: NSLayoutFormatOptions.alignAllLeading, metrics: nil, views: viewsDictionary) as NSArray
            }
            view.addConstraints(view_constraint_V as! [NSLayoutConstraint])
            
        }
        else {
            // ----- Portrait -----
             view.removeConstraints(view_constraint_V as! [NSLayoutConstraint])
            
            if (view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.compact) {
                // --- Compact ---
                view_constraint_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[txtBadmintonclb]-70-[txtPlayerNm]-70-[segSkill]-30-[btnGetNQ]-30-[lblError]", options: NSLayoutFormatOptions.alignAllLeading, metrics: nil, views: viewsDictionary) as NSArray
            } else {
                // --- Large ---
              view_constraint_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[txtBadmintonclb]-70-[txtPlayerNm]-70-[segSkill]-30-[btnGetNQ]-30-[lblError]", options: NSLayoutFormatOptions.alignAllLeading, metrics: nil, views: viewsDictionary) as NSArray
            }
            view.addConstraints(view_constraint_V as! [NSLayoutConstraint])
          
            
        }
        
    }
    
    func Getclubid(_ strClubname:String) {
        for (clubnm,clubid) in clubname
        {
            
            if clubnm == strClubname
            {
                intClubid = clubid.0
                intNoCourts = clubid.1
                
                

                prefs.set(intClubid, forKey: "CLUBID")
                prefs.set(intNoCourts, forKey: "NOCOURTS")
            }
        }
        
    }
    
    
    
    func returnUserData()
    {
        
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).start(completionHandler: { (connection, result , error) -> Void in
                if (error == nil){
                    
                    //let a = (result as! NSDictionary).value(forKey: "test")
                    
                    self.strLoginEmail = ((result as! NSDictionary).value(forKey: "email") as? NSString)! as String
                    self.prefs.set(self.strLoginEmail, forKey: "Loginuser")
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        // Show the alert
                        
                        //self.performSegueWithIdentifier("SegQueue", sender: nil)
                    })
                }
            })
        }
        
        /* let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath:  "me", parameters: nil)
         graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
         
         if ((error) != nil)
         {
         // Process error
         print("Error: \(error)")
         }
         else
         {
         
         
         self.strLoginEmail = (result.valueForKey("email") as? String)!
         
         
         }
         
         })*/
        
        
    }
    func getFBdata()  {
        if((FBSDKAccessToken.current()) != nil){
            
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                   // print(result.value(forKey: "email") as? String)
                    self.strLoginEmail = ((result as! NSDictionary).value(forKey: "email") as? String)!
                    self.prefs.set(self.strLoginEmail, forKey: "Loginuser")
                    
                    DispatchQueue.main.async(execute: {
                        
                        // self.performSegueWithIdentifier("Home", sender:self)
                        
                    })
                    
                    
                }
            })
        }
        
    }
    
  
    
    
    
    
    

}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}











