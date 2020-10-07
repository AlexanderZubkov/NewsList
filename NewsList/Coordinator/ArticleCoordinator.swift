import UIKit

class ArticleCoordinator: Coordinator {
    private weak var parentNavigationController: UINavigationController?
    private weak var parentCoordinator: MainCoordinator?
    private var navigationController: UINavigationController?
    private var articleURL: URL

    init (navigationController: UINavigationController?, coordinator: MainCoordinator, articleURL: URL) {
        parentNavigationController = navigationController
        parentCoordinator = coordinator
        self.articleURL = articleURL
    }

    func start() {
        guard let parentNavigationController = parentNavigationController else { return }

        let viewModel = ArticleViewControllerViewModel(coordinator: self, url: articleURL)

        let identifier = String(describing: ArticleViewController.self)
        let storyboard = UIStoryboard(name: identifier, bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: identifier, creator: { coder in
            ArticleViewController(coder: coder, viewModel: viewModel)
        })
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        parentNavigationController.present(nvc, animated: true)
        navigationController = nvc
    }

    func dismiss() {
        parentCoordinator?.dismised(self)
    }
}
