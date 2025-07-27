# NoteManager

An iOS notes app built with Swift and UIKit, following Clean Architecture principles.

## ✨ Features

- Create, edit, and delete notes
- Real-time search by title/content
- Local storage via Core Data
- MVVM + Combine for reactive UI
- Clean, modern UIKit interface

## 🧱 Architecture

Follows Clean Architecture:


- **Presentation**: UIKit views, view models (MVVM)
- **Domain**: Use cases, entities, repositories
- **Data**: Core Data + mockable sources

## 🛠️ Tech Stack

- Swift 5, UIKit, Combine
- Core Data (persistence)
- Manual DI
- XCTest (unit testing)

## 🚀 Getting Started

1. Clone repo  
   `git clone https://github.com/alimadhoun/NoteManager.git`
2. Open project  
   `open NoteManager.xcodeproj`
3. Run the app  
   `Cmd + R`

## 📂 Project Structure
```
NoteManager/
├── Presentation/
│   ├── Views/
│   │   ├── NotesViewController.swift
│   │   └── NoteTableViewCell.swift
│   └── ViewModels/
│       └── NotesViewModel.swift
├── Domain/
│   ├── Entities/
│   │   ├── NoteModel.swift
│   │   ├── NoteEntity+CoreDataClass.swift
│   │   ├── NoteEntity+CoreDataProperties.swift
│   │   └── NoteEntity+Mapping.swift
│   ├── Repositories/
│   │   └── NotesRepository.swift
│   └── UseCases/
│       └── NotesUseCase.swift
├── Data/
│   ├── DateSources/
│   │   ├── CoreDataNotesDataSource.swift
│   │   └── MockDataNotesDataSource.swift
│   └── Repositories/
│       └── NotesRepositoryImp.swift
├── CoreData/
│   ├── CoreDataStack.swift
│   └── NotesModel.xcdatamodeld/
├── Core/
│   └── Extensions/
│       └── Date+Extension.swift
└── Delegates/
    ├── AppDelegate.swift
    └── SceneDelegate.swift
```


## 🧪 Tests

Run unit tests with `Cmd + U` or:

```bash
xcodebuild test -project NoteManager.xcodeproj -scheme NoteManager

