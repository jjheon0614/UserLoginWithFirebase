//
//  Movie.swift
//  UserLoginWithFirebase
//
//  Created by Jaeheon Jeong on 2023/09/08.
//

import Foundation


struct Movie: Codable, Identifiable {
    
    
    var id: String = UUID().uuidString
    var name: String?
    var documentID: String?
    
}
