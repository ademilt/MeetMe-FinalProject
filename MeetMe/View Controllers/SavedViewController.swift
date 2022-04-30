////
////  SavedViewController.swift
////  MeetMe
////
////  Created by Annie DeMilt on 4/24/22.
////
//
//
//
//import UIKit
//import CoreLocation
//
//class SavedViewController: UIViewController {
//    
//    @IBOutlet weak var tableView: UITableView!
//    
//    var adventures: Adventures!
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //adventures = Adventures()
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setToolbarHidden(false, animated: true)
//
//        adventures.loadData {
//            self.sortBasedOnSegmentPressed()
//            self.tableView.reloadData()
//        }
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowDetail" {
//            let destination = segue.destination as! SavedDetailViewController
//            let selectedIndexPath = tableView.indexPathForSelectedRow!
//            destination.spot = adventures.spotArray[selectedIndexPath.row]
//        }
//    }
//    
//    @IBAction func sortSegmentPressed(_ sender: UISegmentedControl) {
//        sortBasedOnSegmentPressed()
//    }
//    
//    @IBAction func usersButtonPressed(_ sender: UIBarButtonItem) {
//        
//    }
//    
//}
//
//extension SavedViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return adventures.spotArray.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SpotTableViewCell
//        if let currentLocation = currentLocation {
//            cell.currentLocation = currentLocation
//        }
//        cell.spot = adventures.spotArray[indexPath.row]
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
//}
