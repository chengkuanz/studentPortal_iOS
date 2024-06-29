//
//  ProfileView.swift
//  studentPortal_ios
//
//  Created by chengkuan zhao on 2024-06-28.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var firstName = "Chris"
    @State private var lastName = "Morrison"
    @State private var email = "example@gmail.com"
    @State private var ottawaUEmail = "test1@test.ca"
    @State private var studentNumber = "1235678"
    @State private var isEditing = false
    @State private var errorMessage = ""
    @State private var showingErrorAlert = false

    var body: some View {
        VStack {
            Text("Welcome \(firstName) \(lastName)")
                .font(.largeTitle)
                .padding(.top, 20)

            Button(action: {
                // Action to edit image
            }) {
                Text("EDIT IMAGE")
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
                ProfileField(title: "First Name", value: $firstName, isEditing: $isEditing)
                ProfileField(title: "Last Name", value: $lastName, isEditing: $isEditing)
                ProfileField(title: "Email", value: $email, isEditing: $isEditing)
                ProfileField(title: "OttawaU Email", value: $ottawaUEmail, isEditing: $isEditing)

                HStack {
                    Text("Student Number:")
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
                        // Action to save changes
                        isEditing = false
                    }) {
                        Text("SAVE")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 100)
                            .background(Color.blue)
                            .cornerRadius(5.0)
                    }

                    Button(action: {
                        // Action to cancel editing
                        isEditing = false
                    }) {
                        Text("CANCEL")
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

            Button(action: {
                logout()
            }) {
                Text("Logout")
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
            Alert(title: Text("Logout Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
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
}

struct ProfileField: View {
    var title: String
    @Binding var value: String
    @Binding var isEditing: Bool

    var body: some View {
        HStack {
            Text("\(title):")
                .font(.headline)
            if isEditing {
                TextField("Enter \(title.lowercased())", text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text(value)
                    .font(.body)
            }
            Spacer()
            Button(action: {
                isEditing = true
            }) {
                Text("EDIT")
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
