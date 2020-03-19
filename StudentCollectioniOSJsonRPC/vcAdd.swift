//
//  vcAdd.swift
//  StudentCollectioniOSJsonRPC
//
//  Created by mac on 3/18/20.
//  Copyright © 2020 Tim Lindquist. All rights reserved.
//

import UIKit

class vcAdd: UIViewController, UIPickerViewDelegate, UITextFieldDelegate, UIPickerViewDataSource{
    
    
    //MARK: UI Components
    //@IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var btnCheck: UIButton!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    //MARK: Variables
    var latitude = ""

    var urlString:String = "http://192.168.1.243:8080"
    let state = ["AZ", "CA", "TX"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       //self.txtDesc.delegate = self;
        
        self.txtAddress.delegate = self;
        self.txtCity.delegate=self;
        //self.txtState.delegate = self;
        self.urlString = self.setURL()
       // self.callGetNamesNUpdateStudentsPicker()
        
        pickerView.delegate = self;
        pickerView.dataSource = self;
    }
    
    
    
    func setURL () -> String {
        var serverhost:String = "localhost"
        var jsonrpcport:String = "8080"
        var serverprotocol:String = "http"
        // access and log all of the app settings from the settings bundle resource
        if let path = Bundle.main.path(forResource: "ServerInfo", ofType: "plist"){
            // defaults
            if let dict = NSDictionary(contentsOfFile: path) as? [String:AnyObject] {
                serverhost = (dict["server_host"] as? String)!
                jsonrpcport = (dict["jsonrpc_port"] as? String)!
                serverprotocol = (dict["server_protocol"] as? String)!
            }
        }
        print("setURL returning: \(serverprotocol)://\(serverhost):\(jsonrpcport)")
        return "\(serverprotocol)://\(serverhost):\(jsonrpcport)"
    }
    
    func addSearchValue(){
        let aConnect:StudentCollectionStub = StudentCollectionStub(urlString: urlString)
        let _:Bool = aConnect.getGeo(callback: { (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            }else{
                NSLog(res)
                if let data: Data = res.data(using: String.Encoding.utf8){
                    do{
                        let dict = try JSONSerialization.jsonObject(with: data,options:.mutableContainers) as?[String:AnyObject]
                        let aDict:[String:AnyObject] = (dict!["result"] as? [String:AnyObject])!
                        //print("[TEST: ]", aDict)
                        let aStud:GeoImpl = GeoImpl(dict: aDict)
                        if(aStud.latitude != "0") {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "vcAddF") as! vcAddFinalize
                            controller.lat = "\(aStud.latitude)"
                            controller.lon = "\(aStud.longititude)"
                            controller.add = "\(aStud.address)"
                            self.present(controller, animated: true, completion: nil)
                        } else {
                            self.txtAddress.text = "Invalid Value"
                        }
                    } catch {
                        NSLog("unable to convert to dictionary")
                    }
                }
            }
        })
    }
    
    //MARK: check Event
    @IBAction func btnCheckedClicked(_ sender: Any) {
        
       // print(txtAddress.text)
        
        let stateSelected = state[pickerView.selectedRow(inComponent: 0)]
        let aConnect:StudentCollectionStub = StudentCollectionStub(urlString: urlString)
        
        if(txtCity.text != "" && txtAddress.text != "" && txtZip.text != "") {
            if(txtAddress.text != "Invalid Value") {
                let _:Bool = aConnect.show_Search(address: txtAddress.text!, city: txtCity.text!, state: stateSelected, zip: txtZip.text!, callback: { _,_  in
                })
                addSearchValue()
            }
        }
        
    }
    
    
    //MARK: PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return state.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return state[row]
    }

    //MARK: Passing Value to ViewController
    
    
    
 
}
