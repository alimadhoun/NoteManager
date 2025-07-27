//
//  NoteEntity+Mapping.swift
//  NoteManager
//
//  Created by Ali Madhoun on 27/07/2025.
//

import Foundation
import CoreData

extension NoteEntity {
    
    func toModel() -> NoteModel {
        return NoteModel(id: id ?? UUID(),
                         title: title ?? "",
                         content: content ?? "",
                         creationDate: creationDate ?? Date())
    }
}
