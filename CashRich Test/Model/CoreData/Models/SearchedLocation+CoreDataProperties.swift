//
//  SearchedLocation+CoreDataProperties.swift
//  
//
//  Created by Moideen Nazaif VM on 06/09/20.
//
//

import Foundation
import CoreData


extension SearchedLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchedLocation> {
        return NSFetchRequest<SearchedLocation>(entityName: "SearchedLocation")
    }

    @NSManaged public var humidity: Double
    @NSManaged public var maxTemp: Double
    @NSManaged public var minTemp: Double
    @NSManaged public var name: String?
    @NSManaged public var pressure: Double
    @NSManaged public var temp: Double
    @NSManaged public var weather: String?
    @NSManaged public var latitude: Int64
    @NSManaged public var longitude: Int64

}
