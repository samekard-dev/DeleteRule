import SwiftUI
import SwiftData

@Model
final class ModelManyManyUnidirL: NamedModel {
    
    @Attribute(.unique)
    var id = UUID()
    var name: String
    
    @Relationship(deleteRule: .cascade) var r: [ModelManyManyUnidirR] = []
    
    init(name: String) {
        self.name = name
    }
    
    func relatedNames() -> [String] {
        if r.count == 0 { return ["[-]"] }
        return r.map { $0.name }.sorted()
    }
}

@Model
final class ModelManyManyUnidirR: NamedModel {
    
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
