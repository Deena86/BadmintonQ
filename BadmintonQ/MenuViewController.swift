//
//  MenuViewController.swift
//  BadmintonQ
//
//  Created by Deenadayal Loganathan on 10/3/16.
//  Copyright © 2016 Deena. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController, GuillotineMenu {
    

    

    var dismissButton: UIButton?
    var titleLabel: UILabel?
    let prefs = UserDefaults.standard
    var intClubid:Int = 0
    var intNoCourts:Int = 0
    var srcController:NSString = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton = {
            let button = UIButton(frame: .zero)
            button.setImage(UIImage(named: "ic_menu"), for: .normal)
            button.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
            return button
        }()
       /* dismissButton = UIButton(frame: CGRect.zero)
        dismissButton.setImage(UIImage(named: "ic_menu"), for: UIControlState())
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)*/
        
       /* titleLabel = UILabel()
        titleLabel.numberOfLines = 1;
        titleLabel.text = "Menu"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()*/
        
        titleLabel = {
            let label = UILabel()
            label.numberOfLines = 1;
            label.text = "Menu"
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.textColor = UIColor.white
            label.sizeToFit()
            return label
        }()
        
        
        //let test UIViewController = Se
        
        if((prefs.object(forKey: "CLUBID")) != nil)
        {
            intClubid = prefs.integer(forKey: "CLUBID")
        }
        
        if((prefs.object(forKey: "NOCOURTS")) != nil)
        {
            intNoCourts = prefs.integer(forKey: "NOCOURTS")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnHome(_ sender: AnyObject) {
        if srcController == "Home"
        {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        else
        {
            self.performSegue(withIdentifier: "segHome", sender: self)
        }

    }
    
   
    @IBAction func btnCourtView(_ sender: AnyObject) {
        if srcController == "Court"
        {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        else
        {
            self.performSegue(withIdentifier: "segPlayView", sender: self)
        }
    }
    
 
    @IBAction func btnQueue(_ sender: AnyObject) {
        if srcController == "Queue"
        {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        else
        {
            self.performSegue(withIdentifier: "segQ", sender: self)
        }
    }
   
    @IBAction func btnClose(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func dismissButtonTapped(_ sende: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeMenu(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
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
extension MenuViewController: GuillotineAnimationDelegate {
    func animatorDidFinishPresentation(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishPresentation")
    }
    func animatorDidFinishDismissal(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishDismissal")
    }
    
    func animatorWillStartPresentation(_ animator: GuillotineTransitionAnimation) {
        print("willStartPresentation")
    }
    
    func animatorWillStartDismissal(_ animator: GuillotineTransitionAnimation) {
        print("willStartDismissal")
    }
}
