//
//  MainViewController.swift
//  TopFeed
//
//  Created by Alexander Zubkov on 30.09.2020.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }

    let viewModel: MainViewControllerViewModel
    private lazy var refreshControl = UIRefreshControl()
    private var isLoaded = false

    init?(coder: NSCoder, viewModel: MainViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("This view controller should be created with a viewModel.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: .didEnterBackground, object: nil)

        viewModel.fetchArticles {
            self.reloadCollectionView()
        }
        prepareUI()
        viewModel.loadArticles {
            self.reloadCollectionView()
        }
    }

    private func reloadCollectionView() {
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        self.scrollToMiddleItem()
    }

    private func scrollToMiddleItem() {
        let index = viewModel.articles.count / 2
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
        print(Thread.current)
    }

    @objc
    private func didEnterBackground() {
        viewModel.didEnterBackground()
    }

    private func prepareUI() {
        refreshControl.attributedTitle = NSAttributedString(string: Constants.Main.pullToRefresh)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.register(cell: MainCollectionViewCell.self)
    }

    @objc func refresh(_ sender: AnyObject) {
        viewModel.loadArticles {
            self.refreshControl.endRefreshing()
            self.reloadCollectionView()
        }
    }
}

//MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.articles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MainCollectionViewCell = collectionView.dequeueCell(at: indexPath)
        let cellViewModel = viewModel.viewModelForCell(at: indexPath.row)
        cell.configure(with: cellViewModel)
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedArticle(at: indexPath.item)
    }
}
