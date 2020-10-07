import UIKit
import WebKit

class ArticleViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!

    private let viewModel: ArticleViewControllerViewModel
    private lazy var refreshControl = UIRefreshControl()

    init?(coder: NSCoder, viewModel: ArticleViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("This view controller should be created with a viewModel.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let request = URLRequest(url: viewModel.articleURL)
        webView.load(request)
    }

    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        viewModel.dismiss()
    }
}
