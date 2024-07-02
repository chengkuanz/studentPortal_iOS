
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
    @State private var courses: [Course2] = []
    @State private var isLoading = true

    var body: some View {
        NavigationView {
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
                        if isLoading {
                            ProgressView("Loading...")
                        } else {
                            if selectedTab == .myCourses {
                                if courses.isEmpty {
                                    Text("No courses registered")
                                        .padding()
                                } else {
                                    ForEach(courses) { course in
                                        NavigationLink(destination: CourseMetadataView(course: course)) {
                                            CourseCard(course: course)
                                        }
                                    }
                                }
                            } else {
                                if announcements.isEmpty {
                                    Text("No announcements")
                                        .padding()
                                } else {
                                    ForEach(announcements) { announcement in
                                        AnnouncementCard(announcement: announcement)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                fetchAnnouncementsAndCourses()
            }
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

    func fetchAnnouncementsAndCourses() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let userDoc = db.collection("users").document(user.uid)

        userDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let registeredCourses = data?["registeredCourses"] as? [String] ?? []

                fetchCourses(courseIds: registeredCourses)
                fetchAnnouncements(courseIds: registeredCourses)
            } else {
                isLoading = false
            }
        }
    }

    func fetchCourses(courseIds: [String]) {
        let db = Firestore.firestore()
        let coursesCollection = db.collection("courses")
        let dispatchGroup = DispatchGroup()

        var fetchedCourses: [Course2] = []

        for courseId in courseIds {
            dispatchGroup.enter()
            coursesCollection.document(courseId).getDocument { (courseSnapshot, error) in
                if let courseSnapshot = courseSnapshot, courseSnapshot.exists {
                    let data = courseSnapshot.data() ?? [:]
                    let course = Course2(
                        id: courseSnapshot.documentID,
                        name: data["name"] as? String ?? "",
                        courseCode: data["courseCode"] as? String ?? "",
                        dayOfWeek: data["dayOfWeek"] as? String ?? "",
                        time: data["time"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        section: data["section"] as? String ?? "",
                        semester: data["semester"] as? String ?? "",
                        year: data["year"] as? String ?? "",
                        location: data["location"] as? String ?? ""
                    )
                    fetchedCourses.append(course)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.courses = fetchedCourses
            self.isLoading = false
        }
    }

    func fetchAnnouncements(courseIds: [String]) {
        let db = Firestore.firestore()
        let announcementsCollection = db.collection("announcements")

        announcementsCollection.getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                let filteredAnnouncements = querySnapshot.documents.filter { doc in
                    let activeCourses = doc.data()["activeCourses"] as? [String] ?? []
                    return includesOne(collection: activeCourses, search: courseIds)
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

struct Announcement: Identifiable {
    var id: String
    var text: String
    var title: String
    var expiryDate: String
    var releaseDate: String
}

struct Course2: Identifiable {
    var id: String
    var name: String
    var courseCode: String
    var dayOfWeek: String
    var time: String
    var description: String
    var section: String
    var semester: String
    var year: String
    var location: String
}

struct CourseCard: View {
    var course: Course2
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Image(systemName: "book.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)  // Smaller icon height
                    .background(Color.blue)
                    .cornerRadius(8)
                
                Text(course.courseCode)
                    .font(.headline)
                
                Text(course.name)
                    .font(.subheadline)
                
                Text("\(course.dayOfWeek) - \(course.time)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(course.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                
            }
            .padding()
            .background(Color.pink.opacity(0.2))
            .cornerRadius(12)
            .frame(width: geometry.size.width)  // Ensure the card takes the full width
        }
        .frame(height: 200)  // Set a fixed height for consistency
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
