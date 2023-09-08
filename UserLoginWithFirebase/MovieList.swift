//
//  MovieList.swift
//  UserLoginWithFirebase
//
//  Created by Jaeheon Jeong on 2023/09/08.
//

import SwiftUI

struct MovieList: View {
    
    @State private var movie:String = ""
    // our movie view model object
    @StateObject private var movieViewModel = MovieViewModel()
    var body: some View {
    VStack{
    // input field for a movie name
    TextField("Enter a movie name...", text: $movie)
    .padding()
    .border(.black)
    .frame(width: 230, height: 40, alignment: .leading)
    .padding()
    // button to add a movie
    Button {
    self.movieViewModel.addNewMovieData(name: movie)
    } label: {
    Text("Add Movies")
            .padding()
            .foregroundColor(.white)
            .background(Color.black)
            }
            // List of all movies name fetched from firestore
            NavigationView {
            List {
                
                ForEach(movieViewModel.movies, id: \.id) { movie in
                    Text(movie.name ?? "")
                }
                .onDelete(perform: removeMovie)
            }
            .navigationTitle("All Movies 123")
            }
            }
            }
    
    func removeMovie(at offsets: IndexSet) {
        for index in offsets {
            if let documentID = movieViewModel.movies[index].documentID {
                movieViewModel.removeMovieData(documentID: documentID)
            }
        }
    }
}

struct MovieList_Previews: PreviewProvider {
    static var previews: some View {
        MovieList()
    }
}
