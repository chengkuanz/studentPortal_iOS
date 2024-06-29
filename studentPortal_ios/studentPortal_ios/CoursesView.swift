//
//  CoursesView.swift
//  studentPortal_ios
//
//  Created by chengkuan zhao on 2024-06-28.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Course: Identifiable {
    var id: String
    var name: String
    var courseCode: String
    var dayOfWeek: String
    var time: String
}

struct CoursesView: View {
    @State private var courses: [Course] = []
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading courses...")
                } else if courses.isEmpty {
                    Text("No courses registered")
                } else {
                    List(courses) { course in
                        NavigationLink(destination: CourseDetailView(courseId: course.id)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(course.name)
                                        .font(.headline)
                                    Text(course.courseCode)
                                        .font(.subheadline)
                                    Text("\(course.dayOfWeek) - \(course.time)")
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear(perform: fetchCourses)
            .navigationTitle("Registered Courses")
        }
    }

    func fetchCourses() {
        guard let user = Auth.auth().currentUser else {
            isLoading = false
            return
        }

        let db = Firestore.firestore()
        let userDoc = db.collection("users").document(user.uid)

        userDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let registeredCourses = data?["registeredCourses"] as? [String] ?? []

                if registeredCourses.isEmpty {
                    self.isLoading = false
                    return
                }

                let coursesCollection = db.collection("courses")
                let dispatchGroup = DispatchGroup()

                var fetchedCourses: [Course] = []

                for courseId in registeredCourses {
                    dispatchGroup.enter()
                    coursesCollection.document(courseId).getDocument { (courseSnapshot, error) in
                        if let courseSnapshot = courseSnapshot, courseSnapshot.exists {
                            let data = courseSnapshot.data() ?? [:]
                            let course = Course(
                                id: courseSnapshot.documentID,
                                name: data["name"] as? String ?? "",
                                courseCode: data["courseCode"] as? String ?? "",
                                dayOfWeek: data["dayOfWeek"] as? String ?? "",
                                time: data["time"] as? String ?? ""
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
            } else {
                self.isLoading = false
            }
        }
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView()
    }
}
