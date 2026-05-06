import SwiftUI
import SwiftData

@Model
final class ModelOneOneUnidirL: NamedModel {
    
    @Attribute(.unique)
    var id = UUID()
    var name: String
    
    @Relationship(deleteRule: .cascade) var r: ModelOneOneUnidirR?
    
    init(name: String) {
        self.name = name
    }
    
    func relatedNames() -> [String] {
        return [r?.name ?? "nil"]
    }
}

@Model
final class ModelOneOneUnidirR: NamedModel {
    
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
