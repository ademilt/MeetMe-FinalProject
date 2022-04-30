//
//  PhotoViewController.swift
//  MeetMe
//
//  Created by Annie DeMilt on 4/30/22.
//

import UIKit
import Firebase
import SDWebImage

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    return dateFormatter
}()

class PhotoViewController: UIViewController {
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var adventure: Adventure!
    var photo: Photo!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide keyboard if we tap outside of a field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        guard adventure != nil else {
            print("No adventure passed to PhotoViewController.swift")
            return
        }
        
        if photo == nil {
            photo = Photo()
        }
        
        updateUserInterface()
    }
    
    func updateUserInterface() {
        postedByLabel.text = "by: \(photo.photoUserEmail)"
        dateLabel.text = "on: \(dateFormatter.string(from: photo.date))"
        descriptionTextView.text = photo.description
        
        
        
        if photo.documentID == "" { //This is a new photo
            addBordersToEditableObjects()
        } else {
            if photo.photoUserID == Auth.auth().currentUser?.uid { //Photo posted by current user
                self.navigationItem.leftItemsSupplementBackButton = false
                saveBarButton.title = "Update"
                addBordersToEditableObjects()
                self.navigationController?.setToolbarHidden(false, animated: true)
            } else { //Photo posted by different user
                saveBarButton.hide()
                cancelBarButton.hide()
                postedByLabel.text = "Posted by: \(photo.photoUserEmail)"
                descriptionTextView.isEditable = false
                descriptionTextView.backgroundColor = .white
            }
        }
        guard let url = URL(string: photo.photoURL) else {
            //then this must be a new image
            photoImageView.image = photo.image
            return
        }
        photoImageView.sd_imageTransition = .fade
        photoImageView.sd_imageTransition?.duration = 0.5
        photoImageView.sd_setImage(with: url)
    }
    
    func updateFromUserInterface() {
        photo.description = descriptionTextView.text!
        photo.image = photoImageView.image!
    }
    
    func addBordersToEditableObjects() {
        descriptionTextView.addBorder(width: 0.5, radius: 5.0, color: .black)
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        photo.deleteData(adventure: adventure) { success in
            if success {
                self.leaveViewController()
            } else {
                print("ERROR: Delete unsuccessful")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateFromUserInterface()
        photo.saveData(adventure: adventure) { success in
            if success {
                self.leaveViewController()
            } else {
                print("ERROR: Can't unwind segue from PhotoViewControlloer because of photo saving error.")
            }
        }
    }
}


