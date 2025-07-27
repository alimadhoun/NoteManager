//
//  CoreDataNotesDataSource.swift
//  NoteManager
//
//  Created by Ali Madhoun on 27/07/2025.
//

import Foundation
import CoreData
import Combine

protocol CoreDataNotesDataSourceProtocol {
    func fetchNotes() throws -> [NoteModel]
    func save(note: NoteModel) throws
    func delete(note: NoteModel) throws
    func update(note: NoteModel) throws
    func observeNotes() -> AnyPublisher<[NoteModel], Never>
}

final class CoreDataNotesDataSource: NSObject, CoreDataNotesDataSourceProtocol {
    
    private let notesSubject = PassthroughSubject<[NoteModel], Never>()
    private let context: NSManagedObjectContext
    
    private lazy var fetchedResultsController: NSFetchedResultsController<NoteEntity> = {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    func fetchNotes() throws -> [NoteModel] {
        do {
            try fetchedResultsController.performFetch()
            guard let noteEntities = fetchedResultsController.fetchedObjects else { return [] }
            return noteEntities.map { $0.toModel() }
        } catch {
            throw CoreDataNotesDataSourceError.fetchError(error.localizedDescription)
        }
    }
    
    func save(note: NoteModel) throws {
        
        let noteEntity = NoteEntity(context: context)
        noteEntity.id = note.id
        noteEntity.title = note.title
        noteEntity.content = note.content
        noteEntity.creationDate = note.creationDate
        
        do {
            try context.save()
        } catch {
            throw CoreDataNotesDataSourceError.saveError(error.localizedDescription)
        }
    }
    
    func delete(note: NoteModel) throws {
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", note.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let noteEntity = results.first {
                context.delete(noteEntity)
                try context.save()
            } else {
                throw CoreDataNotesDataSourceError.deleteError("Note with id \(note.id) not found.")
            }
        } catch {
            throw CoreDataNotesDataSourceError.deleteError(error.localizedDescription)
        }
    }
    
    func update(note: NoteModel) throws {
        
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", note.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let noteEntity = results.first {
                noteEntity.title = note.title
                noteEntity.content = note.content
                noteEntity.creationDate = note.creationDate
                
                try context.save()
            } else {
                throw CoreDataNotesDataSourceError.updateError("Note with id \(note.id) not found.")
            }
        } catch {
            throw CoreDataNotesDataSourceError.updateError(error.localizedDescription)
        }
    }
    
    func observeNotes() -> AnyPublisher<[NoteModel], Never> {
        let observer = notesSubject.eraseToAnyPublisher()
        return observer
    }
    
    private func notifyListeners() {
        
        let notes = (try? fetchNotes()) ?? []
        notesSubject.send(notes)
    }
}

extension CoreDataNotesDataSource: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        notifyListeners()
    }
}

enum CoreDataNotesDataSourceError: Error, LocalizedError {
    
    case fetchError(String)
    case saveError(String)
    case deleteError(String)
    case updateError(String)
    
    var errorDescription: String? {
        switch self {
        case .fetchError(let message):
            return "Fetch Error: \(message)"
        case .saveError(let message):
            return "Save Error: \(message)"
        case .deleteError(let message):
            return "Delete Error: \(message)"
        case .updateError(let message):
            return "Update Error: \(message)"
        }
    }
}

