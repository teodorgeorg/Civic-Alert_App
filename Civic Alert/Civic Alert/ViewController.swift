//
//  ViewController.swift
//  Civic Alert
//
//  Created by issd on 14/09/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseDatabase
import Firebase




class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate {
    
    var ref:DatabaseReference?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textoptional: UITextView!
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var pickerFacilities: UIPickerView!
    @IBOutlet weak var pickerIllegal: UIPickerView!
    @IBOutlet weak var pickerLostFound: UIPickerView!
    
    let locationMgr = CLLocationManager()
    var locationArray: [CLLocation] = []
    
   
    
    @IBAction func reportpressed(_ sender: Any) {
        //Location stuff
        // 1
        let status  = CLLocationManager.authorizationStatus()
        
        // 2
        if status == .notDetermined {
            locationMgr.requestWhenInUseAuthorization()
            return
        }
        
        // 3
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        // 4
        locationMgr.delegate = self
        locationMgr.startUpdatingLocation()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationArray = locations
//        let location = locations.last! as CLLocation
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        self.map.setRegion(region, animated: true)
    }

   
    var publicspacesText: String?
    var cityfacilityText: String?
    var illegalmattersText: String?
    var lostandfoundText: String?
   
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        if(pickerView.tag == 1){
            publicspacesText = problems1PublicSpaces[row]
        }
        if(pickerView.tag == 2){
            cityfacilityText = problems2CityFacilities[row]
        }
        if(pickerView.tag == 3){
            illegalmattersText = problems3IllegalMatters[row]
        }
        if(pickerView.tag == 4){
            lostandfoundText = problems4LostAndFound[row]
        }
    }
    
   
    
    
    
    @IBAction func postpublicspacesproblem(_ sender: Any) {
        
        if(locationArray.count != 0){ //i f there is a location
            
              let myLocation: CLLocation = locationArray[0] as CLLocation
             var myLatitude: String = String(format: "%f", myLocation.coordinate.latitude)
             let myLongitude: String = String(format:"%f", myLocation.coordinate.longitude)
            
            // Post problem stuff
            let userName = "David Gerges"
            let userBsn = "1"
            let userEmail = "david@gmail.com"
            
            self.ref?.child("Reports").child(userBsn).child("Name").setValue(userName)
            self.ref?.child("Reports").child(userBsn).child("Email").setValue(userEmail)
            self.ref?.child("Reports").child(userBsn).child("Category").setValue("Public Spaces")
            self.ref?.child("Reports").child(userBsn).child("problem name").setValue(publicspacesText)
            self.ref?.child("Reports").child(userBsn).child("Extra Info").setValue(textoptional.text)
            
            //This part will only work when we are gonna use an actual phone for our app
            var loc:String? = "Lat: " + myLatitude + ",Long:" + myLongitude
            self.ref?.child("Reports").child(userBsn).child("Location").setValue(loc)
            
            let storageRef = Storage.storage().reference().child(userBsn+".png")
            
            if (self.imageView.image != nil)
            {
                if let uploadData = UIImagePNGRepresentation(self.imageView.image!){
                    
                    storageRef.putData(uploadData, metadata: nil, completion:
                        { (metadata, error) in
                            
                            if error != nil{
                                print(error)
                                return
                            }
                            print (metadata)
                            
                            
                            Storage.storage().reference().child(userBsn+".png").downloadURL(completion: { (url, err) in
                                if let err = err{
                                    print("Error downloading image file, \(err.localizedDescription)")
                                    return
                                }
                                guard let url = url else { return }
                                
                                self.ref?.child("Reports").child(userBsn).child("image url")
                                    .setValue(url.absoluteString)
                            })
                    }
                    )
                }
            }
            
        }
        else
        {
           
        
            // Post problem stuff
            let userName = "David Gerges"
            let userBsn = "1"
            let userEmail = "david@gmail.com"
            
            self.ref?.child("Reports").child(userBsn).child("Name").setValue(userName)
            self.ref?.child("Reports").child(userBsn).child("Email").setValue(userEmail)
            self.ref?.child("Reports").child(userBsn).child("Category").setValue("Public Spaces")
            self.ref?.child("Reports").child(userBsn).child("problem name").setValue(publicspacesText)
            self.ref?.child("Reports").child(userBsn).child("Extra Info").setValue(textoptional.text)
            
            //This part will only work when we are gonna use an actual phone for our app
//              var loc:String? = "Lat: " + myLatitude + ",Long:" + myLongitude
//            self.ref?.child("Reports").child(userBsn).child("Location").setValue(loc)
            
            let storageRef = Storage.storage().reference().child(userBsn+".png")
            
            if (self.imageView.image != nil)
            {
                if let uploadData = UIImagePNGRepresentation(self.imageView.image!){
                    
                    storageRef.putData(uploadData, metadata: nil, completion:
                        { (metadata, error) in
                            
                            if error != nil{
                                print(error)
                                return
                            }
                            print (metadata)
                            
                            
                            Storage.storage().reference().child(userBsn+".png").downloadURL(completion: { (url, err) in
                                if let err = err{
                                    print("Error downloading image file, \(err.localizedDescription)")
                                    return
                                }
                                guard let url = url else { return }
                                
                                self.ref?.child("Reports").child(userBsn).child("image url")
                                    .setValue(url.absoluteString)
                            })
                    }
                    )
                }
            }
         
        }
    }
    
    
    @IBAction func postcityfacilityproblem(_ sender: Any) {
        
        if(locationArray.count != 0){
              let myLocation: CLLocation = locationArray[0] as CLLocation
             var myLatitude: String = String(format: "%f", myLocation.coordinate.latitude)
             let myLongitude: String = String(format:"%f", myLocation.coordinate.longitude)
            
            // Post problem stuff
            let userName = "David Gerges"
            let userBsn = "22"
            let userEmail = "david@gmail.com"
            
            self.ref?.child("Reports").child(userBsn).child("Name").setValue(userName)
            self.ref?.child("Reports").child(userBsn).child("Email").setValue(userEmail)
            self.ref?.child("Reports").child(userBsn).child("Category").setValue("City Facilities")
            self.ref?.child("Reports").child(userBsn).child("problem name").setValue(cityfacilityText)
            self.ref?.child("Reports").child(userBsn).child("Extra Info").setValue(textoptional.text)
            
            //This part will only work when we are gonna use an actual phone for our app
            var loc:String? = "Lat: " + myLatitude + ",Long:" + myLongitude
            self.ref?.child("Reports").child(userBsn).child("Location").setValue(loc)
            
            let storageRef = Storage.storage().reference().child(userBsn+".png")
            
            if (self.imageView.image != nil)
            {
                if let uploadData = UIImagePNGRepresentation(self.imageView.image!){
                    
                    storageRef.putData(uploadData, metadata: nil, completion:
                        { (metadata, error) in
                            
                            if error != nil{
                                print(error)
                                return
                            }
                            print (metadata)
                            
                            
                            Storage.storage().reference().child(userBsn+".png").downloadURL(completion: { (url, err) in
                                if let err = err{
                                    print("Error downloading image file, \(err.localizedDescription)")
                                    return
                                }
                                guard let url = url else { return }
                                
                                self.ref?.child("Reports").child(userBsn).child("image url")
                                    .setValue(url.absoluteString)
                            })
                    }
                    )
                }
                
            }
            
        }
        else
        {
            // Post problem stuff
            let userName = "David Gerges"
            let userBsn = "22"
            let userEmail = "david@gmail.com"
            
            self.ref?.child("Reports").child(userBsn).child("Name").setValue(userName)
            self.ref?.child("Reports").child(userBsn).child("Email").setValue(userEmail)
            self.ref?.child("Reports").child(userBsn).child("Category").setValue("City Facilities")
            self.ref?.child("Reports").child(userBsn).child("problem name").setValue(cityfacilityText)
            self.ref?.child("Reports").child(userBsn).child("Extra Info").setValue(textoptional.text)
            
            
            
            let storageRef = Storage.storage().reference().child(userBsn+".png")
           
             if (self.imageView.image != nil)
             {
                if let uploadData = UIImagePNGRepresentation(self.imageView.image!){
                    
                    storageRef.putData(uploadData, metadata: nil, completion:
                        { (metadata, error) in
                            
                            if error != nil{
                                print(error)
                                return
                            }
                            print (metadata)
                            
                            
                            Storage.storage().reference().child(userBsn+".png").downloadURL(completion: { (url, err) in
                                if let err = err{
                                    print("Error downloading image file, \(err.localizedDescription)")
                                    return
                                }
                                guard let url = url else { return }
                                
                                self.ref?.child("Reports").child(userBsn).child("image url")
                                    .setValue(url.absoluteString)
                            })
                    }
                    )
                }

            }
        }

    }
    
    @IBAction func postillegalmattersproblem(_ sender: Any) {
        
        if(locationArray.count != 0){
            
            
             let myLocation: CLLocation = locationArray[0] as CLLocation
             var myLatitude: String = String(format: "%f", myLocation.coordinate.latitude)
             let myLongitude: String = String(format:"%f", myLocation.coordinate.longitude)
            
            // Post problem stuff
            let userName = "David Gerges"
            let userBsn = "333"
            let userEmail = "david@gmail.com"
            
            self.ref?.child("Reports").child(userBsn).child("Name").setValue(userName)
            self.ref?.child("Reports").child(userBsn).child("Email").setValue(userEmail)
            self.ref?.child("Reports").child(userBsn).child("Category").setValue("Illegal matters")
            self.ref?.child("Reports").child(userBsn).child("problem name").setValue(illegalmattersText)
            self.ref?.child("Reports").child(userBsn).child("Extra Info").setValue(textoptional.text)
            
            //This part will only work when we are gonna use an actual phone for our app
            var loc:String? = "Lat: " + myLatitude + ",Long:" + myLongitude
            self.ref?.child("Reports").child(userBsn).child("Location").setValue(loc)
            
            let storageRef = Storage.storage().reference().child(userBsn+".png")
            if (self.imageView.image != nil)
            {
                
                if let uploadData = UIImagePNGRepresentation(self.imageView.image!){
                    
                    storageRef.putData(uploadData, metadata: nil, completion:
                        { (metadata, error) in
                            
                            if error != nil{
                                print(error)
                                return
                            }
                            print (metadata)
                            
                            
                            Storage.storage().reference().child(userBsn+".png").downloadURL(completion: { (url, err) in
                                if let err = err{
                                    print("Error downloading image file, \(err.localizedDescription)")
                                    return
                                }
                                guard let url = url else { return }
                                
                                self.ref?.child("Reports").child(userBsn).child("image url")
                                    .setValue(url.absoluteString)
                            })
                    }
                    )
                }
            }
        }
        else
        {
            // Post problem stuff
            let userName = "David Gerges"
            let userBsn = "333"
            let userEmail = "david@gmail.com"
            
            self.ref?.child("Reports").child(userBsn).child("Name").setValue(userName)
            self.ref?.child("Reports").child(userBsn).child("Email").setValue(userEmail)
            self.ref?.child("Reports").child(userBsn).child("Category").setValue("Illegal matters")
            self.ref?.child("Reports").child(userBsn).child("problem name").setValue(illegalmattersText)
            self.ref?.child("Reports").child(userBsn).child("Extra Info").setValue(textoptional.text)
            
            let storageRef = Storage.storage().reference().child(userBsn+".png")
            if (self.imageView.image != nil)
            {
                
                if let uploadData = UIImagePNGRepresentation(self.imageView.image!){
                    
                    storageRef.putData(uploadData, metadata: nil, completion:
                        { (metadata, error) in
                            
                            if error != nil{
                                print(error)
                                return
                            }
                            print (metadata)
                            
                            
                            Storage.storage().reference().child(userBsn+".png").downloadURL(completion: { (url, err) in
                                if let err = err{
                                    print("Error downloading image file, \(err.localizedDescription)")
                                    return
                                }
                                guard let url = url else { return }
                                
                                self.ref?.child("Reports").child(userBsn).child("image url")
                                    .setValue(url.absoluteString)
                            })
                    }
                    )
                }
            }
         
        }
        
    }
    
    
    @IBAction func postlostandfoundproblem(_ sender: Any) {
        
        if(locationArray.count != 0){
            
             let myLocation: CLLocation = locationArray[0] as CLLocation
             var myLatitude: String = String(format: "%f", myLocation.coordinate.latitude)
             let myLongitude: String = String(format:"%f", myLocation.coordinate.longitude)
            
            // Post problem stuff
            let userName = "David Gerges"
            let userBsn = "4444"
            let userEmail = "david@gmail.com"
            
            self.ref?.child("Reports").child(userBsn).child("Name").setValue(userName)
            self.ref?.child("Reports").child(userBsn).child("Email").setValue(userEmail)
            self.ref?.child("Reports").child(userBsn).child("Category").setValue("Lost and found")
            self.ref?.child("Reports").child(userBsn).child("problem name").setValue(lostandfoundText)
            self.ref?.child("Reports").child(userBsn).child("   Extra Info").setValue(textoptional.text)
            
            //This part will only work when we are gonna use an actual phone for our app
            var loc:String? = "Lat: " + myLatitude + ",Long:" + myLongitude
            self.ref?.child("Reports").child(userBsn).child("Location").setValue(loc)
            
            let storageRef = Storage.storage().reference().child(userBsn+".png")
            
            if (self.imageView.image != nil)
            {
                if let uploadData = UIImagePNGRepresentation(self.imageView.image!){
                    
                    storageRef.putData(uploadData, metadata: nil, completion:
                        { (metadata, error) in
                            //to be cleaned later with caution
                            if error != nil{
                                print(error)
                                return
                            }
                            print (metadata)
                            
                            
                            Storage.storage().reference().child(userBsn+".png").downloadURL(completion: { (url, err) in
                                if let err = err{
                                    print("Error downloading image file, \(err.localizedDescription)")
                                    return
                                }
                                guard let url = url else { return }
                                
                                self.ref?.child("Reports").child(userBsn).child("image url")
                                    .setValue(url.absoluteString)
                            })
                    }
                    )
                }
            }
            
            
        }
        else
        {
            // Post problem stuff
            let userName = "David Gerges"
            let userBsn = "4444"
            let userEmail = "david@gmail.com"
            
            self.ref?.child("Reports").child(userBsn).child("Name").setValue(userName)
            self.ref?.child("Reports").child(userBsn).child("Email").setValue(userEmail)
            self.ref?.child("Reports").child(userBsn).child("Category").setValue("Lost and found")
            self.ref?.child("Reports").child(userBsn).child("problem name").setValue(lostandfoundText)
            self.ref?.child("Reports").child(userBsn).child("   Extra Info").setValue(textoptional.text)
        
            let storageRef = Storage.storage().reference().child(userBsn+".png")
            
            if (self.imageView.image != nil)
            {
                if let uploadData = UIImagePNGRepresentation(self.imageView.image!){
                    
                    storageRef.putData(uploadData, metadata: nil, completion:
                        { (metadata, error) in
                            //to be cleaned later with caution
                            if error != nil{
                                print(error)
                                return
                            }
                            print (metadata)
                            
                            
                            Storage.storage().reference().child(userBsn+".png").downloadURL(completion: { (url, err) in
                                if let err = err{
                                    print("Error downloading image file, \(err.localizedDescription)")
                                    return
                                }
                                guard let url = url else { return }
                                
                                self.ref?.child("Reports").child(userBsn).child("image url")
                                    .setValue(url.absoluteString)
                            })
                    }
                    )
                }
            }
           
        }
    }
    
    
    
    
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                print("Camera not available")
            }
           
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(actionSheet, animated: true,completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        selectedImageFromPicker = image
        
        if let selectedImage = selectedImageFromPicker{
            imageView.image = image
        }
        
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    

 
    let problems1PublicSpaces = ["Garbage", "Construction", "Traffic", "Parking", "Paarks"]
    let problems2CityFacilities = ["Gas", "Water", "Electricity", "Education", "Health"]
     let problems3IllegalMatters = ["Theft", "Violence", "Noise", "Fines", "Other"]
     let problems4LostAndFound = ["Lost item", "Found Item", "Other"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        if(pickerView.tag == 1){
            return problems1PublicSpaces[row]
        }
        else if(pickerView.tag == 2){
            return problems2CityFacilities[row]
        }
        else if(pickerView.tag == 3){
            return problems3IllegalMatters[row]
        }
        else{
            return problems4LostAndFound[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if(pickerView.tag  == 1){
            return problems1PublicSpaces.count
        }
        else if(pickerView.tag  == 2){
            return problems2CityFacilities.count
        }
        else if(pickerView.tag  == 3){
            return problems3IllegalMatters.count
        }
        else{
            return problems4LostAndFound.count
        }
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillShow:"), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillHide:"), name:NSNotification.Name.UIKeyboardWillHide, object: nil);

        ref = Database.database().reference()
        
        
        
        picker.selectRow(2, inComponent: 0, animated: true)
        textoptional.layer.borderWidth = 0.5
        textoptional.layer.borderColor = UIColor.darkGray.cgColor
        textoptional.layer.cornerRadius = 5.0
  
    }
    @objc func keyboardWillShow(_ sender:NSNotification) {
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }
    
    @objc func keyboardWillHide(_ sender:NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

