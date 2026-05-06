import SwiftUI
import SwiftData

@Model
final class ModelManyManyBidirL: NamedModel {
    
    @Attribute(.unique)
    var id = UUID()
    var name: String
    
    @Relationship(deleteRule: .cascade, inverse: \ModelManyManyBidirR.l) var r: [ModelManyManyBidirR] = []
    
    init(name: String) {
        self.name = name
    }
    
    func relatedNames() -> [String] {
        if r.count == 0 { return ["[-]"] }
        return r.map { $0.name }.sorted()
    }
}

@Model
final class ModelManyManyBidirR: NamedModel {
    
    @Attribute(.unique)
    var id = UUID()
    var name: String
    
    @Relationship(deleteRule: .cascade) var l: [ModelManyManyBidirL] = []
    
    init(name: String) {
        self.name = name
    }
    
    func relatedNames() -> [String] {
        if l.count == 0 { return ["[-]"] }
        return l.map { $0.name }.sorted()
    }
}
