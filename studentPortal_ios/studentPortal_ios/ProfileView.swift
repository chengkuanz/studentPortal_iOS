//
//  ProfileView.swift
//  studentPortal_ios
//
//  Created by chengkuan zhao on 2024-06-28.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import UIKit

struct ProfileView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var studentNumber = ""
    @State private var isEditing = false
    @State private var errorMessage = ""
    @State private var showingErrorAlert = false
    @State private var selectedLanguage = "en"

    var body: some View {
        VStack {
            Text(LocalizedStringKey("Welcome"))
                .font(.largeTitle)
                .padding(.top, 20)

            Button(action: {
                // Action to edit image
            }) {
                Text(LocalizedStringKey("EDIT IMAGE"))
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(5.0)
            }
            .padding(.top, 10)

            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .padding(.top, 10)

            VStack(alignment: .leading, spacing: 10) {
                ProfileField(title: LocalizedStringKey("First Name"), value: $firstName, isEditing: $isEditing)
                ProfileField(title: LocalizedStringKey("Last Name"), value: $lastName, isEditing: $isEditing)
                ProfileField(title: LocalizedStringKey("Email"), value: $email, isEditing: $isEditing)

                HStack {
                    Text(LocalizedStringKey("Student Number:"))
                        .font(.headline)
                    Spacer()
                    Text(studentNumber)
                        .font(.body)
                }
            }
            .padding(.horizontal, 20)

            if isEditing {
                HStack {
                    Button(action: {
                        saveChanges()
                        isEditing = false
                    }) {
                        Text(LocalizedStringKey("SAVE"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 100)
                            .background(Color.blue)
                            .cornerRadius(5.0)
                    }

                    Button(action: {
                        isEditing = false
                    }) {
                        Text(LocalizedStringKey("CANCEL"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 100)
                            .background(Color.red)
                            .cornerRadius(5.0)
                    }
                }
                .padding(.top, 20)
            }

            Spacer()

            Picker(LocalizedStringKey("Language"), selection: $selectedLanguage) {
                Text("English").tag("en")
                Text("French").tag("fr")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button(action: {
                changeLanguage()
            }) {
                Text(LocalizedStringKey("Change Language"))
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.green)
                    .cornerRadius(15.0)
            }
            .padding(.bottom, 20)

            Button(action: {
                logout()
            }) {
                Text(LocalizedStringKey("Logout"))
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.red)
                    .cornerRadius(15.0)
            }
            .padding(.bottom, 20)
        }
        .padding()
        .alert(isPresented: $showingErrorAlert) {
            Alert(title: Text(LocalizedStringKey("Logout Error")), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            fetchUserData()
        }
    }

    func fetchUserData() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(user.uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.firstName = data?["firstName"] as? String ?? ""
                self.lastName = data?["lastName"] as? String ?? ""
                self.email = data?["email"] as? String ?? ""
                self.studentNumber = data?["studentNumber"] as? String ?? ""
            } else {
                print("Document does not exist")
            }
        }
    }

    func saveChanges() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        
        userRef.setData([
            "firstName": self.firstName,
            "lastName": self.lastName,
            "email": self.email,
            "studentNumber": self.studentNumber
        ], merge: true) { error in
            if let error = error {
                print("Error saving changes: \(error)")
            } else {
                print("Changes saved successfully")
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            // Successful logout, handle accordingly if needed
            print("Successfully logged out")
        } catch let signOutError as NSError {
            self.errorMessage = signOutError.localizedDescription
            self.showingErrorAlert = true
            print("Error signing out: %@", signOutError)
        }
    }

    func changeLanguage() {
        // Set the app language based on the selectedLanguage state variable
        UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Quit the app to apply the language change
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
        
        print("Language changed to \(selectedLanguage)")
    }
}

struct ProfileField: View {
    var title: LocalizedStringKey
    @Binding var value: String
    @Binding var isEditing: Bool

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            if isEditing {
                TextField(title, text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text(value)
                    .font(.body)
            }
            Spacer()
            Button(action: {
                isEditing = true
            }) {
                Text(LocalizedStringKey("EDIT"))
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.blue)
                    .cornerRadius(5.0)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

