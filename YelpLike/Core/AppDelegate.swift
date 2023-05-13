//
//  AppDelegate.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import UIKit
import FirebaseCore


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        // UserDefaults for session cookie
        let userDefaults = UserDefaults.standard

        

        if let sessionId = userDefaults.string(forKey: "sessionUUID") {
            DatabaseService.shared.checkIfConnect(for: sessionId)
            DatabaseService.shared.session = sessionId
        } else {
            DatabaseService.shared.checkIfConnect(for: "")
            DatabaseService.shared.session = "Empty"
        }

        // Fetch data from Firebase

        DatabaseService.shared.getAllDocuments(of: "Restaurant") { places, _ in
            if let places {
                for place in places {
                    Place.all.append(place)
                }
            }
            DatabaseService.shared.isLoading = false
        }

        DatabaseService.shared.getAllDocuments(of: "Review") { _, reviews in
            if let reviews {
                for review in reviews {
                    Review.all.append(review)
                }
            }
            DatabaseService.shared.isLoading = false
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

