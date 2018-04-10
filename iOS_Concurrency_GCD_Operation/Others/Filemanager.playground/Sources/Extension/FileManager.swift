import Foundation

public extension FileManager {
    public static var documentDirectoryURL:URL {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
}
