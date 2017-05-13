//
//  Common.swift
//  BadmintonQ
//
//  Created by Deenadayal Loganathan on 12/20/15.
//  Copyright © 2015 Deena. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
let prefs = UserDefaults.standard

class Commonutil{
   class func findKeyForValue(_ value: String, dictionary: [String: [String]]) ->String?
    {
        for (key, array) in dictionary
        {
            if (array.contains(value))
            {
                return key
            }
        }
        
        return nil
    }
    
    class func findQueueid(_ searchstring:NSString, dict:JSON) -> (Int)
    {
        
        for (index,object) in dict
        {
            if object["PlayerName"].stringValue == searchstring as String
            {
                
                return object["QueueID"].int!
            }
        }
        
        return 0
    }
    
    class func findPlayerid(_ searchstring:NSString, dict:JSON) -> (Int)
    {
        
        for (index,object) in dict
        {
            if object["PlayerName"].stringValue == searchstring as String
            {
                
                return object["PlayerID"].int!
            }
        }
        
        return 0
    }
    
    class func findLoginPlayerid(_ searchstring:NSString, dict:JSON) -> (Int)
    {
        
        for (index,object) in dict
        {
            if object["PlayerEmail"].stringValue == searchstring as String
            {
                
                return object["PlayerID"].int!
            }
        }
        
        return 0
    }

    
    class func isStringNumerical(_ string : String) -> Bool {
        // Only allow numbers. Look for anything not a number.
        if (string != "")
        {
        let range = string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted)
        return (range == nil)
        }
        else{
          return false
        }
    }
    
    enum BadmintonQError:Error {
        case invalidData
        case invalidResponse
        case invalidUrl
    }
    
    class func logoff() -> Bool {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        if  ((FBSDKAccessToken.current()) != nil)
        {
            fbLoginManager.logOut()
            prefs.removeObject(forKey: "Loginuser")
            prefs.synchronize()
            
            return true
            
            
            
        }
        else if(prefs.bool(forKey: "ISLOGGEDIN") == true)
        {
            
            prefs.removeObject(forKey: "USERNAME")
            prefs.removeObject(forKey: "ISLOGGEDIN")
            prefs.removeObject(forKey: "Playerid")
            prefs.removeObject(forKey: "Loginuser")
            prefs.synchronize()
            return true
            
        }
        
       return false
    }
    
    

    
    
 
}
extension Collection {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
    
   
}

extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        let a:Int = Int(count.toIntMax())
        
        for i in 0..<a-1 {
            print("test \(i)")
            let j = Int(arc4random_uniform(UInt32(a - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
       /* for i in 0..< a
        {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])

        }*/
    }
}


