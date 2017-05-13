//
//  AddPlayer.swift
//  BadmintonQ
//
//  Created by Deenadayal Loganathan on 12/15/15.
//  Copyright © 2015 Deena. All rights reserved.
//

import UIKit

class AddPlayer: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,ValidationDelegate {
    
    @IBOutlet weak var txtName: UITextField!
  
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var txtPrfrnc: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtClub: UITextField!
    @IBOutlet var pickerClub: UIPickerView! = UIPickerView()
    var activeTextView: UITextField?
    let validator = Validator()
    var selClubid:Int=0
   // let url:String="http://ec2-52-91-103-107.compute-1.amazonaws.com/api/club"
    //let urlPost:String="http://ec2-52-91-103-107.compute-1.amazonaws.com/api/Player"
    var court = [String]();
    var courtid = [Int]();
    var Preference = ["Singles","Doubles"];
    var pickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
      
       lblError.isHidden = true
      
        self.pickerClub.delegate = self
        self.pickerClub.dataSource = self
        
        //txtClub.delegate = self
       // txtPrfrnc.text = Preference[0]
        //txtPrfrnc.delegate = self
       // pickerClub.delegate = self
       // txtClub.inputView = pickerView
       // txtPrfrnc.inputView = pickerView
        txtEmail.delegate = self
        txtName.delegate = self
        
        validator.registerField(txtName,errorLabel:lblError, rules: [RequiredRule()])
        validator.registerField(txtEmail,errorLabel:lblError, rules: [RequiredRule(),EmailRule()])
                
        
        
        validator.styleTransformers(success:{ (validationRule) -> Void in
            print("here")
            // clear error label
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            validationRule.textField.layer.borderColor = UIColor.green.cgColor
            validationRule.textField.layer.borderWidth = 0.5
            
            }, error:{ (validationError) -> Void in
                print("error")
                validationError.errorLabel?.isHidden = false
                validationError.errorLabel?.text = validationError.errorMessage
                validationError.textField.layer.borderColor = UIColor.red.cgColor
                validationError.textField.layer.borderWidth = 1.0
                
        })
        
       
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddPlayer.dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
      // let test = pkrClub.selectedRowInComponent(1)
        //print(test)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
        BadmintonQData.getData (url+"/club", success:{(iTunesData) -> Void in
            let json = JSON(data: iTunesData!)
            
            
            
            // let json = JSON(data: dataFromNetworking)
            for (index, object) in json {
                //print(index)
                print(object)
                self.court.append(object["ClubName"].stringValue)
                self.courtid.append(Int(object["ClubID"].intValue))
                //self.pkrPrfrnc.reloadAllComponents()
                // self.pkrClub.reloadAllComponents()
                // print(self.court)
                // self.txtClub.text = self.court[0]
                self.pickerClub.reloadAllComponents()
            }
            
            
            // More soon...
        })
        
        

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if (pickerView.tag == 10 )
        {
        
        return self.court.count
        }
        else if (pickerView.tag == 20)
        {
          return self.Preference.count
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 10)
        {
        
        return String(court[row])
        }
        else if (pickerView.tag == 20)
        {
           return String(Preference[row])
        }
        return "Select a Value"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if activeTextView == txtClub
        {
           activeTextView?.text = court[row]
           selClubid = courtid[row]
            print("clubid\(selClubid)")
        }
        else if activeTextView == txtPrfrnc
        {
            activeTextView?.text = Preference[row]
        }
    }
   func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
      
        let pickerLabel = UILabel()
        if (pickerView.tag == 10)
        {
           
            pickerLabel.textColor = UIColor.black
            pickerLabel.text = String(court[row])
            // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
            pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 15) // In this use your custom font
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
            
        }
        else if (pickerView.tag == 20)
        {
            
            pickerLabel.textColor = UIColor.black
            pickerLabel.text = String(Preference[row])
            // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
            pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 15) // In this use your custom font
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
            
        }
       
       return pickerLabel
    
    }
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        activeTextView = textField
        pickerView.reloadAllComponents()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
      //  pickerView.hidden = true
    }
    
    @IBAction func btnSubmit(_ sender: AnyObject) {
        
         validator.validate(self)
    }
    
    
      func validationSuccessful() {
        
        var Name:String = "";
        
        var Email:String="";
        
        var Preference:String="";
        var city:String="";
        var state:String="";
        var zipcode:Int=0;
        
        if txtName.text != ""
        {
            Name=txtName.text!
        }
        
        if txtEmail.text != ""
        {
            Email=txtEmail.text!
        }
       
            Preference="Doubles"
     
        
        
        
        
        BadmintonQData.post(["PlayerName":Name,"PlayerEmail":Email,"Phone":4575087,"Preference":Preference,"Username":"Name","Password":"test","LoginType":"IOS","DeviceID":UIDevice.current.identifierForVendor!.uuidString],Method: "POST", url: url + "/Player", Postcompleted:{ (succeeded: Bool, msg: String) -> () in
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
        })
        
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
    
    
    
    
  



}
