//
//  FireBaseService.swift
//  notebook
//
//  Created by Filippo on 14/02/23.
//

import Foundation
import Firebase
import SwiftUI

class FireBaseService {
    private var db = Firestore.firestore() //holds the database object
    private let notes = "notes"
    var dnotes = [CloudNote]()
    
    func addNote(txt:String){
        let doc = db.collection(notes).document() // creates a new empty document
        var data = [String:String]() //creates empty dictionary
        data["text"] = txt
        doc.setData(data) //saves to Firestore
    }
    
    func startListener(){
        db.collection(notes).addSnapshotListener { snap,error in
            if let e = error{
                print("some error loading data \(e)")
            } else {
                if let snap = snap {
                    self.dnotes.removeAll()
                    for doc in snap.documents{
                        if let txt = doc.data()["text"] as? String{
                            print(txt)
                            let note = CloudNote(id: doc.documentID, text: text)
                            self.dnotes.append(note)
                        }
                    }
                }
            }
        }
    }
}
