import SwiftUI
import SwiftData

@Model
final class ModelOneManyBidirL: NamedModel {
    
    @Attribute(.unique)
    var id = UUID()
    var name: String
    
    @Relationship(deleteRule: .cascade, inverse: \ModelOneManyBidirR.l) var r: [ModelOneManyBidirR] = []
    
    init(name: String) {
        self.name = name
    }
    
    func relatedNames() -> [String] {
        if r.count == 0 { return ["[-]"] }
        return r.map { $0.name }.sorted()
    }
}

@Model
final class ModelOneManyBidirR: NamedModel {
    
    @Attribute(.unique)
    var id = UUID()
    var name: String
    
    @Relationship(deleteRule: .cascade) var l: ModelOneManyBidirL?
    
    init(name: String) {
        self.name = name
    }
    
    func relatedNames() -> [String] {
        return [l?.name ?? "nil"]
    }
}
