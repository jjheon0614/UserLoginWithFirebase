//
//  UserLoginWithFirebaseApp.swift
//  UserLoginWithFirebase
//
//  Created by Jaeheon Jeong on 2023/09/08.
//

import SwiftUI
import Firebase

@main
struct UserLoginWithFirebaseApp: App {
    
    init () {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
