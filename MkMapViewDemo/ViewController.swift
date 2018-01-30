//
//  ViewController.swift
//  MkMapViewDemo
//
//  Created by Botla on 30/01/18.
//  Copyright © 2018 wrc. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchButton(_ sender: Any) {
        // Adding SearchBar Filed to the NavigationBar
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Ignoring user interaction until location get
        UIApplication.shared.beginIgnoringInteractionEvents()

        // Creating ActivityIndicator to indicate user for loading location
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        // Adding activityIndicator to view
        self.view.addSubview(activityIndicator)
        
        // Hide searchBar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        // Create the search request for getting input from user
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        // Create the active search for making local search
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            
            // stop animating activityIndicator when you location will find
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil {
                print("Error")
            }
            else {
                // Remove annotaions. i.e. Here, each time you will get a new location. So, the previous location will be removed and displayed new location.
                let annotation = self.mapView.annotations
                self.mapView.removeAnnotations(annotation)
                
                // Getting data. i.e. lattitude and longitude
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                // Create Annotation for display your location point
                let annotaion = MKPointAnnotation()
                annotaion.title = searchBar.text
                annotaion.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(annotaion)
                
                // Zooming in on annotaion
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                
                // How much you want to zoom
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
}

