//
//  ProfileView.swift
//  studentPortal_ios
//
//  Created by chengkuan zhao on 2024-06-28.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var errorMessage = ""
    @State private var showingErrorAlert = false
    
    var body: some View {
        VStack {
            Text("Hello, World!ProfileView")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
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
            .padding(.top, 20)
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

