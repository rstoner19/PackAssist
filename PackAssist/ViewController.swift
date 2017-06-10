//
//  ViewController.swift
//  PackAssist
//
//  Created by Rick Stoner on 3/23/17.
//  Copyright © 2017 Rick Stoner. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var testTableView: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    var tripData = [Trip]() {
        didSet {
            for trip in tripData {
                print(trip.tripName, trip.startDate)
                self.testTableView.reloadData()
            }
        }
    }

    func test() {
    
    }

    @IBAction func saveButtonSelected(_ sender: Any) {
        let name = textInput.text ?? "Other"
        self.textInput.text = ""
        let destination = Destination(destinationName: name)
        let startDate = Date()
        let endDate = Date().addingTimeInterval(86400)
        let packingList = [PackingList(packItem: "socks"), PackingList(packItem: "boxers")]
        
        
        let trip = Trip(recordID: nil, tripName: name, startDate: startDate, endDate: endDate)
        
        APICloud.share.write(trip: trip) { (_) in
            print("Saved!")
        }
    }

    @IBAction func recordsButtonSelected(_ sender: Any) {
        APICloud.share.GETTrips { (trip) in
            if let trips = trip{
                self.tripData = trips
            }
        }
    }
    
    // MARK: UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tripData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath)
        cell.textLabel?.text = self.tripData[indexPath.row].tripName
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let recordID = self.tripData[indexPath.row].recordID {
                APICloud.share.deleteRecord(item: recordID, completion: { (_) in
                    self.tripData.remove(at: indexPath.row)
                    self.testTableView.reloadData()
                })
            }
        }
    }
}
