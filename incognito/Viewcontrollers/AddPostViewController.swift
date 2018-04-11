//
//  AddPostViewController.swift
//  incognito
//
//  Created by yang zhong on 3/10/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces
import GoogleMaps
import MapKit

class AddPostViewController: UIViewController, UICollectionViewDataSource, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UICollectionViewDelegate, CLLocationManagerDelegate{
    
    let storageref = DataStore.storage.reference()
    // Declare the Imgpicker.
    var imagePicker: UIImagePickerController = UIImagePickerController()
    var coreLocationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        MyCollection.delegate = self
        MyCollection.dataSource = self
        coreLocationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Adding img.
    let Identity = "added_img"
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ImgList.count
    }
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identity, for: indexPath as IndexPath) as! ImgCollectionControllerCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.displayContent(img: ImgList[indexPath.row])
        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        return cell
    }
    
    var ImgList = [UIImage]()
    var CurrentImg: UIImage?
    
    @IBOutlet weak var MyCollection: UICollectionView!
    @IBAction func AddImg(_ sender: Any) {
        let alertController : UIAlertController = UIAlertController(
            title: "Select Camera or camera Library",
            message: nil, preferredStyle: .actionSheet)
        let cameraAction : UIAlertAction = UIAlertAction(title: "Camera", style: .default,handler:
        {(cameraAction) in
            print("camera Selected...")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) == true {
                self.imagePicker.sourceType = .camera
                self.present()
                
            }else{
                self.present(self.showAlert(Title: "Error", Message: "Camera is not available on this Device or accesibility has been revoked!"), animated: true, completion: nil)
            }
        })
        
        let libraryAction : UIAlertAction = UIAlertAction(title: "Photo Library", style: .default, handler: {(libraryAction) in
            print("Photo library selected....")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) == true {
                self.imagePicker.sourceType = .photoLibrary
                self.present()
            }else{
                self.present(self.showAlert(Title: "Error", Message: "Photo Library is not available on this Device or accesibility has been revoked!"), animated: true, completion: nil)
            }
        })
        
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel , handler: {(cancelActn) in
            print("Cancel action was pressed")
        })
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = view.frame
        self.present(alertController, animated: true, completion: nil)
    }
    
    func present(){
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("info of the pic reached :\(info) ")
        if let choosenImg = info[UIImagePickerControllerOriginalImage]as? UIImage {
            ImgList.append(choosenImg)
            CurrentImg = choosenImg
            MyCollection.reloadData()
            // Reload the data from the ImgList.
        }
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //Show Alert
    func showAlert(Title : String!, Message : String!)  -> UIAlertController {
        let alertController : UIAlertController = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        let okAction : UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
            print("User pressed ok function")
        }
        alertController.addAction(okAction)
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = view.frame
        return alertController
    }
    
    // Choose location.
    @IBOutlet weak var textfield: UITextView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBAction func decide_location(_ sender: UIButton) {
        coreLocationManager.requestAlwaysAuthorization()
        placesClient.currentPlace(callback:{ (placeLikelihoodList, error) -> Void in
            if let error = error{
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            self.addressLabel.text = ""
            if let placeLikelihoodList = placeLikelihoodList{
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place{
                    self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ").joined(separator:"\n")
                }
            }
        })

        
    }
    
    // Add the post and update all data.
    @IBAction func DidAddPost(_ sender: Any) {
        let id = Auth.auth().currentUser?.uid
        let post = Post(id: "random",
                        uid: id!,
                        text: textfield.text!,
                        image: ["none"],
                        location: addressLabel.text!,
                        time: "None",
                        like: ["none"],
                        comments: ["none"])
        DataStore.shared.addPost(post: post, ImgList: ImgList)
        print("Successfully saved post")
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // dismiss keyboard
    
}
extension AddPostViewController: GMSAutocompleteViewControllerDelegate{
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
        addressLabel.text = place.name
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
