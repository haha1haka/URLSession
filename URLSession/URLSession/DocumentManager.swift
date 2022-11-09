import UIKit

enum IsFileExist {
    case yes
    case no
}

final class DocumentManager {
    
    static let shared = DocumentManager()
    
    private init() { }
    
    static let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
}
