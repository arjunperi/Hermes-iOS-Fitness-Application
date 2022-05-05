//
//  detailsViewController.swift
//  hermes
//
//  Created by Arjun Peri on 11/10/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import HealthKit

class detailsViewController: UIViewController {

    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var notesField: UITextField!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var stepsLabel: UILabel!
    
    var theLocation: String!
    var theLatitude: Double!
    var theLongitude: Double!
    var theNotes: String!
    var theSteps: Double!
    var theDate: Date!

    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    var startDate: Date?

    
    var vc = mainTabBarController()
    var database = Database.database().reference()
    var dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = theLocation
        dateLabel.text = "What date did you visit?"
        notesLabel.text = "What are your thoughts on this location?"
        if (theNotes != nil){
            notesField.text = theNotes
        }
        if (theSteps != nil){
            stepsLabel.text = String(theSteps)
        }
        if (theSteps == nil){
            stepsLabel.text = "0.0"
        }
        if (theDate != nil){
//            datePicker.date = Date()
            datePicker.date = theDate
        }
        
        if HKHealthStore.isHealthDataAvailable() {
            self.healthStore = HKHealthStore()
            
        }
        super.viewDidLoad()
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        self.healthStore?.requestAuthorization(toShare: [stepType], read: [stepType]) { (success, error) in
            if success{
//                self.calculateStepCount()
            }
        }
       
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func startPressed(_ sender: Any) {
        print("Start pressed")
        startDate = Date()
    }
    
    
    @IBAction func stopPressed(_ sender: Any) {
        print("stop pressed")
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        self.healthStore?.requestAuthorization(toShare: [stepType], read: [stepType]) { (success, error) in
            if success{
                print("calculating steps")
                self.recentSteps(self.startDate!) { steps, error in
                    print("steps " + String(steps))
                    self.theSteps = steps
                    self.stepsLabel.text = String(steps)
                }
            }
            else{
                print("error calculating steps")

            }
        }
    }
    
    func recentSteps(_ date : Date, completion: @escaping (Double, NSError?) -> () )
    {
        print("recentSteps start: ")
        print(date)
        print("recentSteps end: ")
        print(Date())
        // The type of data we are requesting (this is redundant and could probably be an enumeration
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        let predicate = HKQuery.predicateForSamples(withStart: date, end: Date(), options: HKQueryOptions())
        
        // The actual HealthKit Query which will fetch all of the steps and sub them up for us.
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, results, error in
            var steps: Double = 0
            print("results", results)
            
            if results!.count > 0
            {
                for result in results as! [HKQuantitySample]
                {
                    steps += result.quantity.doubleValue(for: HKUnit.count())
                }
            }
            
            completion(steps, error as NSError?)
        }
        self.healthStore?.execute(query)
    }
    
  

    @IBAction func locationAdded(_ sender: Any) {
        if (theSteps == nil){
            theSteps = 0
        }
        theDate = datePicker.date
        dateFormatter.dateFormat = "YY/MM/dd"

        let locationObject : [String: Any] = ["notes": notesField.text as! NSObject,
                                              "latitude": theLatitude,
                                              "longitude": theLongitude,
                                              "steps": theSteps,
                                              "date": dateFormatter.string(from: theDate!)]
        
        database.child("/\(vc.uid!)/saved locations/\(theLocation!)").setValue(locationObject)
    }
    
        
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! mapViewController
        destVC.theMapLatitude = theLatitude
        destVC.theMapLongitude = theLongitude
        destVC.theMapLocation = theLocation
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}
