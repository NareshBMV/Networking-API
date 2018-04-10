import Foundation

public class Student:Codable {
    public let name:String
    public let grade:String
    public let gender:String
    public let subjects:[String]
    
    public init(name:String, grade:String, gender:String, subjects:[String]){
        self.name = name
        self.grade = grade
        self.gender = gender
        self.subjects = subjects
    }
}

extension Student:Equatable {
    public static func ==(student1: Student, student2: Student) -> Bool{
        return (student1.name == student2.name
            && student1.grade == student2.grade
            && student1.gender == student2.gender
            && student1.subjects == student2.subjects)
        
    }
}



