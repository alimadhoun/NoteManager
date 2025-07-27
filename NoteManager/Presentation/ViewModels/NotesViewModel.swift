//
//  NotesViewModel.swift
//  NoteManager
//
//  Created by Ali Madhoun on 27/07/2025.
//

import Foundation
import Combine

final class NotesViewModel {
    
    @Published var allNotes: [NoteModel] = []
    @Published var filteredNotes: [NoteModel] = []
    @Published var searchQuery: String = ""
    
    private let useCase: NotesUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(useCase: NotesUseCase) {
        self.useCase = useCase
        useCase.observeNotes()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notes in
                self?.allNotes = notes
                self?.filteredNotes = notes
            }
            .store(in: &cancellables)
        
        fetchNotes()
        
        $searchQuery
            .combineLatest($allNotes)
            .map { query, notes in
                if query != "" {
                    return notes.filter({
                        $0.content.lowercased().contains(query.lowercased()) ||
                        $0.title.lowercased().contains(query.lowercased())
                    })
                } else {
                    return notes
                }
            }
            .assign(to: &$filteredNotes)
    }
    
    func fetchNotes() {
        do {
            allNotes = try useCase.fetchNotes()
        } catch {
            print("Error fetching notes: \(error)")
        }
    }
    
    func addNote(title: String, content: String) {
        let note = NoteModel(id: UUID(), title: title, content: content, creationDate: Date())
        do {
            try useCase.addNote(note)
        } catch {
            print("Error adding note: \(error)")
        }
    }
    
    func updateNote(note: NoteModel) {
        do {
            try useCase.updateNote(note)
        } catch {
            print("Error updating note: \(error)")
        }
    }
    
    func deleteNote(note: NoteModel) {
        do {
            try useCase.deleteNote(note)
        } catch {
            print("Error deleting note: \(error)")
        }
    }
    
    func searchNotes(with query: String) {
        searchQuery = query
    }
}
