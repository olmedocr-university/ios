//
//  Track+CoreDataProperties.swift
//  MyPlayer
//
//  Created by Raul Olmedo on 4/1/21.
//
//

import Foundation
import CoreData


extension Track {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Track> {
        return NSFetchRequest<Track>(entityName: "Track")
    }

    @NSManaged public var name: String?

}

extension Track : Identifiable {

}
