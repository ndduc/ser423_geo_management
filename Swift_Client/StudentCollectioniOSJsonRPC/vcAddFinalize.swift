/*
    Author: Duc Nguyen
    Purpose: contain login for AddFinalize Scene
        in this scene, user is allowed to perform add operation
        the program call add function from stub and it send data in form of json to server
        server will be the one who actually do add operation
 **/
import UIKit

class vcAddFinalize: UIViewController, UIPickerViewDelegate{
    
    //MARK: UI Component
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtLatitude: UITextField!
    @IBOutlet weak var txtLongitude: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDesc: UITextField!
    @IBOutlet weak var txtCate: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtEle: UITextField!
    
    //MARK: Variables
    var lat:String?
    var lon:String?
    var add:String?
    var urlString:String = "http://192.168.1.243:8080"
    override func viewDidLoad() {
        super.viewDidLoad()
       // print("TEST addF", lat)
        addValuetoTextField()
    }
    
    
    //MARK: Main Override
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //fire add event upon a click on button
    //MARK: System Function
    @IBAction func clickedAdd(_ sender: Any) {
        let aConnect:StudentCollectionStub = StudentCollectionStub(urlString: urlString)
        let _:Bool = aConnect.add_Search(address: txtStreet.text!, lat: txtLatitude.text!, longt: txtLongitude.text!, name: txtName.text!, desc: txtDesc.text!, cate: txtCate.text!, title: txtTitle.text!, elev: txtEle.text!, callback: { (res: String, err: String?) -> Void in
        
            if err != nil {
                NSLog(err!)
            }
        })
    }
    
    //add value methods
    //MARK: User-Defined Function
    func addValuetoTextField() {
        txtLatitude.text = lat
        txtLongitude.text = lon
        txtStreet.text = add
    }
}
