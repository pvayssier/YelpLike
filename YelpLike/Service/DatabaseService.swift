//
//  Database Service.swift
//  YelpLike
//
//  Created by Paul Vayssier on 03/05/2023.
//

import Foundation
import FirebaseAppCheck
import FirebaseCore
import FirebaseFirestore

class DatabaseService: ObservableObject{
    static var shared = DatabaseService()

    private let db = Firestore.firestore()


    func createUser(username: String, password: String) {
        var ref: DocumentReference? = nil
        ref = db.collection("Users").addDocument(data: [
            "user_id": numberOfUser(),
            "username": "admin",
            "role": "classic"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }

    private func numberOfUser() -> Int {
        var numberOfUser = 0
        db.collection("Users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let test = querySnapshot!.documents.first?.data().filter({ (key: String, value: Any) in key == "user_id"}) else { return }
                numberOfUser = test["user_id"]! as! Int
            }
        }
        return numberOfUser
    }

    var session: String = ""

    func checkIfConnect() async -> Bool {
        var sessionUUID = Array<String>()
        db.collection("Users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let _ = querySnapshot?.documents.map( {
                    sessionUUID.append(String(describing: $0.data()["sessionUUID"]))
                }) else { return }
//                    .data().filter({ (key: String, value: Any) in key == "sessionUUID"}) else { return }
                print("inside",sessionUUID)
            }
        }
        print("outside",sessionUUID)
        print(session, sessionUUID)
        return sessionUUID.filter( { $0 == session } ).count > 0
    }

}
