//
//  MockDataNotesDataSoure.swift
//  NoteManager
//
//  Created by Ali Madhoun on 27/07/2025.
//

import Foundation
import Combine

final class MockDataNotesDataSource: CoreDataNotesDataSourceProtocol {
    
    private var notes: [NoteModel] = [
        .init(id: UUID(), title: "Title 1", content: "This is Note Number Number 1", creationDate: Date()),
        .init(id: UUID(), title: "Title 2", content: "This is Note Number 2", creationDate: Date()),
        .init(id: UUID(), title: "Title 3", content: "This is Note Number 3", creationDate: Date())
    ] {
        didSet {
            notesPublisher.send(notes)
        }
    }
    
    private let notesPublisher = PassthroughSubject<[NoteModel], Never>()
    
    func fetchNotes() throws -> [NoteModel] {
        return notes
    }
    
    func save(note: NoteModel) throws {
        notes.append(note)
    }
    
    func delete(note: NoteModel) throws {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes.remove(at: index)
        } else {
            throw CoreDataNotesDataSourceError.deleteError("Note not found")
        }
    }
    
    func update(note: NoteModel) throws {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
        } else {
            throw CoreDataNotesDataSourceError.updateError("Note not found")
        }
    }
    
    func observeNotes() -> AnyPublisher<[NoteModel], Never> {
        return notesPublisher
            .eraseToAnyPublisher()
    }
}
