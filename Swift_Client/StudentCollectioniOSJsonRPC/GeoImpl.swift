/*
 Author: Duc Nguyen
 This is container class, it will store necessary data such as latitude, ...etc
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

    
    init(dict: [String:Any]){
        self.latitude = dict["Latitude"] as! String
        self.longititude = dict["Longitude"] as! String
        self.address = dict["Address"] as! String
        self.category = dict["Category"] as! String
        self.elevation = dict["Elevation"] as! String
        self.title = dict["Title"] as! String
        self.description = dict["Description"] as! String
    }
}
