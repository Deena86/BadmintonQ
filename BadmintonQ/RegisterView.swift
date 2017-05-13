//
//  RegisterView.swift
//  BadmintonQ
//
//  Created by Deenadayal Loganathan on 4/2/16.
//  Copyright © 2016 Deena. All rights reserved.
//

import UIKit

class RegisterView: UIViewController,ValidationDelegate,UITextFieldDelegate {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtConfrmPassword: UITextField!
    @IBOutlet weak var lblError: UILabel!
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblError.isHidden = true
        txtConfrmPassword.delegate = self
        txtPassword.delegate = self
        txtEmail.delegate = self
        txtName.delegate = self
        
      
        validator.registerField(txtName,errorLabel:lblError, rules: [RequiredRule()])
        validator.registerField(txtEmail,errorLabel:lblError, rules: [RequiredRule(),EmailRule()])
        validator.registerField(txtPassword,errorLabel:lblError, rules: [RequiredRule(),PasswordRule()])
        validator.registerField(txtConfrmPassword,errorLabel:lblError, rules: [RequiredRule(),PasswordRule()])
        
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnRegister(_ sender: AnyObject) {
        
       validator.validate(self)
      self.performSegue(withIdentifier: "segLogin", sender: nil)
    }
    
    func validationSuccessful() {
        
        var Name:String = "";
        
        var Email:String="";
      
        var Password:String="";
        
        if txtName.text != ""
        {
            Name=txtName.text!
        }
        
        if txtEmail.text != ""
        {
            Email=txtEmail.text!
        }
        if (txtPassword.text != "" || txtPassword.text == txtConfrmPassword.text)
        {
            Password = txtPassword.text!
        }
        
        

        
        BadmintonQData.post(["PlayerName":Name,"PlayerEmail":Email,"Phone":1111111,"Preference":"Doubles","LoginType":"test","Username":Name,"Password":Password,"DeviceID":UIDevice.current.identifierForVendor!.uuidString],Method: "POST", url: url + "/Player") { (succeeded: Bool, msg: String) -> () in
            let alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
            print("test \(succeeded)")
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
    
    func validationFailed(_ errors:[UITextField:ValidationError]) {
        // turn the fields to red
        for (field, error) in validator.errors {
            field.layer.borderColor = UIColor.red.cgColor
            field.layer.borderWidth = 1.0
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
