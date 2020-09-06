//
//  ApiParser.swift
//  CashRich Test
//
//  Created by Moideen Nazaif VM on 06/09/20.
//  Copyright © 2020 Moideen Nazaif VM. All rights reserved.
//

import Foundation
import CoreLocation

class Parser {
    enum Endpoints {
        static let base = "http://api.openweathermap.org/data/2.5"
        static let apiKey =  "51fec1207a1fdae4916f3058f7bd3c5f"
        case weatherForLocation( CLLocationCoordinate2D)
        
        var stringValue: String {
            switch self {
            case .weatherForLocation(let location):
                return Endpoints.base + "/weather?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(Endpoints.apiKey)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getWeatherDataFor(location: CLLocationCoordinate2D, completion: @escaping (WeatherDataResponse?,Error?) -> Void) {
        print(Endpoints.weatherForLocation(location).stringValue)
        var request = URLRequest(url: Endpoints.weatherForLocation(location).url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            print(String(data: data, encoding: .utf8)!)
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(WeatherDataResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch(let err) {
                DispatchQueue.main.async {
                    completion(nil, err)
                }
            }
        }
        
        task.resume()
    }
}
