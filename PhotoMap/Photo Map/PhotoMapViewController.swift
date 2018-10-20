//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, LocationsViewControllerDelegate {
  
    @IBOutlet weak var tucsonMap: MKMapView!
    var tempImg: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let TURegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(32.253460, -110.911789), MKCoordinateSpanMake(0.1, 0.1))
        tucsonMap.setRegion(TURegion, animated: false)
        tucsonMap.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hitCameraButt(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        tempImg = originalImage
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "tagSegue", sender: nil)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "tagSegue"){
            if let destin = segue.destination as? LocationsViewController{
               destin.delegate = self
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber){
        let newCord = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
        let annotation = photoAnno()
        annotation.coordinate = newCord
        annotation.photo = tempImg
        tucsonMap.addAnnotation(annotation)
        self.navigationController?.popViewController(animated: true)
        
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let reuseID = "myAnnotationView"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
            if (annotationView == nil) {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
                annotationView!.canShowCallout = true
                annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
            }
            
            let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        if let annotation = annotationView?.annotation as? photoAnno{
            
            imageView.image = annotation.photo
        }else{
            imageView.image = UIImage(named: "camera")
        }
            return annotationView
    }
    
}
