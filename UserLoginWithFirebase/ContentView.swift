//
//  ContentView.swift
//  UserLoginWithFirebase
//
//  Created by Jaeheon Jeong on 2023/09/08.
//

//import SwiftUI
//import Firebase
//
//struct ContentView: View {
//
//
//    @State var email = ""
//    @State var password = ""
//    @State var loginSuccess = false
//    @State private var showingSignUpSheet = false
//    var body: some View {
//
//        if loginSuccess {
//            MovieList()
//        } else {
//
//            VStack {
//                Spacer()
//                // Login fields to sign in
//                Group {
//                    TextField("Email", text: $email)
//                        .textInputAutocapitalization(.never)
//                    SecureField("Password", text: $password)
//                }
//                // Login button
//                Button {
//                    login()
//                } label: {
//                    Text("Sign in")
//                        .bold()
//                        .frame(width: 360, height: 50)
//                        .background(.thinMaterial)
//                        .cornerRadius(10)
//                }
//                // Login message after pressing the login button
//                if loginSuccess {
//                    Text("Login Successfully! ✅")
//                        .foregroundColor(.green)
//                } else {
//                    Text("Not Login Successfully Yet! ❌")
//                        .foregroundColor(.red)
//                }
//                Spacer()
//                // Button to show the sign up sheet
//                Button {
//                    showingSignUpSheet.toggle()
//                } label: {
//                    Text("Sign Up Here!")
//                }
//            }
//            .padding()
//            .sheet(isPresented: $showingSignUpSheet) {
//                SignUpView()
//            }
//        }
//    }
//        // Login function to use Firebase to check username and password to sign in
//        func login() {
//            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//                if error != nil {
//                    print(error?.localizedDescription ?? "")
//                    loginSuccess = false
//                } else {
//                    print("success")
//                    loginSuccess = true
//                }
//            }
//
//    }
//}
//
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


import SwiftUI
import Firebase
import FirebaseStorage
import PhotosUI

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false

    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("No image selected")
            }

            Button(action: {
                isImagePickerPresented.toggle()
            }) {
                Text("Select Image")
                    .bold()
                    .frame(width: 360, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage)
            }

            if selectedImage != nil {
                Button(action: {
                    uploadImage()
                }) {
                    Text("Upload Image")
                        .bold()
                        .frame(width: 360, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }

    // Upload the selected image to Firebase Storage
    func uploadImage() {
        guard let selectedImage = selectedImage else {
            print("No image selected.")
            return
        }

        // Convert the UIImage to Data
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.5) else {
            print("Failed to convert image to data.")
            return
        }

        // Create a unique filename for the image (you can customize this)
        let timestamp = Date().timeIntervalSince1970
        let fileName = "\(timestamp).jpg"

        // Create a reference to Firebase Storage where you want to store the image
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let imageReference = storageReference.child("images").child(fileName)

        // Upload the image data to Firebase Storage
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        imageReference.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
            } else {
                print("Image uploaded successfully.")
                // You can perform additional actions here, such as saving the download URL or updating your UI.
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1 // Limit to a single image selection

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedImage: $selectedImage)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        @Binding var selectedImage: UIImage?

        init(selectedImage: Binding<UIImage?>) {
            _selectedImage = selectedImage
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let selectedResult = results.first else {
                picker.dismiss(animated: true, completion: nil)
                return
            }

            selectedResult.itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                if let uiImage = image as? UIImage {
                    self.selectedImage = uiImage
                }
            }

            picker.dismiss(animated: true, completion: nil)
        }
    }
}
