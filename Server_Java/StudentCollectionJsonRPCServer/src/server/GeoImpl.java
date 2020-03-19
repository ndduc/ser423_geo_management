package ser423.student.server;

import org.json.JSONArray;
import org.json.JSONObject;


public class GeoImpl {
    JSONObject data;
    JSONObject dataAsGeo;
    public String name, desc, cate, title, address, ele, lat, longt;
    public GeoImpl(JSONObject json, String option) {
        if(option.equalsIgnoreCase("add")) {
            System.out.println("Not Implemented");
        }
        else if (option.equalsIgnoreCase("search")){
            try {
				
				System.out.println("[DEBUG]\t\t\t" + json);
				
				JSONObject gcodeInput = json.getJSONObject("InputAddress");
				address = gcodeInput.get("StreetAddress").toString();
				debugString("address", address);
				
				
                JSONArray geocode = json.getJSONArray("OutputGeocodes");
                JSONObject gcode = geocode.getJSONObject(0);
                JSONObject gcode2 = gcode.getJSONObject("OutputGeocode");
                lat = gcode2.get("Latitude").toString();
                longt = gcode2.get("Longitude").toString();
                
                //debugString("address", address);
                //debugString("elevation", ele);
                debugString("lat", lat);
                debugString("long", longt);
                
                JSONObject newJson = new JSONObject();
                newJson.put("Latitude", lat);
                newJson.put("Longitude", longt);
				newJson.put("Address", address);
                dataAsGeo = new JSONObject();
                dataAsGeo = newJson;
                
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (option.equalsIgnoreCase("lookup")) {
			try {
				JSONObject data = json;
				dataAsGeo = json;
				address = json.get("Address").toString();
				lat = json.get("Latitude").toString();
				longt = json.get("Longitude").toString();
				
				debugString("lat", lat);
                debugString("long", longt);
                
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
    }
    
    public JSONObject toJson() {
        return dataAsGeo;
    }
    
    public JSONObject getData() {
        return data;
    }
    
    private void debugString(String subject, String test) {
        System.out.println("[DEBUG GEO]\t"+ subject +"\t\t" + test);
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String getCate() {
        return cate;
    }

    public void setCate(String cate) {
        this.cate = cate;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getEle() {
        return ele;
    }

    public void setEle(String ele) {
        this.ele = ele;
    }

    public String getLat() {
        return lat;
    }

    public void setLat(String lat) {
        this.lat = lat;
    }

    public String getLongt() {
        return longt;
    }

    public void setLongt(String longt) {
        this.longt = longt;
    }
    
    
}
