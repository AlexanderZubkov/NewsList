import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(cell: T.Type) {
        let name = String(describing: cell.self)
        register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
    }

    func dequeueCell<T: UICollectionViewCell>(at indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
}
