//
//  ContentView.swift
//  UserLoginWithFirebase
//
//  Created by Jaeheon Jeong on 2023/09/08.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    
    @State var email = ""
    @State var password = ""
    @State var loginSuccess = false
    @State private var showingSignUpSheet = false
    var body: some View {
        
        if loginSuccess {
            MovieList()
        } else {
            
            VStack {
                Spacer()
                // Login fields to sign in
                Group {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                    SecureField("Password", text: $password)
                }
                // Login button
                Button {
                    login()
                } label: {
                    Text("Sign in")
                        .bold()
                        .frame(width: 360, height: 50)
                        .background(.thinMaterial)
                        .cornerRadius(10)
                }
                // Login message after pressing the login button
                if loginSuccess {
                    Text("Login Successfully! ✅")
                        .foregroundColor(.green)
                } else {
                    Text("Not Login Successfully Yet! ❌")
                        .foregroundColor(.red)
                }
                Spacer()
                // Button to show the sign up sheet
                Button {
                    showingSignUpSheet.toggle()
                } label: {
                    Text("Sign Up Here!")
                }
            }
            .padding()
            .sheet(isPresented: $showingSignUpSheet) {
                SignUpView()
            }
        }
    }
        // Login function to use Firebase to check username and password to sign in
        func login() {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                    loginSuccess = false
                } else {
                    print("success")
                    loginSuccess = true
                }
            }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
