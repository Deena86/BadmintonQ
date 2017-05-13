//
//  Playerreport.swift
//  BadmintonQ
//
//  Created by Deenadayal Loganathan on 11/18/15.
//  Copyright © 2015 Deena. All rights reserved.
//

import UIKit

class Playerreport: UIViewController {
    @IBOutlet weak var imgProfile: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
       imgProfile.layer.cornerRadius = 60 //imgProfile.frame.size.width / 2;
        print("this raduis \(imgProfile.frame.size.width / 2)")
        imgProfile.layer.borderWidth = 3.0
        imgProfile.layer.borderColor = UIColor.white.cgColor
        imgProfile.clipsToBounds = true
        
        
       /* imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2;
        print("this raduis \(imgProfile.frame.size.width / 2)")
        
        imgProfile.layer.borderColor = UIColor.whiteColor().CGColor
        imgProfile.clipsToBounds = true
*/
       // self.imgProfile.layer.cornerRadius = 10.0;
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
