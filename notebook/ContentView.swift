//
//  ContentView.swift
//  notebook
//
//  Created by Filippo on 08/02/23.
//

import SwiftUI

struct Note: Codable, Identifiable {
    var id = UUID()
    var title: String
    var text: String
}

class NotesStore: ObservableObject {
    @Published var notes = [Note]()
    
    init() {
        if let notesData = UserDefaults.standard.data(forKey: "notes") {
            if let decodedNotes = try? JSONDecoder().decode([Note].self, from: notesData) {
                notes = decodedNotes
            }
        }
    }
    
    func addNote(title: String, text: String) {
        let newNote = Note(title: title, text: text)
        notes.append(newNote)
        saveNotes()
    }
    
    func saveNotes() {
        if let encodedNotes = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encodedNotes, forKey: "notes")
        }
    }
}

struct ContentView: View {
    @ObservedObject var store = NotesStore()
    var fService = FireBaseService()
    var body: some View {
        NavigationView {
            List {
                ForEach(store.notes) { note in
                    NavigationLink(destination: NoteDetailView(note: note, store: self.store)) {
                        Text(note.title)
                
                    }
                }
                .onDelete { indices in
                    indices.forEach { self.store.notes.remove(at: $0) }
                }
            }
            .navigationBarTitle("Notes")
            
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.store.addNote(title: "", text: "")
                
            }, label: {
                Image(systemName: "plus")
            }))
        }.onAppear{fService.startListener()}
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
