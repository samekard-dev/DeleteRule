import SwiftUI
import SwiftData

@Model
final class ModelOneOneBidirL: NamedModel {
    
    @Attribute(.unique)
    var id = UUID()
    var name: String
    
    @Relationship(deleteRule: .cascade, inverse: \ModelOneOneBidirR.l) var r: ModelOneOneBidirR?
    
    init(name: String) {
        self.name = name
    }
    
    func relatedNames() -> [String] {
        return [r?.name ?? "nil"]
    }
}

@Model
final class ModelOneOneBidirR: NamedModel {
    
    @Attribute(.unique)
    var id = UUID()
    var name: String
    
    @Relationship(deleteRule: .cascade) var l: ModelOneOneBidirL?
    
    init(name: String) {
        self.name = name
    }
    
    func relatedNames() -> [String] {
        return [l?.name ?? "nil"]
    }
}
