//
//  NoteManagerTests.swift
//  NoteManagerTests
//
//  Created by Ali Madhoun on 27/07/2025.
//

import XCTest
import Combine
@testable import NoteManager

final class NoteManagerTests: XCTestCase {

    var mockDataSource: MockDataNotesDataSource!
    var viewModel: NotesViewModel!
    
    private var cancelables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        
        mockDataSource = MockDataNotesDataSource()
        let repository = NotesRepositoryImp(notesDataSource: mockDataSource)
        let useCase = NotesUseCaseImp(notesRepository: repository)
        viewModel = NotesViewModel(useCase: useCase)
    }
    
    override func tearDown() {
        super.tearDown()
        
        mockDataSource = nil
        viewModel = nil
    }
    
    func test_createNote_addsNoteSuccessfully() {
        
        // 1- Get initial Notes Count
        let initialCount = viewModel.allNotes.count
        
        // 2- Create a New Note
        viewModel.addNote(title: "New Note", content: "This is a new note")
        
        // 3- Fetch Notes
        viewModel.fetchNotes()
        
        // 4- Assert the Note is Added
        XCTAssertEqual(viewModel.allNotes.count, initialCount + 1)
    }
    
    func test_createNote_addsNoteDetailsCorrectly() {
                
        // 1- Create a New Note
        viewModel.addNote(title: "Test correctness", content: "This is a new test to verify that note details is saved correctly")
        
        // 2- Fetch Notes
        viewModel.fetchNotes()
        
        // 4- Assert the Note is Added
        XCTAssertEqual(viewModel.allNotes.last?.title, "Test correctness")
        XCTAssertEqual(viewModel.allNotes.last?.content, "This is a new test to verify that note details is saved correctly")
    }
    
    func test_deleteNote_removesNoteCorrectly() {
                
        // 1- Create a New Note
        viewModel.addNote(title: "Note to delete", content: "This note will be deleted")
        
        // 2- Fetch Notes
        viewModel.fetchNotes()
        
        // 3- Get initial Notes Count
        let initialCount = viewModel.allNotes.count
                
        // 4- Delete the Note
       guard let noteToDelete = viewModel.allNotes.last else {
            XCTFail("No note to delete")
            return
        }
        
        viewModel.deleteNote(note: noteToDelete)
        
        // 5- Fetch Notes Again
        viewModel.fetchNotes()
        
        // 6- Assert the Note is Deleted
        XCTAssertEqual(viewModel.allNotes.count, initialCount - 1)
    }
    
    func test_deleteNote_throwsErrorWhenDeletingNonExistentNote() {
        
        // 1- Create a New Note
        let note = NoteModel(id: UUID(), title: "New Note", content: "Note to delete", creationDate: Date())
        
        // 2- Verify service throws error when trying to delete a note that does not exist
        XCTAssertThrowsError(try mockDataSource.delete(note: note))
    }
    
    
    func test_updateNote_updatesNoteDetailsCorrectly() {
        
        // 1- Create a New Note
        viewModel.addNote(title: "Note to update", content: "This note will be updated")
        
        // 2- Fetch Notes
        viewModel.fetchNotes()
        
        // 3- Get the Last Note
        guard var noteToUpdate = viewModel.allNotes.last else {
            XCTFail("No note to update")
            return
        }
        
        // 4- Update the Note Details
        let updatedNote = NoteModel(
            id: noteToUpdate.id,
            title: "Updated Note Title",
            content: "Updated Note Content",
            creationDate: noteToUpdate.creationDate
        )
        
        viewModel.updateNote(note: updatedNote)
        
        // 5- Fetch Notes Again
        viewModel.fetchNotes()
        
        // 6- Assert the Note is Updated
        XCTAssertEqual(viewModel.allNotes.last?.title, "Updated Note Title")
        XCTAssertEqual(viewModel.allNotes.last?.content, "Updated Note Content")
    }
    
    func test_notesPublisher_emitsChanges() {
        
        // 1- Create an expectation
        let expectation = self.expectation(description: "Notes Publisher emits changes")
        
        // 2- Subscribe to the notes publisher
        viewModel.$allNotes
            .sink { notes in
                // 3- Assert that the notes count is greater than 0
                XCTAssertGreaterThan(notes.count, 0)
                expectation.fulfill()
            }
            .store(in: &cancelables)
        
        // 4- Add a new note to trigger the publisher
        viewModel.addNote(title: "Publisher Test", content: "Testing notes publisher")
        
        wait(for: [expectation], timeout: 0.5)
    }

}
