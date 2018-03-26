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

class AddPostViewController: UIViewController,UICollectionViewDataSource, UIImagePickerControllerDelegate,
 UINavigationControllerDelegate, UICollectionViewDelegate{
    
    let storageref = DataStore.storage.reference()
    // Declare the Imgpicker.
    var imagePicker: UIImagePickerController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Adding img.
    var ImgList = [UIImage]()
    var CurrentImg: UIImage?
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
            print("1")
        }
        self.imagePicker.dismiss(animated: true, completion: nil)
        
//        var data = UIImageJPEGRepresentation(CurrentImg!, 0.8)! as NSData
//        let filePath = ""
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpg"
//        self.storageref.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }else{
//                //store downloadURL
//                let downloadURL = metaData!.downloadURL()!.absoluteString
//                //store downloadURL at database
//                Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).updateChildValues(["avatar": downloadURL])
//            }
//        }
        
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
    
    // Show image in Collection Cell.
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
    
    @IBOutlet weak var textfield: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    @IBAction func decide_location(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func DidAddPost(_ sender: Any) {
        let id = Auth.auth().currentUser?.uid
        let post = Post(uid: id!,
                        text: textfield.text!,
                        image: "none",
                        location: nameLabel.text!,
                        time: "none",
                        like: ["none"],
                        comments: ["none"])
        DataStore.shared.addPost(post: post)
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
