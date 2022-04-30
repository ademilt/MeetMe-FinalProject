////
////  SavedViewController.swift
////  MeetMe
////
////  Created by Annie DeMilt on 4/24/22.
////
//
//
//
import UIKit
import CoreLocation

class SavedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    var adventures: Adventures!
   
    var me: PersonalLocation!
    var friend: FriendLocation!
    var midpoint: MidpointLocation!
    var adventure: Adventure!
    var currentUser: AdventureUser!

//    we need to load PersonalLocation, this is the root document for all subdocuments
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        adventures = Adventures()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)

        //adventures.loadData(person: me, friend: friend, midpoint: midpoint) {
           // self.tableView.reloadData()
        //}
        //updateUserInterface()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! SavedDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.adventure = adventures.adventureArray[selectedIndexPath.row]
        }
    }
    
//    func updateUserInterface() {
//        adventureCell.text = adventure.adventureName
//    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    }
}

extension SavedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adventures.adventureArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SavedTableViewCell
        cell.adventure = adventures.adventureArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
