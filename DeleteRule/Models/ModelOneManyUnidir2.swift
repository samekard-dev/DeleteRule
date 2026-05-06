import SwiftUI
import SwiftData

@Model
final class ModelOneManyUnidir2L: NamedModel {
    
    @Attribute(.unique)
    var id = UUID()
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func relatedNames() -> [String] {
        return ["-"]
    }
}

@Model
final class ModelOneManyUnidir2R: NamedModel {
    
    @Attribute(.unique)
    var id = UUID()
    var name: String
    
    @Relationship(deleteRule: .cascade) var l: ModelOneManyUnidir2L?
    
    init(name: String) {
        self.name = name
    }
    
    func relatedNames() -> [String] {
        return [l?.name ?? "nil"]
    }
}
