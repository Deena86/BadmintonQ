//
//  addClub.swift
//  BadmintonQ
//
//  Created by Deenadayal Loganathan on 12/13/15.
//  Copyright © 2015 Deena. All rights reserved.
//

import UIKit
import MessageUI


class addClub: UIViewController ,ValidationDelegate,UITextFieldDelegate{
    let court = ["1","2","3","4","5","6","7","8","9","10"]

    @IBOutlet weak var txtNoofCourt: UITextField!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var txtClubCntry: UITextField!
    @IBOutlet weak var txtClubZpCd: UITextField!
    @IBOutlet weak var txtClubSt: UITextField!
    @IBOutlet weak var txtClubCty: UITextField!
    @IBOutlet weak var txtClubAddrss: UITextField!
    @IBOutlet weak var txtOrganizeremailid: UITextField!
    @IBOutlet weak var txtOrganizernm: UITextField!
    @IBOutlet weak var txtClubname: UITextField!
    @IBOutlet weak var pkrClubno: UIPickerView!
    var activeField: UITextField?
    let url:String="http://ec2-52-91-103-107.compute-1.amazonaws.com/api/"
    var Noofcourts:Int=0
    let validator = Validator()
    override func viewDidLoad() {
        super.viewDidLoad()
        txtNoofCourt.delegate = self
        txtClubSt.delegate = self
        txtClubCty.delegate = self
        txtClubname.delegate = self
        txtClubZpCd.delegate = self
        txtOrganizernm.delegate = self
        
        lblError.isHidden = true
       // txtClubname.resignFirstResponder()
        validator.registerField(txtClubname,errorLabel:lblError, rules: [RequiredRule()])
        validator.registerField(txtOrganizeremailid,errorLabel:lblError, rules: [RequiredRule(),EmailRule()])
        validator.registerField(txtNoofCourt,errorLabel:lblError, rules: [RequiredRule(),NOofCourtRule()])
        
        
        
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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addClub.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  /*  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return court.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return court[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       // myLabel.text = pickerData[row]
       Noofcourts = Int(court[row])!
        
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        
        let pickerLabel = UILabel()
        
            pickerLabel.textColor = UIColor.blackColor()
            pickerLabel.text = String(court[row])
            // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
            pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 15) // In this use your custom font
            pickerLabel.textAlignment = NSTextAlignment.Center
            return pickerLabel
    
      
       
        
    }*/
    
    
    @IBAction func btnSubmit(_ sender: AnyObject) {
        
        
         validator.validate(self)
    }
    
    func validationSuccessful() {
      
        var clubname:String = "";
        
        var organizer:String="";
        var organizeremailid:String="";
        var streetnm:String="";
        var city:String="";
        var state:String="";
        var zipcode:Int=0;
        
        if txtClubname.text != ""
        {
            clubname=txtClubname.text!
        }
        
        if txtOrganizernm.text != ""
        {
            organizer=txtOrganizernm.text!
        }
        if txtOrganizeremailid.text != ""
        {
            organizeremailid=txtOrganizeremailid.text!
        }
        if txtClubAddrss.text != ""
        {
            streetnm=txtClubAddrss.text!
        }
        if txtClubCty.text != ""
        {
            city=txtClubCty.text!
        }
        if txtClubSt.text != ""
        {
            state=txtClubSt.text!
        }
        
        if txtClubZpCd.text != ""
        {
            zipcode=Int(txtClubZpCd.text!)!
        }
        
        if txtNoofCourt.text != ""
        {
            Noofcourts=Int(txtNoofCourt.text!)!
        }
       // NoOfCourts
        
        BadmintonQData.post(["ClubName":clubname,"NoOfCourts":1,"Organizer":organizer,"ClubEmail":organizeremailid,"StreetName":streetnm,"City":city,"State":state,"Zipcode":zipcode],Method: "POST", url: url + "/club") { (succeeded: Bool, msg: String) -> () in
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        activeField = nil
    }

}

class NOofCourtRule: RegexRule {
    
    static let regex = "^[0-9]{1}$"
    
    convenience init(message : String = "Not a valid CourtNo"){
        self.init(regex: NOofCourtRule.regex, message : message)
    }
}
