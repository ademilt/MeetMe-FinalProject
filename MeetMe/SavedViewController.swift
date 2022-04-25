//
//  SavedViewController.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/24/22.
//



import UIKit
import CoreLocation

class SavedViewController: UIViewController {
   
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var adventures = ["Molly","Rosie","Grace"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func leaveViewController(){
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode{
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        leaveViewController()
    }
}

extension SavedViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return adventures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SavedTableViewCell
//        if let currentLocation = currentLocation{
//            cell.currentLocation = currentLocation
//        }
        cell.adventureLabel?.text = adventures[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
