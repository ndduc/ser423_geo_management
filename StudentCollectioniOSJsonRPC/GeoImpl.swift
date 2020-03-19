/*
 * Copyright 2020 Tim Lindquist,
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Purpose: Example Swift Client for a Java student collection JsonRPC server.
 *
 * Ser423 Mobile Applications
 * see http://pooh.poly.asu.edu/Mobile
 * @author Tim Lindquist Tim.Lindquist@asu.edu
 *         Software Engineering, CIDSE, IAFSE, ASU Poly
 * @version February 2020
 */

import Foundation

public class GeoImpl {
    open var latitude: String
    open var longititude: String
    open var address: String
    open var category: String
    open var elevation: String
    open var title: String
    open var description: String
  //  open var takes:[String]=[String]()
    /*
    init (jsonStr: String){
        self.latitude = ""
        self.longititude = ""
        self.address = ""
        if let data: Data = jsonStr.data(using: String.Encoding.utf8){
            do{
                let dict = try JSONSerialization.jsonObject(with: data,options:.mutableContainers) as?[String:AnyObject]
                self.latitude = (dict!["Latitude"] as? String)!
                self.longititude = (dict!["Longitude"] as? String)!
                self.address = (dict!["Address"] as? String)!
             //   self.takes = (dict!["takes"] as? [String])!
            } catch {
                print("unable to convert to dictionary")
                
            }
        }
    }*/
    
    init(dict: [String:Any]){
        self.latitude = dict["Latitude"] as! String
        self.longititude = dict["Longitude"] as! String
        self.address = dict["Address"] as! String
        self.category = dict["Category"] as! String
        self.elevation = dict["Elevation"] as! String
        self.title = dict["Title"] as! String
        self.description = dict["Description"] as! String
    }
    /*
    func toJsonString() -> String {
        var jsonStr = "";
        let dict = ["name": name, "studentid": studentid, "takes":takes] as [String : Any]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            jsonStr = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        } catch let error as NSError {
            print(error)
        }
        return jsonStr
    }

    func toDict() -> [String:Any] {
        let dict:[String:Any] = ["name": name, "studentid": studentid, "takes":takes] as [String : Any]
        return dict
    }*/
}
