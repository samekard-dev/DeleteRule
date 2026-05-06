import SwiftUI
import SwiftData

struct ContentView: View {
    
    //One Many Uni Bi
    
    typealias ModelL = ModelOneOneUnidirL
    typealias ModelR = ModelOneOneUnidirR
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \ModelL.name) private var modelLs: [ModelL]
    @Query(sort: \ModelR.name) private var modelRs: [ModelR]
    
    @State private var showingConnectionL = false
    @State private var showingConnectionR = false
    
    var body: some View {
        VStack() {
            
            Image(imageName())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100.0)
            
            Spacer()
                .frame(height: 20.0)
            
            HStack(alignment: .top) {
                
                // 左側のリスト
                VStack(spacing: 20) {
                    Text(deleteRule(name: "\(ModelL.self)", relatedName: "r") ?? "-")
                        .bold()
                    Button(showingConnectionL ? "接続を隠す" : "接続を表示") {
                        showingConnectionL.toggle()
                    }
                    modelListView(items: modelLs, isLeft: true)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                
                // 右側のリスト
                VStack(spacing: 20) {
                    Text(deleteRule(name: "\(ModelR.self)", relatedName: "l") ?? "-")
                        .bold()
                    Button(showingConnectionR ? "接続を隠す" : "接続を表示") {
                        showingConnectionR.toggle()
                    }
                    modelListView(items: modelRs, isLeft: false)
                }
                .frame(maxWidth: .infinity)
            }
            
            Spacer()
            
            Button("はじめから") {
                setup()
            }
            .padding()
        }
        .task {
            setup()
        }
    }
    
    // UI部品の共通化
    @ViewBuilder
    private func modelListView<T: PersistentModel & NamedModel>(items: [T], isLeft: some Any) -> some View {
        
        if items.isEmpty {
            Text("No Data").foregroundStyle(.secondary)
        } else {
            ScrollView {
                VStack {
                    ForEach(items) { item in
                        HStack(spacing: 20) {
                            if isLeft as! Bool {
                                Button("消去") { deleteItem(item) }.foregroundStyle(.red)
                                Text(item.name).font(.title)
                                Spacer()
                                if showingConnectionL {
                                    Text(item.relatedNames().joined(separator: ", "))
                                }
                            } else {
                                if showingConnectionR {
                                    Text(item.relatedNames().joined(separator: ", "))
                                }
                                Spacer()
                                Text(item.name).font(.title)
                                Button("消去") { deleteItem(item) }.foregroundStyle(.red)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.horizontal, 12.0)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }
    
    private func deleteItem(_ item: any PersistentModel) {
        modelContext.delete(item)
        try? modelContext.save() 
    }
    
    private func setup() {
        
        // 全モデルの削除
        let allModelTypes: [any PersistentModel.Type] = [
            ModelOneOneUnidirL.self, ModelOneOneUnidirR.self,
            ModelOneOneBidirL.self, ModelOneOneBidirR.self,
            ModelOneManyUnidir1L.self, ModelOneManyUnidir1R.self,
            ModelOneManyUnidir2L.self, ModelOneManyUnidir2R.self,
            ModelOneManyBidirL.self, ModelOneManyBidirR.self,
            ModelManyManyUnidirL.self, ModelManyManyUnidirR.self,
            ModelManyManyBidirL.self, ModelManyManyBidirR.self
        ]
        
        for type in allModelTypes {
            //ただし.denyなど消すことが出来ない場合もある
            try? modelContext.delete(model: type)
        }
        try? modelContext.save()
        
        if ModelL.self == ModelOneOneUnidirL.self, ModelR.self == ModelOneOneUnidirR.self {
            var ls: [ModelOneOneUnidirL] = []
            var rs: [ModelOneOneUnidirR] = []
            for i in 0..<6 {
                let l = ModelOneOneUnidirL(name: "\(i + 1)")
                let r = ModelOneOneUnidirR(name: "\(i + 1)")
                modelContext.insert(l)
                modelContext.insert(r)
                ls.append(l)
                rs.append(r)
            }
            for i in 0..<6 {
                ls[i].r = rs[i]
            }
        }
        
        if ModelL.self == ModelOneOneBidirL.self, ModelR.self == ModelOneOneBidirR.self {
            var ls: [ModelOneOneBidirL] = []
            var rs: [ModelOneOneBidirR] = []
            for i in 0..<6 {
                let l = ModelOneOneBidirL(name: "\(i + 1)")
                let r = ModelOneOneBidirR(name: "\(i + 1)")
                modelContext.insert(l)
                modelContext.insert(r)
                ls.append(l)
                rs.append(r)
            }
            for i in 0..<6 {
                ls[i].r = rs[i]
            }
        }
        
        if ModelL.self == ModelOneManyUnidir1L.self, ModelR.self == ModelOneManyUnidir1R.self {
            var ls: [ModelOneManyUnidir1L] = []
            var rs: [ModelOneManyUnidir1R] = []
            for i in 0..<3 {
                let l = ModelOneManyUnidir1L(name: "\(i + 1)")
                modelContext.insert(l)
                ls.append(l)
            }
            for i in 0..<6 {
                let r = ModelOneManyUnidir1R(name: "\(i + 1)")
                modelContext.insert(r)
                rs.append(r)
            }
            for i in 0..<6 {
                ls[i / 2].r.append(rs[i])
            }
        }
        
        if ModelL.self == ModelOneManyUnidir2L.self, ModelR.self == ModelOneManyUnidir2R.self {
            var ls: [ModelOneManyUnidir2L] = []
            var rs: [ModelOneManyUnidir2R] = []
            for i in 0..<3 {
                let l = ModelOneManyUnidir2L(name: "\(i + 1)")
                modelContext.insert(l)
                ls.append(l)
            }
            for i in 0..<6 {
                let r = ModelOneManyUnidir2R(name: "\(i + 1)")
                modelContext.insert(r)
                rs.append(r)
            }
            for i in 0..<6 {
                rs[i].l = ls[i / 2]
            }
        }
        
        if ModelL.self == ModelOneManyBidirL.self, ModelR.self == ModelOneManyBidirR.self {
            var ls: [ModelOneManyBidirL] = []
            var rs: [ModelOneManyBidirR] = []
            for i in 0..<3 {
                let l = ModelOneManyBidirL(name: "\(i + 1)")
                modelContext.insert(l)
                ls.append(l)
            }
            for i in 0..<6 {
                let r = ModelOneManyBidirR(name: "\(i + 1)")
                modelContext.insert(r)
                rs.append(r)
            }
            for i in 0..<6 {
                ls[i / 2].r.append(rs[i])
            }
        }
        
        if ModelL.self == ModelManyManyUnidirL.self, ModelR.self == ModelManyManyUnidirR.self {
            var ls: [ModelManyManyUnidirL] = []
            var rs: [ModelManyManyUnidirR] = []
            for i in 0..<6 {
                let l = ModelManyManyUnidirL(name: "\(i + 1)")
                let r = ModelManyManyUnidirR(name: "\(i + 1)")
                modelContext.insert(l)
                modelContext.insert(r)
                ls.append(l)
                rs.append(r)
            }
            for i in stride(from: 0, to: 6, by: 2) {
                ls[i].r.append(rs[i])
                ls[i].r.append(rs[i + 1])
                ls[i + 1].r.append(rs[i])
                ls[i + 1].r.append(rs[i + 1])
            }
        }
        
        if ModelL.self == ModelManyManyBidirL.self, ModelR.self == ModelManyManyBidirR.self {
            var ls: [ModelManyManyBidirL] = []
            var rs: [ModelManyManyBidirR] = []
            for i in 0..<6 {
                let l = ModelManyManyBidirL(name: "\(i + 1)")
                let r = ModelManyManyBidirR(name: "\(i + 1)")
                modelContext.insert(l)
                modelContext.insert(r)
                ls.append(l)
                rs.append(r)
            }
            for i in stride(from: 0, to: 6, by: 2) {
                ls[i].r.append(rs[i])
                ls[i].r.append(rs[i + 1])
                ls[i + 1].r.append(rs[i])
                ls[i + 1].r.append(rs[i + 1])
            }
        }
        
        try? modelContext.save()
    }
    
    func imageName() -> String {
        if ModelL.self == ModelOneOneUnidirL.self, ModelR.self == ModelOneOneUnidirR.self {
            return "OneOneUnidir"
        }
        if ModelL.self == ModelOneOneBidirL.self, ModelR.self == ModelOneOneBidirR.self {
            return "OneOneBidir"
        }
        if ModelL.self == ModelOneManyUnidir1L.self, ModelR.self == ModelOneManyUnidir1R.self {
            return "OneManyUnidir1"
        }
        if ModelL.self == ModelOneManyUnidir2L.self, ModelR.self == ModelOneManyUnidir2R.self {
            return "OneManyUnidir2"
        }
        if ModelL.self == ModelOneManyBidirL.self, ModelR.self == ModelOneManyBidirR.self {
            return "OneManyBidir"
        }
        if ModelL.self == ModelManyManyUnidirL.self, ModelR.self == ModelManyManyUnidirR.self {
            return "ManyManyUnidir"
        }
        if ModelL.self == ModelManyManyBidirL.self, ModelR.self == ModelManyManyBidirR.self {
            return "ManyManyBidir"
        }
        return ""
    }
    
    private func deleteRule(name: String, relatedName: String) -> String? {
        let schema = modelContext.container.schema
        if let entity = schema.entities.first(where: { $0.name == name }) {
            if let relationship = entity.relationships.first(where: { $0.name == relatedName }) {
                return relationship.deleteRule.rawValue
            }
        }
        return nil
    }
}

#Preview {
    
    let sharedModelContainer: ModelContainer = {
        
        let schema = Schema([
            ModelOneOneUnidirL.self, ModelOneOneUnidirR.self,
            ModelOneOneBidirL.self, ModelOneOneBidirR.self,
            ModelOneManyUnidir1L.self, ModelOneManyUnidir1R.self,
            ModelOneManyUnidir2L.self, ModelOneManyUnidir2R.self,
            ModelOneManyBidirL.self, ModelOneManyBidirR.self,
            ModelManyManyUnidirL.self, ModelManyManyUnidirR.self,
            ModelManyManyBidirL.self, ModelManyManyBidirR.self,
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        
    }()
    
    ContentView()
        .modelContainer(sharedModelContainer)
}
