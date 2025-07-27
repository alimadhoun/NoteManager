//
//  NotesRepository.swift
//  NoteManager
//
//  Created by Ali Madhoun on 27/07/2025.
//

import Foundation
import Combine

protocol NotesRepository {
    
    func fetchAllNotes() throws -> [NoteModel]
    func addNote(_ note: NoteModel) throws
    func updateNote(_ note: NoteModel) throws
    func deleteNote(_ note: NoteModel) throws
    func observeNotes() -> AnyPublisher<[NoteModel], Never>
}
