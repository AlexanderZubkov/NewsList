import CoreData

final class CoreDataManager {
    private let modelName: String

    init(modelName: String) {
        self.modelName = modelName
    }

    private lazy var context: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator

        return managedObjectContext
    }()

    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }

        return managedObjectModel
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let storeName = "\(self.modelName).sqlite"

        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }

        return persistentStoreCoordinator
    }()

    public func newObject() -> ArticleObject {
        NSEntityDescription.insertNewObject(forEntityName: "ArticleObject", into: context) as! ArticleObject
    }

    public func save() {
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
        } catch let error {
            context.rollback()
            print("Could not save \(error.localizedDescription)")
        }
    }

    public func retrieveObjects() -> [ArticleObject] {
        do {
            let fetchRequest: NSFetchRequest<ArticleObject> = ArticleObject.fetchRequest()

            let descriptor = NSSortDescriptor(key: "date", ascending: true)
            fetchRequest.sortDescriptors = [descriptor]

            let results = try context.fetch(fetchRequest)

            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")

            return []
        }
    }

    public func delete(articles: [ArticleObject]) {
        for article in articles {
            context.delete(article)
        }
        save()
    }
}
