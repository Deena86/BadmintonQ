//
//  BadmintonQData.swift
//  BadmintonQ
//
//  Created by Deenadayal Loganathan on 12/11/15.
//  Copyright © 2015 Deena. All rights reserved.
//Demo@gmail.comDe

import Foundation

//let url:String="http://ec2-54-163-138-67.compute-1.amazonaws.com/BadminQProd/api/"
//http://ec2-54-163-138-67.compute-1.amazonaws.com/BadminQTest

    //let url:String = "http://dualstack.ec2-54-163-138-67.compute-1.amazonaws.com/BadminQProd/api"
    let url:String =  "http://dualstack.BadmintonQPRod-1950243207.us-east-1.elb.amazonaws.com/BadminQProd/api/"
class BadmintonQData{
    class func post(_ params : NSDictionary,Method:String, url : String, Postcompleted : @escaping (_ succeeded: Bool, _ msg: String)  -> ()) throws {
        let request = NSMutableURLRequest(url: URL(string: url)!)
        //var response: NSURLResponse?
        let session = URLSession.shared
        request.httpMethod = Method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
   
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        
      
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard data != nil else {
                print("no data found: \(String(describing: error))")
               // throw Commonutil.BadmintonQError.invalidData
                return
            }
            
            // this, on the other hand, can quite easily fail if there's a server error, so you definitely
            // want to wrap this in `do`-`try`-`catch`:
            
            do {
                if let httpResponse = response as? HTTPURLResponse {
                    print("error \(httpResponse.statusCode)")
                    if (httpResponse.statusCode != 201 && httpResponse.statusCode != 200)
                    {
                        let success = false
                       Postcompleted(success, error as! String)
                    }
                }
                if (try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary) != nil {
                    let success = true //json["success"] as? Int                                  // Okay, the `json` is here, let's get the value for 'success' out of it
                    Postcompleted(success, "Data Uploaded.")
                } else {
                    _ = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)    // No error thrown, but not NSDictionary
                    let success = false
                    Postcompleted(success, error as! String)
                }
            } catch let parseError {
                print(parseError)                                                          // Log the error thrown by `JSONObjectWithData`
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Error could not parse JSON: '\(String(describing: jsonStr))'")
            }
        }) 
        
        task.resume()
    }
    
    class func getData(_ URL:String,success: @escaping ((_ appData: Data?) -> Void))  {
        //1
        do {
            try   loadDataFromURL(Foundation.URL(string: URL)!, completion:{(data, error)  -> Void in
                //2
                guard let urlData = data else{
                    //3
                   // throw Commonutil.BadmintonQError.invalidData
                    print("test")
                    return
                }
                success(urlData)
            })
        } catch let error {
            print("test \(error)")
        }
      
    }
    
    class func loadDataFromURL(_ url: URL, completion:@escaping (_ data: Data?, _ error: NSError?) -> Void) {
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do
        {
            
        try
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if let responseError = error {
                completion(nil, responseError as NSError?)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    let statusError = NSError(domain:"com.amazon", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(nil, statusError)
                } else {
                    completion(data, nil)
                }
            }
            }.resume()
        }
        catch let error
        {
            
        }
        
          }
    
    
    class func PostSync(_ url:NSString,parm:NSString,username:NSString) -> (login:Bool,errormsg:String){
        
        do {
            
            
        
            
            let url:URL = URL(string: url as String)!
                       let request:NSMutableURLRequest = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: URLResponse?
            
            var urlData: Data?
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response)
            } catch let error as NSError {
                reponseError = error
                return (false,error.localizedDescription)
                //urlData = nil
            }
            
            if ( urlData != nil ) {
                let res = response as! HTTPURLResponse!;
                
                //NSLog("Response code: %ld", res?.statusCode);
                
                if ((res?.statusCode)! >= 200 && (res?.statusCode)! < 300)
                {
                    let responseData:NSString  = NSString(data:urlData!, encoding:String.Encoding.utf8.rawValue)!
                    
                    //NSLog("Response ==> %@", responseData);
                    let Playerid:Int = Int(responseData as String)!
                    
                    if(Playerid != 0)
                    {
                        NSLog("Login SUCCESS");
                        
                        let prefs:UserDefaults = UserDefaults.standard
                        prefs.set(username, forKey: "USERNAME")
                        prefs.set(1, forKey: "ISLOGGEDIN")
                        prefs.set(Playerid, forKey: "Playerid")
                        prefs.synchronize()
                        return (true,"Sucess")
                        
                    } else {
                        let _:NSString = "Credentials incorrect"
           
                        return (false,"Credetials incorrect")
                    }
                    
                } else {
                    return (false,"Invalid Response, Contact administrator ")
                }
            } else {
                    return (false,"Bad Network, Contact administrator ")
            }
        } catch {
            return (false,"Post Failed,Contact administrator")
        }
        
      // return (false, "Call failure,Contact administrator")
    }
    
    
   /* class func GetSync(_ url:NSString) -> Bool {
        
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: URL(string: url as String)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            if let error = error {
                print(error)
               
            }
            if let data = data{
                print("data =\(data)")
            }
            if let response = response {
                print("url = \(response.url!)")
                print("response = \(response)")
                let httpResponse = response as! HTTPURLResponse
                print("response code = \(httpResponse.statusCode)")
                
                //if you response is json do the following
                do{
                    let resultJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
                    let arrayJSON = resultJSON as! NSArray
                    for value in arrayJSON{
                        let dicValue = value as! NSDictionary
                        for (key, value) in dicValue {
                            print("key = \(key)")
                            print("value = \(value)")
                        }
                    }
                    
                }catch _{
                    print("Received not-well-formatted JSON")
                }
            }
        })
        task.resume()
        
        return false
    }*/
    
    
}
