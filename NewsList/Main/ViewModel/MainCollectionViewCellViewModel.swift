import Foundation

struct MainCollectionViewCellViewModel {

    public let article: ArticleObject

    var title: String? {
        article.title
    }
}
