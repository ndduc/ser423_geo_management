

import UIKit

class vcMod: UIViewController, UIPickerViewDelegate, UITextFieldDelegate{
    @IBOutlet weak var txtDesc: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCate: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtEve: UITextField!
    @IBOutlet weak var txtLat: UITextField!
    @IBOutlet weak var txtLong: UITextField!
    
    @IBOutlet weak var namePicker: UIPickerView!
    
    var selectedName:String=""
    var name:[String]=[String]()
    
    var urlString:String = "http://192.168.1.243:8080"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.namePicker.removeFromSuperview()
        self.namePicker.delegate = self
        self.txtName.inputView = self.namePicker
        
        self.urlString = self.setURL()
        self.callGetNamesNUpdateStudentsPicker();
      //  self.callGetNamesNUpdateStudentsPicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
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
    
    func callGetNamesNUpdateStudentsPicker() {
        let aConnect:StudentCollectionStub = StudentCollectionStub(urlString: urlString)
        let _:Bool = aConnect.getLocationName(callback: { (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            }else{
                NSLog(res)
                if let data: Data = res.data(using: String.Encoding.utf8){
                    do{
                        let dict = try JSONSerialization.jsonObject(with: data,options:.mutableContainers) as?[String:AnyObject]
                        self.name = (dict!["result"] as? [String])!
                        self.name = Array(self.name).sorted()
                        self.txtName.text = ((self.name.count>0) ? self.name[0] : "")
                        self.namePicker.reloadAllComponents()
                        if self.name.count > 0 {
                        //    print(self.name[0])
                            self.callGetNPopulatUIFields(self.name[0])
                        }
                    } catch {
                        print("unable to convert to dictionary")
                    }
                }
                
            }
        })  // end of method call to getNames
    }
    
    func callGetNPopulatUIFields(_ name: String){
        print(name)
        let aConnect:StudentCollectionStub = StudentCollectionStub(urlString: urlString)
        let _:Bool = aConnect.getGeoByName(name: name, callback: { (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            }else{
                NSLog(res)
                if let data: Data = res.data(using: String.Encoding.utf8){
                    do{
                        let dict = try JSONSerialization.jsonObject(with: data,options:.mutableContainers) as?[String:AnyObject]
                        let aDict:[String:AnyObject] = (dict!["result"] as? [String:AnyObject])!
                        let aStud:GeoImpl = GeoImpl(dict: aDict)
                        self.txtLat.text = "\(aStud.latitude)"
                        self.txtTitle.text = "\(aStud.title)"
                        self.txtLong.text = "\(aStud.longititude)"
                        self.txtStreet.text = "\(aStud.address)"
                        self.txtCate.text = "\(aStud.category)"
                        self.txtDesc.text = "\(aStud.description)"
                        self.txtEve.text = "\(aStud.elevation)"
                    } catch {
                        NSLog("unable to convert to dictionary")
                    }
                }
            }
    })
    }
    
    
    
    @IBAction func removeClicked(_ sender: Any) {
        let aConnect:StudentCollectionStub = StudentCollectionStub(urlString: urlString)
        let _:Bool = aConnect.remove_location(name: self.name[0], callback: { (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            }
        })
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        let aConnect:StudentCollectionStub = StudentCollectionStub(urlString: urlString)
        let _:Bool = aConnect.save_location(name: self.name[0], desc: self.txtDesc.text!, cate: self.txtCate.text!, tit: self.txtTitle.text!, add: self.txtStreet.text!, ele:txtEve.text!, lat:txtLat.text!, lon:txtLong.text!, callback: { (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            }
        })
    }
    
    
    // MARK: -- UIPickerVeiwDelegate methods
      
     // touch events on this view
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.txtName.resignFirstResponder()
     }

     // UITextFieldDelegate Method
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         self.txtName.resignFirstResponder()
         return true
     }
    
    @objc func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == namePicker {
            self.selectedName = name[row]
            self.txtName.text = self.selectedName
            self.txtName.resignFirstResponder()
            self.callGetNPopulatUIFields(self.selectedName)
        }
    }
    
    @objc func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @objc func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return name.count
    }
    
    @objc func pickerView (_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return name[row]
    }
     

}

