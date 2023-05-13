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
import Network

class DatabaseService {

    init() {
        getNumberOfRow(for: "Users", with: "user_id") { [weak self] numberOfUser in
            self?.numberOfUser = numberOfUser
        }

        getNumberOfRow(for: "Restaurant", with: "restaurant_id") { [weak self] numberOfRestaurant in
            self?.numberOfRestaurant = numberOfRestaurant
        }

        getNumberOfRow(for: "Review", with: "review_id") { [weak self] numberOfReview in
            self?.numberOfReview = numberOfReview

        }
    }



    // MARK: - Combine

    @Published var isConnect: Bool = false

    @Published private(set) var didHaveNetwork: Bool = true
    
    @Published var isLoading: Bool = false

    func hasInternetConnection() {
        let monitor = NWPathMonitor()
        let semaphore = DispatchSemaphore(value: 0)
        var isConnected = false
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                isConnected = true
            } else {
                isConnected = false
            }
            semaphore.signal()
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        semaphore.wait()
        print(isConnected)
        didHaveNetwork = isConnected
    }

    // MARK: - Exposed

    static var shared = DatabaseService()

    var session: String = ""

    var userInfo: [String: Any] = [:]

    func checkIfConnect(for sessionUUID: String) {
        let db = Firestore.firestore()
        let usersCollection = "Users"
        let usersRef = db.collection(usersCollection)

        usersRef.whereField("sessionUUID", isEqualTo: sessionUUID).getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                print("Erreur lors de la récupération des informations de l'utilisateur : \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("Aucun document trouvé")
                return
            }

            for document in documents {
                let data = document.data()
                if let username = data["username"] as? String,
                   let userId = data["user_id"] as? Int{
                    self?.userInfo["username"] = username
                    self?.userInfo["user_id"] = userId
                }
            }
        }
    }

    func checkUserCredentials(username: String, password: String, completion: @escaping (Error?) -> Void) {
        guard didHaveNetwork else { return }
        let db = Firestore.firestore()
        let usersRef = db.collection("Users")
        // Check if username match
        usersRef.whereField("username", isEqualTo: username).getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                completion(error)
                return
            }
            // If the username already exist, check the password
            if let document = querySnapshot?.documents.first {
                let data = document.data()
                if let savedPassword = data["password"] as? String {
                    if savedPassword == password {
                        let sessionUUID = UUID()
                        usersRef.document(document.documentID).updateData(["sessionUUID": String(describing: sessionUUID)]) { (error) in
                            if let error = error {
                                debugPrint("error to modify sessionUUID")
                                completion(error)
                            }else{
                                UserDefaults.standard.set(String(describing: sessionUUID), forKey: "sessionUUID")
                                completion(nil)
                            }
                            guard let sessionUserDefault = UserDefaults.standard.string(forKey: "sessionUUID") else { return }
                            self?.checkIfConnect(for: sessionUserDefault)
                            return
                        }

                    } else {
                        completion(NSError(
                            domain: "",
                            code: 401,
                            userInfo: [NSLocalizedDescriptionKey: "Mot de passe incorrect"]
                        ))
                    }
                } else {
                    completion(NSError(
                        domain: "",
                        code: 500,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Le mot de passe n'est pas enregistré pour cet utilisateur"
                        ]
                    ))
                }
            } else {
                // Create a new user if username don't match
                let sessionUUID = UUID()
                let newUser = [
                    "user_id": (self!.numberOfUser ?? 0 as Int) + 1,
                    "username": username,
                    "password": password,
                    "role": "classic",
                    "sessionUUID": String(describing: sessionUUID)
                ] as [String: Any]
                usersRef.addDocument(data: newUser) { (error) in
                    completion(error)
                }
                UserDefaults.standard.set(String(describing: sessionUUID), forKey: "sessionUUID")
                self?.checkIfConnect(for: String(describing: sessionUUID))
                completion(nil)
            }
        }
    }

    func addPlace(place: Place, completion: @escaping (Error?) -> Void) {
        guard didHaveNetwork else { return }
        let db = Firestore.firestore()
        let restaurantRef = db.collection("Restaurant")
        // Check if name of restaurant match
        restaurantRef.whereField("name", isEqualTo: place.name).getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                completion(error)
                return
            }
            // The restaurant already exist
            if let _ = querySnapshot?.documents.first {
                completion(nil)
            } else {
                // Create a new restaurant
                var newRestaurant = [
                    "restaurant_id": (self!.numberOfRestaurant ?? 0 as Int) + 1,
                    "name": place.name,
                    "cookStyle": String(describing: place.cookStyle),
                    "description": place.description,
                ] as [String: Any]
                if let firstImage = place.imagePaths.first,
                   let image = UIImage(named: firstImage),
                   let imageData = image.pngData() {
                    let base64String = imageData.base64EncodedString(options: [])
                    newRestaurant["image"] = base64String
                } else {
                    newRestaurant["image"] = "basic"
                }
                restaurantRef.addDocument(data: newRestaurant) { (error) in
                    completion(error)
                }
                completion(nil)
            }
        }
    }

    func addReview(review: Review, completion: @escaping (Error?) -> Void) {
        guard didHaveNetwork else { return }
        let db = Firestore.firestore()
        let restaurantRef = db.collection("Restaurant")
        let reviewRef = db.collection("Review")
        // Check if name of restaurant match
        restaurantRef.whereField("name", isEqualTo: review.name).getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                completion(error)
                return
            }
            // If the Restaurant exists then I add the Review
            if let _ = querySnapshot?.documents.first {
                guard let self else {
                    completion(NSError(domain: "", code: 501, userInfo: [NSLocalizedDescriptionKey: "Error please retry"]))
                    return

                }
                var newReview = [
                    "review_id": (self.numberOfReview ?? 0 as Int) + 1,
                    "name": review.name,
                    "title": review.title,
                    "content": review.content,
                    "rate": review.rate,
                    "user_id": userInfo["user_id"] as! Int
                ] as [String: Any]
                if let image = UIImage(named: review.imagePaths.first ?? "basic") {
                    if let imageData = image.pngData() {
                        let base64String = imageData.base64EncodedString(options: [])
                        newReview["image"] = base64String
                    } else {
                        newReview["image"] = "basic"
                    }
                } else {
                    newReview["image"] = "basic"
                }
                reviewRef.addDocument(data: newReview) { (error) in
                    completion(error)
                }
                completion(nil)
            } else {
                // The restaurant does not exist
                completion(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "restaurant does not exist yet"]))
            }
        }
    }

    func getAllDocuments(of collection: String, completion: @escaping ([Place]?, [Review]?) -> Void) {
        guard didHaveNetwork else { return }
        let db = Firestore.firestore()
        let ref = db.collection(collection)
        isLoading = true
        ref.getDocuments { (snapshot, error) in

            if let error = error {
                debugPrint("Erreur lors de la récupération des documents : \(error.localizedDescription)")
                return
            }

            guard let snapshot = snapshot else {
                debugPrint("Aucun document trouvé")
                return
            }
            var tab: [Any] = []
            for document in snapshot.documents {
                let documentData = document.data()
                if collection == "Restaurant" {
                    let place = Place(
                        name: documentData["name"] as! String,
                        cookStyle: CookStyle(rawValue: documentData["cookStyle"] as! String) ?? CookStyle.french,
                        description: documentData["description"] as! String,
                        imagePaths: [documentData["image"] as! String]
                    )
                    tab.append(place)
                } else if collection == "Review" {
                    let review = Review(
                        placeId: UUID(),
                        title: documentData["title"] as! String,
                        content: documentData["content"] as! String,
                        imagePaths: [documentData["image"] as! String],
                        rate: documentData["rate"] as! Int,
                        name: documentData["name"] as! String
                    )
                    tab.append(review)
                }
            }
            if collection == "Restaurant" {
                completion(tab as? [Place], nil)
            } else {
                completion(nil, tab as? [Review])
            }
        }
    }

    func getUserReviews(completion: (@escaping ([Review]) -> Void )) {
        guard didHaveNetwork else { return }
        let db = Firestore.firestore()
        let ref = db.collection("Review")
        isLoading = true
        ref.whereField("user_id", isEqualTo: userInfo["user_id"] as! Int).getDocuments { (snapshot, error) in

            if let error = error {
                debugPrint("Erreur lors de la récupération des documents : \(error.localizedDescription)")
                return
            }

            guard let snapshot = snapshot else {
                debugPrint("Aucun document trouvé")
                return
            }
            var tab: [Review] = []
            for document in snapshot.documents {
                let documentData = document.data()

                let review = Review(
                    placeId: UUID(),
                    title: documentData["title"] as! String,
                    content: documentData["content"] as! String,
                    imagePaths: [documentData["image"] as! String],
                    rate: documentData["rate"] as! Int,
                    name: documentData["name"] as! String
                )
                tab.append(review)
            }
            completion(tab)
        }
    }

    // MARK: - Private

    private func getNumberOfRow(for collection: String, with keyID: String,completion: @escaping (Int) -> Void) {
        guard didHaveNetwork else { return }
        let db = Firestore.firestore()
        db.collection(collection).getDocuments() { (querySnapshot, err) in
            if let err = err {
                debugPrint("Error getting documents: \(err.localizedDescription)")
                completion(0)
            } else {
                completion(querySnapshot!.documents.count)
            }
        }
    }


    private var numberOfUser: Int?

    private var numberOfRestaurant: Int?

    private var numberOfReview: Int?

}
