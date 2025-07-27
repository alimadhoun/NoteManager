//
//  NotesRepositoryImp.swift
//  NoteManager
//
//  Created by Ali Madhoun on 27/07/2025.
//

import Foundation
import Combine

final class NotesRepositoryImp: NotesRepository {
    
    private let notesDataSource: CoreDataNotesDataSourceProtocol
    
    init(notesDataSource: CoreDataNotesDataSourceProtocol) {
        self.notesDataSource = notesDataSource
    }
    
    func fetchAllNotes() throws -> [NoteModel] {
        try notesDataSource.fetchNotes()
    }
    
    func addNote(_ note: NoteModel) throws {
        try notesDataSource.save(note: note)
    }
    
    func updateNote(_ note: NoteModel) throws {
        try notesDataSource.update(note: note)
    }
    
    func deleteNote(_ note: NoteModel) throws {
        try notesDataSource.delete(note: note)
    }
    
    func observeNotes() -> AnyPublisher<[NoteModel], Never> {
        notesDataSource.observeNotes()
    }
}
