//
//  FirebaseManager.swift
//  NotesApp
//
//  Created by Никита Куприянов on 20.08.2023.
//

import Firebase
import FirebaseFirestore
import FirebaseAuth

class FirebaseManager: NSObject {
    let auth: Auth
    let firestore: Firestore
    
    static var shared = FirebaseManager()
    
    private override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        super.init()
    }
}
