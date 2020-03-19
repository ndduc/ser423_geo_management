package ser423.student.server;

import java.util.Hashtable;
import java.util.Iterator;
import java.io.File;
import java.io.FileInputStream;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.Reader;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Vector;
import java.util.*;

import org.json.*;

/**
 * Copyright (c) 2020 Tim Lindquist,
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
 * <p/>
 * Purpose: This class is part of an example developed for the mobile
 * computing class at ASU Poly. The application provides a Java RPC server using
 * http for a collection of students.
 *
 * see http://pooh.poly.asu.edu/Mobile
 * @author Tim Lindquist Tim.Lindquist@asu.edu
 *         Software Engineering, CIDSE, IAFSE, ASU Poly
 * @version February 2020
 *
 **/
class StudentCollectionImpl extends Object implements StudentCollection{
	
   JSONObject rootData;
   public Hashtable<String,Student> students;
   private static final boolean debugOn = false;
   private static final String studentJsonFileName = "students.json";
   private static final String locationJsonFileName = "geo.json";

   public StudentCollectionImpl() {
      debug("creating a new student collection");
      initDataCollection(studentJsonFileName);
      students = new Hashtable<String,Student>();
      this.resetFromJsonFile();
   }

   private void debug(String message) {
      if (debugOn)
         System.out.println("debug: "+message);
   }

   public boolean resetFromJsonFile(){
      boolean ret = true;
      try{
         students.clear();
         String fileName = studentJsonFileName;
         File f = new File(fileName);
         FileInputStream is = new FileInputStream(f);
         JSONObject studentMap = new JSONObject(new JSONTokener(is));
         Iterator<String> it = studentMap.keys();
         while (it.hasNext()){
            String mType = it.next();
            JSONObject studentJson = studentMap.optJSONObject(mType);
            Student stud = new Student(studentJson);
            students.put(stud.name, stud);
            debug("added "+stud.name+" : "+stud.toJsonString()+
                  "\nstudents.size() is: " + students.size());
         }
      }catch (Exception ex){
         System.out.println("Exception reading json file: "+ex.getMessage());
         ret = false;
      }
      return ret;
   }

   public boolean saveToJsonFile(){
      boolean ret = true;
      try {
         String jsonStr;
         JSONObject obj = new JSONObject();
         for (Enumeration<String> e = students.keys(); e.hasMoreElements();){
            Student aStud = students.get((String)e.nextElement());
            obj.put(aStud.name,aStud.toJson());
         }
         PrintWriter out = new PrintWriter(studentJsonFileName);
         out.println(obj.toString(2));
         out.close();
      }catch(Exception ex){
         ret = false;
      }
      return ret;
   }
   
   public boolean add(Student aStud){
      boolean ret = true;
      debug("adding student named: "+((aStud==null)?"unknown":aStud.name));
      try{
         students.put(aStud.name,aStud);
      }catch(Exception ex){
         ret = false;
      }
      return ret;
   }

   public boolean remove(String aName){
      debug("removing student named: "+aName);
      return ((students.remove(aName)==null)?false:true);
   }

   public String[] getNames(){
      String[] ret = {};
      debug("getting "+students.size()+" student names.");
      if(students.size()>0){
         ret = (String[])(students.keySet()).toArray(new String[0]);
      }
      return ret;
   }
   
   public Student get(String aName){
      Student ret = new Student("unknown",0,new String[]{"empty"});
      Student aStud = students.get(aName);
      if (aStud != null) {
         ret = aStud;
      }
      return ret;
   }
   
   
   
   
   /**
    * New method for Geo App
    * */
	
	String urlFull = "https://geoservices.tamu.edu/Services/Geocode/WebService/GeocoderWebServiceHttpNonParsed_V04_01.aspx?streetAddress=9355%20Burton%20Way&city=Beverly%20Hills&state=ca&zip=90210&apikey=demo&format=json&census=true&censusYear=2000|2010&notStore=false&version=4.01";
	
   GeoImpl geoIm;
   public boolean show_Search(String address, String city, String state, String zip) {
       if(decodeSearchString(address, city, state, zip) != null) {
           JSONObject data = decodeSearchString(address, city, state, zip);
          // System.out.println("TEST: " + data);
           decodeSearchResult(data);
           return true;
       } else {
           return false;
       }
   }
   
   private JSONObject decodeSearchResult(JSONObject data) {
       geoIm = new GeoImpl(data, "search");
       JSONArray geocode = data.getJSONArray("OutputGeocodes");
       JSONObject gcode = geocode.getJSONObject(0);
       
       
       //System.out.println("[TEST GCODE]\t\t" + gcode);
       JSONObject gcode2 = gcode.getJSONObject("OutputGeocode");
       //System.out.println("[TEST GCODE2]\t\t" + gcode2);
       System.out.println("[TEST RESULT]");
       System.out.println("[Latitude]\t\t" + gcode2.get("Latitude"));
       System.out.println("[Longitude]\t\t" + gcode2.get("Longitude"));
       return gcode2;
   }
   
   
   @SuppressWarnings("unused")
   private JSONObject decodeSearchString(String address, String city,
           String state, String zip) {
       try {
           String codeAddress = URLEncoder.encode(address, "UTF-8");
           String codeCity= URLEncoder.encode(city, "UTF-8");
           String codeState = URLEncoder.encode(state, "UTF-8");
           String codeZip = URLEncoder.encode(zip, "UTF-8");
           
           
           String urlTr = "https://geoservices.tamu.edu/Services/Geocode/WebService/GeocoderWebServiceHttpNonParsed_V04_01.aspx?"
                   + "streetAddress=" + codeAddress + ""
                   + "&state="+ codeState + ""
                   + "&zip=" +codeZip+""
                   + "&apikey=demo&format=json&census=true&censusYear=2000|2019&notStore=false&version=4.01";
           //
           System.out.println(urlTr);
           JSONObject data = readJsonFromUrl(urlTr);
           return data;
       } catch (Exception e) {
           // TODO Auto-generated catch block
           e.printStackTrace();
       }
       return null;
   }
   
   
   public GeoImpl getGeo() {
       return geoIm;
   }
   
   /**
    *  Method perform read from URL
    * */
   private JSONObject readJsonFromUrl(String url) throws IOException, JSONException {
       System.out.println("TEST: " + url);
       InputStream is = new URL(url).openStream();
       try {
         BufferedReader rd = new BufferedReader(new InputStreamReader(is, Charset.forName("UTF-8")));
         String jsonText = readAll(rd);
         JSONObject json = new JSONObject(jsonText);
         

         return json;
       } finally {
         is.close();
       }
   }
   
   /**
    *  Helper method for readJsonFromUrl
    * */
   private  String readAll(Reader rd) throws IOException {
       StringBuilder sb = new StringBuilder();
       int cp;
       while ((cp = rd.read()) != -1) {
         sb.append((char) cp);
       }
       return sb.toString();
   }
   
   
   public boolean add_Search(String address, String lat, String longt, String name, String desc, 
           String cate, String title, String elva) {
       initDataCollection(locationJsonFileName);
       JSONObject root = getRootData();
       
       JSONObject newObj = new JSONObject();
       newObj.put("Address", address);
       newObj.put("Latitude", lat);
       newObj.put("Longitude", longt);
       newObj.put("Description", desc);
       newObj.put("Category", cate);
       newObj.put("Title", title);
       newObj.put("Elevation", elva);
       
       root.putOpt(name, newObj);
       writetoJson(locationJsonFileName, root);
       
       return true;
  
   }
   public boolean remove_location(String name) {
       initDataCollection(locationJsonFileName);
       JSONObject root = getRootData();
       root.remove(name);
       writetoJson(locationJsonFileName, root);
       return true;
   }
   
   /**
     * 	any write method will call this method to finalize write sequence
     * */
    private void writetoJson(String fileName, JSONObject data) {
        try (FileWriter file = new FileWriter(fileName)) {
            file.write(data.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
	
	private void initDataCollection(String filename) {
        try {
            JSONObject root = parseJSONFile(filename);
            rootData = root;
        } catch (Exception e) {
            e.printStackTrace();
        }
        
      //debugList(trackSet);
    }
	
	/**
     * Json Object parser
     * get string as filename
     * return content from file as Jsonobject
     * */
    private JSONObject parseJSONFile(String filename) throws JSONException, IOException {
        //remember to add import file
       File file = new File(filename);
       if(!file.exists()) {
           file.createNewFile();
           FileWriter writer = new FileWriter(filename);
           writer.append("{}");
           writer.flush();
           writer.close();
           
           String content = new String(Files.readAllBytes(Paths.get(filename)));
           return new JSONObject(content);
       } else {
           String content = new String(Files.readAllBytes(Paths.get(filename)));
           return new JSONObject(content);
       }
    }
	
	private JSONObject getRootData() {
		return rootData;
	}
	
	

    public String[] getLocationName() {
        initDataCollection(locationJsonFileName);
        JSONObject root = getRootData();
        List<String> tmp = new ArrayList<String>();
		//getGeoByName("HOME");
		
	//	getGeoByName("HOME");
       // String[] name = null;
        for(String e: root.keySet() ) {
            tmp.add(e);
        }
        /*
        for(int i = 0; i < tmp.size(); i++) {
            System.out.println(tmp.get(i));
        }*/
		String [] name = new String[tmp.size()];
		for(int i = 0; i < tmp.size(); i++) {
			name[i] = tmp.get(i);
		}
        return name;
    }
	
	public GeoImpl getGeoByName(String name) {
		initDataCollection(locationJsonFileName);
        JSONObject root = getRootData();
		JSONObject data = root.getJSONObject(name);
		GeoImpl geo = new GeoImpl(data, "lookup");
		return geo;
	}
	
	public boolean save_location(String name, String desc, String cate, String tit, String add, String ele, String lat, String lon) {
		System.out.println("HIT");
		initDataCollection(locationJsonFileName);
       JSONObject root = getRootData();
       
       JSONObject newObj = new JSONObject();
       newObj.put("Address", add);
       newObj.put("Latitude", lat);
       newObj.put("Longitude", lon);
       newObj.put("Description", desc);
       newObj.put("Category", cate);
       newObj.put("Title", tit);
       newObj.put("Elevation", ele);
       
       root.putOpt(name, newObj);
       writetoJson(locationJsonFileName, root);
	   return true;
	}
}
