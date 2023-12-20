import UIKit

class Person: NSObject, Codable {
    static let defaultName = "Unknown"
    var name : String
    var image : String
    
    init(name: String = defaultName, image: String) {
        self.name = name
        self.image = image
    }
}
