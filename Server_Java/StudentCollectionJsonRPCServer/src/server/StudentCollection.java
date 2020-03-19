package ser423.student.server;

/**
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
 * Purpose: StudentCollection defines the interface to the server operations
 * Ser423 Mobile Systems
 * see http://pooh.poly.asu.edu/Mobile
 * @author Tim Lindquist Tim.Lindquist@asu.edu
 *         Software Engineering, CIDSE, IAFSE, ASU Poly
 * @version February 2020
 */
public interface StudentCollection {
   public boolean saveToJsonFile();
   public boolean resetFromJsonFile();
   public boolean add(Student stud);
   public boolean remove(String aName);
   public Student get(String aName);
   public String[] getNames();
/*New Method for Geo App
    * */
   
   public boolean show_Search(String address, String city, String state, String zip);
   public GeoImpl getGeo();
   public GeoImpl getGeoByName(String name);
   public boolean add_Search(String address, String lat, String longt, String name, String desc, String cate, String title, String elva);
   public String[] getLocationName();
   public boolean remove_location(String name);
   public boolean save_location(String name, String desc, String cate, String tit, String add, String ele, String lat, String lon);
   /*public boolean add_Data(String address, String city, String state, String zip, String name, String desc, String cate, String title, 
           String lat, String longt);
 */
}
