//
//  CourseMetadataView.swift
//  studentPortal_ios
//
//  Created by chengkuan zhao on 2024-07-02.
//

import SwiftUI

struct CourseMetadataView: View {
    var course: Course2
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(course.name)
                .font(.largeTitle)
                .padding(.top)
            
            HStack {
                Text(LocalizedStringKey("course_code"))
                    .font(.headline)
                Text(course.courseCode)
            }
            
            HStack {
                Text(LocalizedStringKey("section"))
                    .font(.headline)
                Text(course.section)
            }
            
            HStack {
                Text(LocalizedStringKey("semester"))
                    .font(.headline)
                Text(course.semester)
            }
            
            HStack {
                Text(LocalizedStringKey("year"))
                    .font(.headline)
                Text(course.year)
            }
            
            HStack {
                Text(LocalizedStringKey("location"))
                    .font(.headline)
                Text(course.location)
            }
            
            HStack {
                Text(LocalizedStringKey("day_and_time"))
                    .font(.headline)
                Text("\(course.dayOfWeek) - \(course.time)")
            }
            
            Text(LocalizedStringKey("description"))
                .font(.headline)
            Text(course.description)
                .padding(.bottom)
            
            Spacer()
        }
        .padding()
        .navigationTitle(LocalizedStringKey("course_details"))
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
            description: "This is a sample course description for preview only.",
            section: "A",
            semester: "Fall",
            year: "2025",
            location: "Room 101"
        )
        CourseMetadataView(course: sampleCourse)
    }
}
