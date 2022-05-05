//
//  savedLocationsTableViewController.swift
//  hermes
//
//  Created by Arjun Peri on 11/17/21.
//

import UIKit
import Firebase
import FirebaseDatabase

class savedLocationsTableViewController: UITableViewController {
    
    var vc = mainTabBarController()
    var database = Database.database().reference()
    var location: String?
    var Notes: String?
    var lat: Double?
    var lon: Double?
    var loc: String?
    var notes: String?
    var steps: Double?
    var date: Date?
    
    var dateFormatter = DateFormatter()

    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.tabBarController?.navigationItem.hidesBackButton = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (vc.sections != nil){
            return vc.sections!
        }
        else{
            return 0
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("in didAppear")
        print(self.vc.locationTitles)
        let postRef = database.child(vc.uid!)
        postRef.observe(DataEventType.childAdded, with: {snapshot in
            print("in savedLocread")
            self.vc.value = snapshot.value as? NSDictionary
            self.vc.locationTitles.removeAll()
            if (self.vc.value != nil){
                for key in self.vc.value!.allKeys{
                    self.vc.locationTitles.append(key as? String)
                }
                self.vc.sections = self.vc.locationTitles.count
            }
            else{
                print("no saved locations")
            }
        })
        tableView.reloadData()
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
//        print("row")
//        print(indexPath.row)
//        print(vc.locationTitles)
        cell.textLabel?.text = vc.locationTitles[indexPath.row]
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
//
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let location = vc.locationTitles[indexPath.row]
        //remove
        let result = vc.value![location] as? NSDictionary
        lat = result!["latitude"] as? Double
        lon = result!["latitude"] as? Double
        loc = location
        notes = result!["notes"] as? String
        steps = result!["steps"] as? Double
        date = Date()
        dateFormatter.dateFormat = "YY/MM/dd"
        let tempDate = result!["date"] as? String
        date = dateFormatter.date(from: tempDate!)
        self.performSegue(withIdentifier: "selectedSavedSegue", sender: nil)
        }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destVC = segue.destination as! detailsViewController
        destVC.theLatitude = self.lon!
        destVC.theLongitude = self.lon!
        destVC.theLocation = self.loc!
        destVC.theNotes = self.notes!
        destVC.theSteps = self.steps!
        destVC.theDate = self.date!
    }


}
