//
//  NotesViewController.swift
//  NoteManager
//
//  Created by Ali Madhoun on 27/07/2025.
//

import UIKit
import Combine

class NotesViewController: UIViewController {
    
    private let viewModel: NotesViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableViewController: UITableView = {
        
        var tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.ID)
        tv.estimatedRowHeight = 76
        tv.separatorStyle = .singleLine
        return tv
    }()
    
    init(viewModel: NotesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupToolBar()
        setupViews()
        setupSearchBar()
        observeNotes()
    }
    
    private func setupToolBar() {
        self.title = "Notes App"
        navigationController?.setToolbarHidden(false, animated: true)
        
        let addButton = UIBarButtonItem(
            systemItem: .add,
            primaryAction: UIAction { _ in
                self.showCreateNewNoteAlert()
            }
        )
        
        toolbarItems = [addButton]
    }
    
    private func showCreateNewNoteAlert() {
        
        let alert = UIAlertController(title: "New Note", message: "Please, Enter note title and content", preferredStyle: .alert)
        alert.addTextField { tf in
            tf.placeholder = "Title"
        }
        
        alert.addTextField { tf in
            tf.placeholder = "Content"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            guard let self = self, let title = alert.textFields?[0].text, !title.isEmpty,
                  let content = alert.textFields?[1].text, !content.isEmpty else {
                
                debugPrint("Missing Note Details.")
                return
            }
            
            self.viewModel.addNote(title: title, content: content)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func setupViews() {
        view.addSubview(tableViewController)
        
        NSLayoutConstraint.activate([
            tableViewController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableViewController.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableViewController.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewController.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Notes"
        navigationItem.searchController = searchController
    }
    
    private func observeNotes() {
        viewModel.$filteredNotes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableViewController.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.ID, for: indexPath) as? NoteTableViewCell else {
            return UITableViewCell()
        }
        
        let note = viewModel.filteredNotes[indexPath.row]
        cell.configure(with: note)
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Delete Action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let note = self.viewModel.filteredNotes[indexPath.row]
            self.viewModel.deleteNote(note: note)
            completionHandler(true)
        }
        
        // Edit Action
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let note = self.viewModel.filteredNotes[indexPath.row]
            
            let alert = UIAlertController(title: "Edit Note", message: "Please, update note title and content", preferredStyle: .alert)
            alert.addTextField { tf in
                tf.placeholder = "Title"
                tf.text = note.title
            }
            
            alert.addTextField { tf in
                tf.placeholder = "Content"
                tf.text = note.content
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
                guard let self = self, let title = alert.textFields?[0].text, !title.isEmpty,
                      let content = alert.textFields?[1].text, !content.isEmpty else {
                    debugPrint("Missing Note Details.")
                    return
                }
                
                let updatedNote = NoteModel(id: note.id, title: title, content: content, creationDate: note.creationDate)
                self.viewModel.updateNote(note: updatedNote)
            }))
            
            self.present(alert, animated: true, completion: nil)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}

extension NotesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchNotes(with: searchController.searchBar.text ?? "")
    }
}
