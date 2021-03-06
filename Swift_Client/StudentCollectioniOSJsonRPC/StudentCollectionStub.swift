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
 * @version February, 2020
 */

import Foundation

public class StudentCollectionStub {
    
    static var id:Int = 0
    
    var url:String
    
    init(urlString: String){
        self.url = urlString
    }
    
    
    //MARK: Async Function
    // used by methods below to send a request asynchronously.
    // creates and posts a URLRequest that attaches a JSONRPC request as a Data object. The URL session
    // executes in the background and calls its completion handler when the result is available.
    func asyncHttpPostJSON(url: String,  data: Data,
                           completion: @escaping (String, String?) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.httpBody = data as Data
        //HTTPsendRequest(request: request, callback: completion)
        // task.resume() below, causes the shared session http request to be posted in the background
        // (independent of the UI Thread)
        // the use of the DispatchQueue.main.async causes the callback to occur on the main queue --
        // where the UI can be altered, and it occurs after the result of the post is received.
        let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            if (error != nil) {
                completion("Error in URL Session", error!.localizedDescription)
            } else {
                DispatchQueue.main.async(execute: {completion(NSString(data: data!,
                                                                       encoding: String.Encoding.utf8.rawValue)! as String, nil)})
            }
        })
        task.resume()
    }

    //MARK: STUB
    ///////////////
    
    //MARK:: getGeoByName
    func getGeoByName(name: String, callback: @escaping (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        StudentCollectionStub.id = StudentCollectionStub.id + 1
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"getGeoByName", "params":[name], "id":StudentCollectionStub.id]
            
            print(dict);
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    
    
    //MARK: getGeo
    func getGeo(callback: @escaping (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        StudentCollectionStub.id = StudentCollectionStub.id + 1
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"getGeo", "params":[ ], "id":StudentCollectionStub.id]
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    
    //MARK: getLocatioName
    func getLocationName(callback: @escaping (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        StudentCollectionStub.id = StudentCollectionStub.id + 1
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"getLocationName", "params":[ ], "id":StudentCollectionStub.id]
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }

    //MARK: Save Location
    func save_location(name: String, desc: String, cate: String, tit: String, add:String, ele:String, lat:String, lon:String, callback: @escaping (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        StudentCollectionStub.id = StudentCollectionStub.id + 1
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"save_location", "params":[name, desc, cate, tit, add, ele, lat, lon], "id":StudentCollectionStub.id]
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    
    //MARK: add Search
    func add_Search(address: String, lat:String, longt:String, name:String, desc:String, cate:String, title:String, elev:String, callback: @escaping (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        StudentCollectionStub.id = StudentCollectionStub.id + 1
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"add_Search", "params":[address, lat, longt, name, desc, cate, title, elev], "id":StudentCollectionStub.id]
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }

    //MARK: Remove Location
    func remove_location(name: String, callback: @escaping (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        StudentCollectionStub.id = StudentCollectionStub.id + 1
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"remove_location", "params":[name], "id":StudentCollectionStub.id]
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    
    
    
    func show_Search(address: String, city: String, state:String, zip:String, callback: @escaping(String, String?)->Void)->Bool {
        var ret:Bool = false
        StudentCollectionStub.id = StudentCollectionStub.id + 1
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"show_Search", "params":[address, city, state, zip], "id":StudentCollectionStub.id]
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
}
