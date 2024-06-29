//
//  CourseDetailView.swift
//  studentPortal_ios
//
//  Created by chengkuan zhao on 2024-06-29.
//

import SwiftUI
import FirebaseFirestore
import AVKit

struct CourseContent: Identifiable {
    var id: String
    var title: String
    var textContent: String
    var open: String
    var close: String
    var due: String
    var type: String
    var contentOrder: Int
    var courseDocId: String
    var videoUrl: String
}

struct CourseDetailView: View {
    var courseId: String
    
    @State private var course: Course?
    @State private var courseContents: [CourseContent] = []
    @State private var isLoading = true
    
    var body: some View {
        VStack(alignment: .leading) {
            if isLoading {
                ProgressView("Loading course details...")
            } else if let course = course {
                VStack(alignment: .leading) {
                    Text(course.name)
                        .font(.largeTitle)
                        .padding(.bottom)
                    Text("Course Code: \(course.courseCode)")
                        .font(.title2)
                        .padding(.bottom)
                    Text("Day of Week: \(course.dayOfWeek)")
                        .font(.title2)
                        .padding(.bottom)
                    Text("Time: \(course.time)")
                        .font(.title2)
                        .padding(.bottom)
                }
                .padding()
                .navigationTitle("Course Details")
                
                Divider()
                
                Text("Course Contents")
                    .font(.title)
                    .padding()
                
                ScrollView {
                    ForEach(courseContents) { content in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(content.title)
                                .font(.headline)
                            Text("Type: \(content.type)")
                            Text(content.textContent)
                            Text("Open: \(content.open)")
                            Text("Close: \(content.close)")
                            Text("Due: \(content.due)")
                            
                            if content.type == "video" {
                                VideoPlayerView(url: content.videoUrl)
                                Link("Download Video", destination: URL(string: content.videoUrl)!)
                                    .padding(.top, 10)
                                    .buttonStyle(DefaultButtonStyle())
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    }
                }
            } else {
                Text("No course found")
                    .padding()
            }
        }
        .onAppear(perform: fetchCourseDetails)
    }
    
    func fetchCourseDetails() {
        let db = Firestore.firestore()
        let courseDoc = db.collection("courses").document(courseId)
        
        courseDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data() ?? [:]
                self.course = Course(
                    id: document.documentID,
                    name: data["name"] as? String ?? "",
                    courseCode: data["courseCode"] as? String ?? "",
                    dayOfWeek: data["dayOfWeek"] as? String ?? "",
                    time: data["time"] as? String ?? ""
                )
            }
            self.fetchCourseContents()
        }
    }
    
    func fetchCourseContents() {
        let db = Firestore.firestore()
        let courseContentCollection = db.collection("courseContent")
        let q = courseContentCollection.whereField("courseDocId", isEqualTo: courseId)
        
        q.getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.courseContents = querySnapshot.documents.compactMap { document -> CourseContent? in
                    let data = document.data()
                    return CourseContent(
                        id: document.documentID,
                        title: data["title"] as? String ?? "",
                        textContent: data["textContent"] as? String ?? "",
                        open: data["open"] as? String ?? "",
                        close: data["close"] as? String ?? "",
                        due: data["due"] as? String ?? "",
                        type: data["type"] as? String ?? "",
                        contentOrder: data["contentOrder"] as? Int ?? 0,
                        courseDocId: data["courseDocId"] as? String ?? "",
                        videoUrl: data["videoUrl"] as? String ?? ""
                    )
                }
            }
            self.isLoading = false
        }
    }
}

struct VideoPlayerView: View {
    var url: String
    
    var body: some View {
        VideoPlayer(player: AVPlayer(url: URL(string: url)!))
            .frame(height: 200)
            .cornerRadius(8)
    }
}

struct CourseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetailView(courseId: "exampleCourseId")
    }
}
