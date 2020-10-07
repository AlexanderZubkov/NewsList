import UIKit

class MainCoordinator: Coordinator {
    private var childCoordinators: [Coordinator] = []
    private weak var navigationController: UINavigationController?

    init (navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        guard let navigationController = navigationController else { return }
        
        let mainControllerViewModel = MainViewControllerViewModel(coordinator: self)

        let identifier = String(describing: MainViewController.self)
        let storyboard = UIStoryboard(name: identifier, bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: identifier, creator: { coder in
            MainViewController(coder: coder, viewModel: mainControllerViewModel)
        })

        navigationController.pushViewController(vc, animated: true)
    }

    func loadArticle(with url: URL) {
        let coordinator = ArticleCoordinator(navigationController: navigationController, coordinator: self, articleURL: url)
        coordinator.start()
        childCoordinators.append(coordinator)
    }

    func dismised(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if child === coordinator {
                childCoordinators.remove(at: index)
            }
        }
    }
}
