import Foundation

class ArticleViewControllerViewModel {
    private weak var coordinator: ArticleCoordinator?
    let articleURL: URL

    init(coordinator: ArticleCoordinator, url: URL) {
        self.coordinator = coordinator
        articleURL = url
    }

    func dismiss() {
        coordinator?.dismiss()
    }
}
