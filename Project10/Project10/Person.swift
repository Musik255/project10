import UIKit

class Person: NSObject, NSSecureCoding {
    static var supportsSecureCoding = true
    
    static let defaultName = "Unknown"
    var name : String
    var image : String
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(image, forKey: "image")
    }
    
    required init(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        image = coder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    
    
    init(name: String = defaultName, image: String) {
        self.name = name
        self.image = image
    }
}
