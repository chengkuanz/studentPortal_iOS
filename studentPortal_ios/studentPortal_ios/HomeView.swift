import SwiftUI

struct HomeView: View {
    @State private var selectedTab: Tab = .myCourses
    
    var body: some View {
        VStack {
            Text(greetingMessage())
                .font(.largeTitle)
                .padding()
            
            HStack(spacing: 0) {
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
                        AnnouncementCard()
                    }
                }
                .padding()
            }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
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
            
            Text("Tote bag sint hell of air plant leggings gentrify same retro...")
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
    var body: some View {
        VStack(alignment: .leading) {
            Text("Assignment 1 Postponed")
                .font(.headline)
            
            Text("7/31/2023, 11:45")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Divider()
            
            Text("The due date for Assignment 1 has been postponed. Students now have an extended deadline to submit their work. Please check the updated schedule for the new submission deadline.")
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

