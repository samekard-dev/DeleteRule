import SwiftUI
import SwiftData

@main
struct DeleteRuleApp: App {
    
    var sharedModelContainer: ModelContainer = {
        
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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
            
        }
    }
}
