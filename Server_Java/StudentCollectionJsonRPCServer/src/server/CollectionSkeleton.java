package ser423.student.server;

import java.net.*;
import java.io.*;
import java.util.*;
import org.json.JSONObject;
import org.json.JSONArray;

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
 * computing class at ASU Poly. The application provides a jsonrpc student service.
 *
 * see http://pooh.poly.asu.edu/Mobile
 * @author Tim Lindquist Tim.Lindquist@asu.edu
 *         Software Engineering, CIDSE, IAFSE, ASU Poly
 * @version February 2020
 *
 **/
public class CollectionSkeleton extends Object {

   StudentCollection mLib;

   public CollectionSkeleton (StudentCollection mLib){
      this.mLib = mLib;
   }

   public String callMethod(String request){
      JSONObject result = new JSONObject();
      try{
         JSONObject theCall = new JSONObject(request);
         String method = theCall.getString("method");
         int id = theCall.getInt("id");
         JSONArray params = null;
         if(!theCall.isNull("params")){
            params = theCall.getJSONArray("params");
         }
         result.put("id",id);
         result.put("jsonrpc","2.0");
         if(method.equals("resetFromJsonFile")){
            mLib.resetFromJsonFile();
            result.put("result",true);
         }else if(method.equals("saveToJsonFile")){
            boolean saved = mLib.saveToJsonFile();
            result.put("result",saved);
         }else if(method.equals("remove")){
            String sName = params.getString(0);
            boolean removed = mLib.remove(sName);
            result.put("result",removed);
         }else if(method.equals("add")){
            JSONObject studJson = params.getJSONObject(0);
            Student stud = new Student(studJson);
            boolean added = mLib.add(stud);
            result.put("result",added);
         }else if(method.equals("get")){
            String sName = params.getString(0);
            Student stud = mLib.get(sName);
            result.put("result",stud.toJson());
         }else if(method.equals("getGeoByName")){
			 System.out.println("HIT");
            String sName = params.getString(0);
            GeoImpl stud = mLib.getGeoByName(sName);
            result.put("result",stud.toJson());
         }else if(method.equals("getGeo")) {
			GeoImpl stud = mLib.getGeo();
			result.put("result", stud.toJson());
		 }else if(method.equals("getNames")){
            String[] names = mLib.getNames();
            JSONArray resArr = new JSONArray();
            for (int i=0; i<names.length; i++){
               resArr.put(names[i]);
            }
            result.put("result",resArr);
         } else if(method.equals("getLocationName")){
			 
            String[] names = mLib.getLocationName();
            JSONArray resArr = new JSONArray();
            for (int i=0; i<names.length; i++){
               resArr.put(names[i]);
            }
            result.put("result",resArr);
         } else if(method.equals("show_Search")){
             String address = params.getString(0);
             String city = params.getString(1);
             String state = params.getString(2);
             String zip = params.getString(3);
             boolean show = mLib.show_Search(address, city, state, zip);
             result.put("result",show);
         } else if(method.equals("add_Search")){
            String address = params.getString(0);
			String lat = params.getString(1);
			String longt = params.getString(2);
			String name = params.getString(3);
			String desc = params.getString(4);
			String cate = params.getString(5);
			String title = params.getString(6);
			String elev = params.getString(7); 
          //  Student stud = new Student(studJson);
            boolean added = mLib.add_Search(address, lat, longt, name, desc, cate, title, elev);
            result.put("result",added);
         } else if(method.equals("remove_location")){
            String name = params.getString(0);
            boolean removed = mLib.remove_location(name);
            result.put("result",removed);
         } else if(method.equals("save_location")){
            String name = params.getString(0);
			String desc = params.getString(1);
			String cate = params.getString(2);
			String tit = params.getString(3);
			String add = params.getString(4);
			String ele = params.getString(5);
			String lat = params.getString(6);
			String lon = params.getString(7); 
            boolean save = mLib.save_location(name, desc, cate, tit, add, ele, lat, lon);
            result.put("result",save);
         }
			 
      }catch(Exception ex){
         System.out.println("exception in callMethod: "+ex.getMessage());
      }
      System.out.println("returning: "+result.toString());
      return "HTTP/1.0 200 Data follows\nServer:localhost:8080\nContent-Type:text/plain\nContent-Length:"+(result.toString()).length()+"\n\n"+result.toString();
   }
}

