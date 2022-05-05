//
//  mapViewController.swift
//  hermes
//
//  Created by Arjun Peri on 10/27/21.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import FirebaseDatabase

class mapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    var theMapLatitude: Double!
    var theMapLongitude: Double!
    var theMapLocation: String!
    var database = Database.database().reference()
    var vc = mainTabBarController()
    
    var loc: String?
    var lon: Double?
    var lat: Double?
    var notes: String?
    var steps: Double?
    var date: Date?
    
    var myCoords: CLLocationCoordinate2D!
    var dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.hidesBackButton = true
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if ((theMapLatitude != nil) && (theMapLongitude != nil)){
            myCoords = CLLocationCoordinate2D(latitude: theMapLatitude, longitude: theMapLongitude)
        }
        else{
            myCoords = CLLocationCoordinate2D(latitude: 36.014670, longitude: -78.922690)
        }

        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: myCoords, span: span)
                
        mapView.setRegion(region, animated: true)
        

        let annotation = MKPointAnnotation()
        annotation.coordinate = myCoords
        annotation.title = "1013 Ninth Street"
        annotation.subtitle = "Apt 2"
        mapView.addAnnotation(annotation)
        
//        locationManager.startUpdatingLocation()
//        let locations = [CLLocation]
//
//        print("Latitude = \(locations.first!.coordinate.latitude)")
//        print("Longitude = \(locations.first!.location!.coordinate.longitude)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        database.child(self.vc.uid!).child("saved locations").observeSingleEvent(of: .value, with: { snapshot in
            self.vc.value = snapshot.value as? NSDictionary
            if (self.vc.value != nil){
                print("in snapshot")
                for key in self.vc.value!.allKeys{
                    self.vc.locationTitles.append(key as? String)
                    }
                self.vc.sections = self.vc.locationTitles.count
                }
                else{
                    print("no saved locations")
                }
            })

        print("map loaded")
        print(self.vc.locationTitles)

        for key in vc.locationTitles {
            print("in loop", key)
            let annotation  = MKPointAnnotation()
            let result = vc.value![key] as? NSDictionary
            let tempLat = result!["latitude"] as? Double
            let tempLon = result!["longitude"] as? Double
            annotation.coordinate = CLLocationCoordinate2D(latitude: tempLat!, longitude: tempLon!)
            annotation.title = key
            mapView.addAnnotation(annotation)
        }
    }
    

    @IBAction func unwindToMapVC(segue:  UIStoryboardSegue){
        if ((theMapLatitude != nil) && (theMapLongitude != nil)){
            myCoords = CLLocationCoordinate2D(latitude: theMapLatitude, longitude: theMapLongitude)
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: myCoords, span: span)
                
        mapView.setRegion(region, animated: true)
        

        let annotation = MKPointAnnotation()
        annotation.coordinate = myCoords
        annotation.title = theMapLocation
        annotation.subtitle = "Apt 2"
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        lat = view.annotation?.coordinate.latitude
        lon = view.annotation?.coordinate.longitude
        loc = view.annotation?.title!
        print("loc", loc!)
        print("vc.value", vc.value)
        let result = vc.value![loc!] as? NSDictionary
        if (result != nil){
            notes = result!["notes"] as? String
            steps = result!["steps"] as? Double
            let tempDate = result!["date"] as? String
            dateFormatter.dateFormat = "YY/MM/dd"
            date = dateFormatter.date(from: tempDate!)
        }
        else{
            notes = ""
            steps = 0.0
            date = Date()
        }
        
        
        performSegue(withIdentifier: "markerSelectSegue", sender: nil)
    }

    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            print("App is authorized")
            locationManager.startUpdatingLocation()
        }
        
        if status == .notDetermined || status == .denied {
            locationManager.requestWhenInUseAuthorization()
        }
    }
            
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //print("Location \(locations.first)")
//        print("Latitude = \(locations.first!.coordinate.latitude)")
//        print("Longitude = \(locations.first!.coordinate.longitude)")
        
//        locationManager.stopUpdatingLocation()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destVC = segue.destination as! detailsViewController
        destVC.theLocation = loc!
        destVC.theLatitude = lat!
        destVC.theLongitude = lon!
        destVC.theNotes = notes!
        destVC.theSteps = steps!
        destVC.theDate = date!
    }
    

}
