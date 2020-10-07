//
//  MainTableViewCell.swift
//  TopFeed
//
//  Created by Alexander Zubkov on 30.09.2020.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    let width = UIScreen.main.bounds.width

    private var viewModel: MainCollectionViewCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        containerWidthConstraint.constant = width
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        textView.text = nil
    }

    public func configure(with viewModel: MainCollectionViewCellViewModel) {
        self.viewModel = viewModel

        textView.text = viewModel.title
        let sizeToFitIn = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let newSize = self.textView.sizeThatFits(sizeToFitIn)
        textViewHeightConstraint.constant = newSize.height
    }
}
