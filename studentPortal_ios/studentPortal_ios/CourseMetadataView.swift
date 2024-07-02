import SwiftUI

struct CourseMetadataView: View {
    var course: Course2
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(course.name)
                .font(.largeTitle)
                .padding(.top)
            
            HStack {
                Text("Course Code:")
                    .font(.headline)
                Text(course.courseCode)
            }
            
            HStack {
                Text("Section:")
                    .font(.headline)
                Text(course.section)
            }
            
            HStack {
                Text("Semester:")
                    .font(.headline)
                Text(course.semester)
            }
            
            HStack {
                Text("Year:")
                    .font(.headline)
                Text(course.year)
            }
            
            HStack {
                Text("Location:")
                    .font(.headline)
                Text(course.location)
            }
            
            HStack {
                Text("Day and Time:")
                    .font(.headline)
                Text("\(course.dayOfWeek) - \(course.time)")
            }
            
            Text("Description:")
                .font(.headline)
            Text(course.description)
                .padding(.bottom)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Course Details")
    }
}

struct CourseMetadataView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCourse = Course2(
            id: "1",
            name: "Sample Course",
            courseCode: "CS101",
            dayOfWeek: "Monday",
            time: "10:00 AM - 12:00 PM",
            description: "This is a sample course description.",
            section: "A",
            semester: "Fall",
            year: "2025",
            location: "Room 101"
        )
        CourseMetadataView(course: sampleCourse)
    }
}

