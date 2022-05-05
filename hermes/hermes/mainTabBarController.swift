//
//  mainTabBarController.swift
//  hermes
//
//  Created by Arjun Peri on 11/17/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class mainTabBarController: UITabBarController {
    var user = Auth.auth().currentUser
    var uid: String?
    var value: NSDictionary?
    var sections: Int?
    var locationTitles: [String?] = []
    
    
    var database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tabBar.items?[0].title = "Add Location"
        tabBar.items?[1].title = "Map"
        tabBar.items?[2].title = "My Locations"
        tabBar.items?[3].title = "Log Out"
        
        if let user = user{
            uid = user.uid
        }
        
        let postRef = database.child(uid!)
        postRef.observe(DataEventType.childAdded, with: {snapshot in
            print("in databaseread")
            self.value = snapshot.value as? NSDictionary
            if (self.value != nil){
                for key in self.value!.allKeys{
                    self.locationTitles.append(key as? String)
                }
                self.sections = self.locationTitles.count
            }
            else{
                print("no saved locations")
            }
        })
//
//            database.child(uid!).child("saved locations").observeSingleEvent(of: .value, with: { snapshot in
//                self.value = snapshot.value as? NSDictionary
//                if (self.value != nil){
////                    print(self.value)
//                    for key in self.value!.allKeys{
////                        print(key as? String)
//                        self.locationTitles.append(key as? String)
//                    }
//                    self.sections = self.locationTitles.count
////                    print("Sections")
////                    print(self.locationTitles.count)
//                }
//                else{
////                    print("no saved locations")
////                    print(self.sections)
//                }
//
////                print("done with array")
////                print(self.locationTitles)
//
//            })
//        }
//
//    }
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


