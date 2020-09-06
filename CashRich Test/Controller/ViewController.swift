//
//  ViewController.swift
//  CashRich Test
//
//  Created by Moideen Nazaif VM on 06/09/20.
//  Copyright © 2020 Moideen Nazaif VM. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        
    }
    
    @IBAction func onClickCurrentLocation(_ sender: Any) {
        setupCoreLocation()
    }
    
    
    func setupCoreLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
            
        case .authorizedAlways:
            enableLocationServices()
        default:
            break
        }
    }
    
    func enableLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            mapView.setUserTrackingMode(.follow, animated: true)
        }
        
        if CLLocationManager.headingAvailable() {
            locationManager.startUpdatingHeading()
        } else {
            print("heading not available")
        }
        
    }
    
    func disableLocationServices() {
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func onLongPressMapView(_ sender: UILongPressGestureRecognizer) {
        disableLocationServices()
        if sender.state != UIGestureRecognizer.State.began { return }
           let touchLocation = sender.location(in: mapView)
           let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        
           print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        let vc = storyboard?.instantiateViewController(withIdentifier: "WeatherDataViewController") as! WeatherDataViewController
        
        vc.location = locationCoordinate
        navigationController?.pushViewController(vc,
        animated: true)

    }
    
    
}

