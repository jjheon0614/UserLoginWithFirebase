//
//  MovieViewModel.swift
//  UserLoginWithFirebase
//
//  Created by Jaeheon Jeong on 2023/09/08.
//

import Foundation
import FirebaseFirestore


class MovieViewModel: ObservableObject {
    
    @Published var movies = [Movie]()
    private var db = Firestore.firestore()
    
    
    init() {
//        getAllMovieData()
        getAllMovieDataFromUser1()
    }
    
    
//    func getAllMovieData() {
//        // Retrieve the "movies" document
//        db.collection("movies").addSnapshotListener { (querySnapshot, error) in
//            guard let documents = querySnapshot?.documents else {
//                print("No documents")
//
//                return
//
//            }
//                // Loop to get the "name" field inside each movie document
//            self.movies = documents.map { (queryDocumentSnapshot) -> Movie in
//                let data = queryDocumentSnapshot.data()
//                let name = data["name"] as? String ?? ""
//
//
//                return Movie(name: name, documentID: queryDocumentSnapshot.documentID)
//            }
//        }
//    }
    

    func getAllMovieDataFromUser1() {
        // Query all documents in the "user1_collection" subcollection
        db.collectionGroup("user1")
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                // Loop to get the "name" field inside each movie document
                self.movies = documents.map { (queryDocumentSnapshot) -> Movie in
                    let data = queryDocumentSnapshot.data()
                    let name = data["name"] as? String ?? ""
                    
                    return Movie(name: name, documentID: queryDocumentSnapshot.documentID)
                }
            }
    }


    
    
    
    
    func addNewMovieData(name: String) {
            // add a new document of a movie name in the "movies" collection
            db.collection("movies").addDocument(data: ["name": name])
    }
    
    
    func removeMovieData(documentID: String) {
        db.collection("movies").document(documentID).delete { (error) in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
