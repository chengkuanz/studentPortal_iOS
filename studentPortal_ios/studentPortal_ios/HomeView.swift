//
//  HomeView.swift
//  studentPortal_ios
//
//  Created by chengkuan zhao on 2024-06-28.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HomeView: View {
    @State private var selectedTab: Tab = .myCourses
    @State private var announcements: [Announcement] = []
    
    var body: some View {
        VStack {
            Text(greetingMessage())
                .font(.largeTitle)
                .padding()
            
            HStack {
                Button(action: {
                    selectedTab = .myCourses
                }) {
                    Text("My Courses")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedTab == .myCourses ? Color.pink : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Spacer(minLength: 16) // Add space between buttons
                
                Button(action: {
                    selectedTab = .announcements
                }) {
                    Text("Announcements")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedTab == .announcements ? Color.pink : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            ScrollView {
                VStack(spacing: 16) {
                    if selectedTab == .myCourses {
                        CourseCard()
                    } else {
                        ForEach(announcements) { announcement in
                            AnnouncementCard(announcement: announcement)
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            fetchAnnouncements()
        }
    }
    
    func greetingMessage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        default:
            return "Good Evening"
        }
    }
    
    enum Tab {
        case myCourses
        case announcements
    }
    
    func fetchAnnouncements() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(user.uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let registeredCourses = data?["registeredCourses"] as? [String] ?? []
                
                if !registeredCourses.isEmpty {
                    let announcementsCollection = db.collection("announcements")
                    announcementsCollection.getDocuments { (querySnapshot, error) in
                        if let querySnapshot = querySnapshot {
                            let filteredAnnouncements = querySnapshot.documents.filter { doc in
                                let activeCourses = doc.data()["activeCourses"] as? [String] ?? []
                                return includesOne(collection: activeCourses, search: registeredCourses)
                            }.map { doc in
                                Announcement(
                                    id: doc.documentID,
                                    text: doc.data()["text"] as? String ?? "",
                                    title: doc.data()["title"] as? String ?? "",
                                    expiryDate: doc.data()["expiryDate"] as? String ?? "",
                                    releaseDate: doc.data()["releaseDate"] as? String ?? ""
                                )
                            }
                            self.announcements = filteredAnnouncements
                        }
                    }
                }
            }
        }
    }
}

struct Announcement: Identifiable {
    var id: String
    var text: String
    var title: String
    var expiryDate: String
    var releaseDate: String
}

struct CourseCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "flag.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .background(Color.red)
                .cornerRadius(8)
            
            Text("ITAL1000")
                .font(.headline)
            
            Text("Introduction to Italian")
                .font(.subheadline)
            
            Text("Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century ...")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.pink.opacity(0.2))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct AnnouncementCard: View {
    var announcement: Announcement
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(announcement.title)
                .font(.headline)
            
            Text(announcement.releaseDate)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Divider()
            
            Text(announcement.text)
                .font(.body)
        }
        .padding()
        .background(Color.orange.opacity(0.2))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

func includesOne(collection: [String], search: [String]) -> Bool {
    for item in search {
        if collection.contains(item) {
            return true
        }
    }
    return false
}
