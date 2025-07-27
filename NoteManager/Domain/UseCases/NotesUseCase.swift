//
//  NotesUseCase.swift
//  NoteManager
//
//  Created by Ali Madhoun on 27/07/2025.
//

import Foundation
import Combine

protocol NotesUseCase {
    func fetchNotes() throws -> [NoteModel]
    func observeNotes() -> AnyPublisher<[NoteModel], Never>
    func addNote(_ note: NoteModel) throws
    func updateNote(_ note: NoteModel) throws
    func deleteNote(_ note: NoteModel) throws
}

final class NotesUseCaseImp: NotesUseCase {
 
    private let notesRepository: NotesRepository
    
    init(notesRepository: NotesRepository) {
        self.notesRepository = notesRepository
    }
    
    func fetchNotes() throws -> [NoteModel] {
        try notesRepository.fetchAllNotes()
    }
    
    func observeNotes() -> AnyPublisher<[NoteModel], Never> {
        notesRepository.observeNotes()
    }
    
    func addNote(_ note: NoteModel) throws {
        try notesRepository.addNote(note)
    }
    
    func updateNote(_ note: NoteModel) throws {
        try notesRepository.updateNote(note)
    }
    
    func deleteNote(_ note: NoteModel) throws {
        try notesRepository.deleteNote(note)
    }
}
