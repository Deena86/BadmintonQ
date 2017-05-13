//
//  LoginView.swift
//  BadmintonQ
//
//  Created by Deenadayal Loganathan on 10/11/15.
//  Copyright © 2015 Deena. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class LoginView: UIViewController,FBSDKLoginButtonDelegate,ValidationDelegate,UITextFieldDelegate {
    /*!
     @abstract Sent to the delegate when the button was used to login.
     @param loginButton the sender
     @param result The results of the login
     @param error The error (if any) from the login
     */


    var fbLoginSuccess = false
    
    
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var txtUsrNm: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var strLoginEmail:String = ""
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    let validator = Validator()
    let prefs = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        self.loginButton.delegate = self
        
      // self.btnLogin = self
       lblError.isHidden = true
        txtUsrNm.delegate = self
        txtPassword.delegate = self
    if (((FBSDKAccessToken.current()) != nil) || prefs.bool(forKey: "ISLOGGEDIN") == true)
        {
            // User is already logged in, do work such as go to next view controller.
            self.performSegue(withIdentifier: "segHome", sender: nil)
        }
        else
        {
            //self.performSegueWithIdentifier("segLogin", sender: nil)
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            // loginView.delegate = self
            self.view.addSubview(loginView)
            //loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            
            
            
            
            loginView.delegate = self
 

            //self.performSegueWithIdentifier("segLogin", sender: nil)
          /*  let loginView : FBSDKLoginButton = FBSDKLoginButton()
           // loginView.delegate = self
            self.view.addSubview(loginView)
            //loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
        
           
         
            
            loginView.delegate = self*/
          //  returnUserData()
            
            //self.performSegueWithIdentifier("segHome", sender: nil)
        }
        
       
        
     
        validator.registerField(txtUsrNm,errorLabel:lblError, rules: [RequiredRule(),EmailRule()])
        validator.registerField(txtPassword,errorLabel:lblError, rules: [RequiredRule(),PasswordRule()])
      
        
        
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
    }
    
   func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    if ((error) != nil) {
        // Process error
        print(error)
    }
    else if result.isCancelled {
        // Handle cancellations
    }
    else {
        fbLoginSuccess = true
        // If you ask for multiple permissions at once, you
        // should check if specific permissions missing
        if result.grantedPermissions.contains("email") {
            // Do work
        }
    }
    
    
   // self.performSegue(withIdentifier: "segHome", sender: nil)
   /* let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
    if (error == nil){
        let fbloginresult : FBSDKLoginManagerLoginResult = result!
        if fbloginresult.grantedPermissions != nil {
            if(fbloginresult.grantedPermissions.contains("email"))
            {
                self.getFBUserData()
                fbLoginManager.logOut()
            }
        }
    }
       // if  ((FBSDKAccessToken.current()) != nil) {
       // self.performSegue(withIdentifier: "segHome", sender: nil)
        //}*/
    }

    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if "segHome" == segue.identifier {
            print("test")
            // Nothing really to do here, since it won't be fired unless
            // shouldPerformSegueWithIdentifier() says it's ok. In a real app,
            // this is where you'd pass data to the success view controller.
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                   // self.dict = result as! [String : AnyObject]
                    print(result!)
                   // print(self.dict)
                }
            })
        }
    }
    
    @IBAction func btnLogin(_ sender: AnyObject) {
       // self.performSegue(withIdentifier: "segHome", sender: nil)
        
        /*let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }*/
       
        
       /* let loginView : FBSDKLoginButton = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.center = self.view.center
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
        
        // If we have an access token, then let's display some info
        
        if (FBSDKAccessToken.current() != nil)
        {
            // Display current FB premissions
            print (FBSDKAccessToken.current().permissions)
            
            // Since we already logged in we can display the user datea and taggable friend data.
            print("ts")
            //self.showUserData()
            //self.showFriendData()
        }*/
    }
    
    @IBAction func Login(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "segHome", sender: nil)
        print("test")
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
        
        
        //self.performSegueWithIdentifier("segHome", sender: nil)
        /*if ((FBSDKAccessToken.currentAccessToken()) != nil)
        {
            if self.strLoginEmail != ""
            {
                prefs.setObject(self.strLoginEmail, forKey: "Loginuser")
            }
        self.performSegueWithIdentifier("segHome", sender: nil)
        }
         returnUserData()
        self.performSegueWithIdentifier("segHome", sender: nil)*/
       
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: NSError!) {
       
      self.performSegue(withIdentifier: "segHome", sender: nil)
        
       
       // self.performSegueWithIdentifier("segHome", sender: nil)
        
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        
        
        
        
    }
    func imglogintapped(_ img:AnyObject)
    {
        
    }
    
    func validationSuccessful() {
        
      
        
        var Email:String="";
        
      
        
       var parm:NSString = ""
        
        if (txtUsrNm.text != "" || txtPassword.text != "")
        {
            Email = txtUsrNm.text!
             parm = "playerEmail=\(txtUsrNm.text!)&strPassword=\(txtPassword.text!)" as NSString
            self.strLoginEmail = txtUsrNm.text!
        }
       
        
        
        let result:(Bool,String) =  BadmintonQData.PostSync(url + "Login?playerEmail=\(txtUsrNm.text!)&strPassword=\(txtPassword.text!)" as NSString, parm: parm, username: Email as NSString)
        
        if result.0 == true
        {
            if self.strLoginEmail != ""
            {
                prefs.set(self.strLoginEmail, forKey: "Loginuser")
            }
            
          self.performSegue(withIdentifier: "segHome", sender: nil)
        }
        else
        {
            let alertscore = UIAlertController(title:"Login Failed!!!", message: result.1,preferredStyle: .alert)
            let okaction = UIAlertAction(title: "Okay", style: .default) { _ in
            }
            alertscore.addAction(okaction)
            
            self.present(alertscore, animated: true){}
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


    @IBAction func vtnFrgPass(_ sender: AnyObject) {
        
        
        let alertscore = UIAlertController(title:"Password reset!!!", message:"Password has been emailed",preferredStyle: .alert)
        let okaction = UIAlertAction(title: "Okay", style: .default) { _ in
        }
        alertscore.addAction(okaction)
        
        self.present(alertscore, animated: true){}
    }

    @IBAction func btnSignin(_ sender: AnyObject) {
        
         validator.validate(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current() != nil && fbLoginSuccess == true)
        {
            self.performSegue(withIdentifier: "segHome", sender: self)
        }
    }
    

    

    
    
    
   

}
 
