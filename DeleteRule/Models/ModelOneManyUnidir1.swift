import SwiftUI
import SwiftData

@Model
final class ModelOneManyUnidir1L: NamedModel {
    
    @Attribute(.unique)
    var id = UUID()
    var name: String
    
    @Relationship(deleteRule: .cascade) var r: [ModelOneManyUnidir1R] = []
    
    init(name: String) {
        self.name = name
    }
    
    func relatedNames() -> [String] {
        if r.count == 0 { return ["[-]"] }
        return r.map { $0.name }.sorted()
    }
}


@Model
final class ModelOneManyUnidir1R: NamedModel {
    
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
