//
//  WeatherDataViewController.swift
//  CashRich Test
//
//  Created by Moideen Nazaif VM on 06/09/20.
//  Copyright © 2020 Moideen Nazaif VM. All rights reserved.
//

import UIKit
import MapKit
import TTGSnackbar
import CoreData

class WeatherDataViewController: UIViewController {
    
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var location: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkInLocal()
    }
    
    func checkInLocal() {
        setLoadingTo(true)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: SearchedLocation.self))
        do {
            let locations = try CoreDataStack.sharedInstance.persistentContainer.viewContext.fetch(fetchRequest) as? [SearchedLocation]
            if let fetchedLocation = locations?.first(where: { (savedLocation) -> Bool in
                savedLocation.latitude == Int64(location.latitude) && savedLocation.longitude == Int64(location.longitude)
            }) {
                setLoadingTo(false)
                print("From Coredata; ", fetchedLocation.name)
                nameLabel.text = fetchedLocation.name ?? "No Data"
                weatherLabel.text = "Weather: \(String(describing: fetchedLocation.weather!))"
                temperatureLabel.text = "\(String(describing: fetchedLocation.temp)) ºF"
                minTempLabel.text = "\(String(describing: fetchedLocation.minTemp)) ºF"
                maxTempLabel.text = "\(String(describing: fetchedLocation.maxTemp)) ºF"
                pressureLabel.text = "\(String(describing: fetchedLocation.pressure)) Pa"
                humidityLabel.text = "\(String(describing: fetchedLocation.humidity)) RH"
            } else {
                getWeatherData()
            }
        } catch(let error) {
            print(error.localizedDescription)
        }
        
        
    }
    
    func getWeatherData() {
        Parser.getWeatherDataFor(location: location, completion: handlegetWeatherDataResponse(response:error:))
    }
    
    func handlegetWeatherDataResponse(response: WeatherDataResponse?, error: Error?) {
        setLoadingTo(false)
        if let response = response, error == nil {
            nameLabel.text = response.name ?? "No name"
            weatherLabel.text = "Weather: \(String(describing: response.weather![0].main!))"
            temperatureLabel.text = "\(String(describing: response.main!.temp!)) ºF"
            minTempLabel.text = "\(String(describing: response.main!.tempMin!)) ºF"
            maxTempLabel.text = "\(String(describing: response.main!.tempMax!)) ºF"
            pressureLabel.text = "\(String(describing: response.main!.pressure!)) Pa"
            humidityLabel.text = "\(String(describing: response.main!.humidity!)) RH"
            _ = createLocationEntityFrom(response)
            do {
                try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
            }catch let error {
                print(error.localizedDescription)
            }
        } else {
            let snackbar = TTGSnackbar(message: "Error occurred: \(error!.localizedDescription )", duration: .short)
            snackbar.show()
        }
    }
    
    func setLoadingTo(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }
    
    func createLocationEntityFrom(_ weatherResponse: WeatherDataResponse) -> NSManagedObject?  {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let locationEntity = NSEntityDescription.insertNewObject(forEntityName: "SearchedLocation", into: context) as? SearchedLocation {
            locationEntity.humidity = Double((weatherResponse.main?.humidity)!)
            locationEntity.maxTemp = Double((weatherResponse.main?.tempMax)!)
            locationEntity.minTemp = Double((weatherResponse.main?.tempMin)!)
            locationEntity.pressure = Double((weatherResponse.main?.pressure)!)
            locationEntity.humidity = Double((weatherResponse.main?.humidity)!)
            locationEntity.temp = Double((weatherResponse.main?.temp)!)
            locationEntity.name = weatherResponse.name!
            locationEntity.weather = weatherResponse.weather![0].main!
            locationEntity.latitude = Int64(location.latitude)
            locationEntity.longitude = Int64(location.longitude)
            print("Saved to Local")
            return locationEntity
        }
        return nil
    }
}
