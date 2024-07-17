//
//  CourseDetailView.swift
//  studentPortal_ios
//
//  Created by chengkuan zhao on 2024-06-29.
//


import SwiftUI
import FirebaseFirestore
import AVKit
import WebKit

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
    
    @State private var course: Course2?
    @State private var courseContents: [CourseContent] = []
    @State private var isLoading = true
    
    var body: some View {
        VStack(alignment: .leading) {
            if isLoading {
                ProgressView(LocalizedStringKey("loading_course_details"))
            } else if let course = course {
                VStack(alignment: .leading) {
                    NavigationLink(destination: CourseMetadataView(course: course)) {
                        Text(course.name)
                            .font(.title)
                            .padding()
                    }
                    
                    Divider()
                    
                    Text(LocalizedStringKey("course_contents"))
                        .font(.title2)
                        .padding()
                    
                    ScrollView {
                        ForEach(courseContents) { content in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(content.title)
                                    .font(.headline)
                                Text(LocalizedStringKey("type")) + Text(": \(content.type)")
                                    .font(.subheadline)
                                
                                if content.type == "text" {
                                    HTMLTextView(htmlContent: content.textContent)
                                        .frame(height: 200)
                                } else {
                                    Text(content.textContent)
                                        .font(.body)
                                }
                                
                                Text(LocalizedStringKey("open")) + Text(": \(content.open)")
                                    .font(.subheadline)
                                Text(LocalizedStringKey("close")) + Text(": \(content.close)")
                                    .font(.subheadline)
                                Text(LocalizedStringKey("due")) + Text(": \(content.due)")
                                    .font(.subheadline)
                                
                                if content.type == "video" {
                                    VideoPlayerView(url: content.videoUrl)
                                    Link(LocalizedStringKey("download_video"), destination: URL(string: content.videoUrl)!)
                                        .padding(.top, 10)
                                        .buttonStyle(DefaultButtonStyle())
                                } else if content.type == "edpuzzle" {
                                    NavigationLink(destination: EdpuzzleView(url: content.textContent)) {
                                        Text("View Edpuzzle Content")
                                            .font(.headline)
                                            .foregroundColor(.blue)
                                            .padding(.top, 10)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        }
                    }
                }
            } else {
                Text(LocalizedStringKey("no_course_found"))
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
                self.course = Course2(
                    id: document.documentID,
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
                    let contentType = data["type"] as? String ?? ""
                    if contentType == "quiz" {
                        return nil
                    }
                    return CourseContent(
                        id: document.documentID,
                        title: data["title"] as? String ?? "",
                        textContent: data["textContent"] as? String ?? "",
                        open: data["open"] as? String ?? "",
                        close: data["close"] as? String ?? "",
                        due: data["due"] as? String ?? "",
                        type: contentType,
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

struct HTMLTextView: UIViewRepresentable {
    var htmlContent: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        print("Loading HTML content: \(htmlContent)")
        webView.loadHTMLString(htmlContent, baseURL: nil)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

struct CourseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetailView(courseId: "exampleCourseId")
    }
}
