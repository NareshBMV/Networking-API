//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

FileManager.documentDirectoryURL.path



//let student:[Student] = [Student(name: "Bharath", grade: "6th Std", gender: "male", subjects:["maths","Science","physics"]),
//                         Student(name: "KV", grade: "iOS", gender: "Female"), subjects:["Chemistry","Biology"]]
let student:[Student] = [Student(name: "Bharath", grade: "std", gender: "Male", subjects: ["1","2","3"]),
                         Student(name: "Bharath", grade: "std", gender: "Male", subjects: ["1","2","3"])]

var directoryURL = URL(fileURLWithPath: "StudentData", relativeTo: FileManager.documentDirectoryURL)
try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: false)


do {
    //Encode
    let jsonURL = URL(fileURLWithPath: "StudentData", relativeTo: FileManager.documentDirectoryURL).appendingPathComponent("StudentJson").appendingPathExtension("json")
    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = .prettyPrinted
    let jsonData = try jsonEncoder.encode(student)
    try jsonData.write(to: jsonURL)
    
    //Decode
    let jsonDecodable = JSONDecoder()
    let jsonDataToDecode = try Data(contentsOf: jsonURL)
    let studentObj = try jsonDecodable.decode([Student].self, from: jsonDataToDecode)
    student == studentObj
}
catch{
    print(error)
}


//Realm - Model (same like coredata)
//concrete class
//























