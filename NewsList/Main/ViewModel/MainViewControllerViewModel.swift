import Foundation
import CoreGraphics

class MainViewControllerViewModel {

    private weak var coordinator: MainCoordinator?
    public var articles: [ArticleObject] = []
    private let client = APIClient()
    private var isLoading = false
    private var cdManager = CoreDataManager(modelName: Constants.modelName)
    private var formatter = DateFormatter()

    private let sideOffset: CGFloat = 20
    private let verticalOffset: CGFloat = 10
    private let labelHeight: CGFloat = 17
    private let imageHeight: CGFloat = 140

    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }

    public func fetchArticles(_ completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            self.articles = self.cdManager.retrieveObjects()
            completion()
        }
    }

    public func loadArticles(_ completion: @escaping () -> Void) {
        let queue = DispatchQueue.global()
        let group = DispatchGroup()

        var appleItems: [Item] = []
        var redditEntries: [Entry] = []
        group.enter()
        queue.async {
            self.client.loadAppleData { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let items):
                    appleItems = items
                }
                group.leave()
            }
        }

        group.enter()
        queue.async {
            self.client.loadRedditData { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let entries):
                    redditEntries = entries
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            guard (appleItems.count > 0 || redditEntries.count > 0) else {
                completion()
                return
            }

            self.cdManager.delete(articles: self.articles)
            self.save(appleItems)
            self.save(redditEntries)
            self.cdManager.save()
            self.articles = self.cdManager.retrieveObjects()
            completion()
        }
    }

    private func save(_ items: [Item]) {
        guard items.count > 0 else {
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss z"
        for item in items {
            guard let url = URL(string: item.link),
                  let date = formatter.date(from: item.pubDate) else {
                continue
            }

            let object = self.cdManager.newObject()
            object.title = item.title
            object.url = url
            object.date = date
        }
    }

    private func save(_ entries: [Entry]) {
        guard entries.count > 0 else {
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        for entry in entries {
            guard let url = URL(string: entry.link.href),
                  let date = formatter.date(from: entry.updated) else {
                continue
            }

            let object = self.cdManager.newObject()
            object.title = entry.title
            object.url = url
            object.date = date
        }
    }

    public func didEnterBackground() {
        DispatchQueue.main.async {
            self.cdManager.save()
        }
    }

    public func viewModelForCell(at index: Int) -> MainCollectionViewCellViewModel {
        MainCollectionViewCellViewModel(article: articles[index])
    }

    public func selectedArticle(at index: Int) {
        guard let url = articles[index].url else {
            return
        }

        coordinator?.loadArticle(with: url)
    }
}
