//
//  NoteEntity+CoreDataProperties.swift
//  NoteManager
//
//  Created by Ali Madhoun on 27/07/2025.
//
//

import Foundation
import CoreData


extension NoteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteEntity> {
        return NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var creationDate: Date?

}

extension NoteEntity : Identifiable {

}
