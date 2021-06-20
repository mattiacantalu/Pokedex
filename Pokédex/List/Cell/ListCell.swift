import Foundation
import UIKit

class ListCell: UITableViewCell {
    private var model : ListCellViewModel? {
        didSet {
            nameLabel.text = model?.name
            model?.fetchImage { [weak self] in self?.show(image: $0) }
        }
    }

    private let nameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textAlignment = .left
        return lbl
    }()

    private let imgView : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit(viewModel: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit(viewModel: nil)
    }

    private func commonInit(viewModel: ListCellViewModel?) {
        setupConstraint()
        self.model = viewModel
    }

    func setup(viewModel: ListCellViewModel) {
        commonInit(viewModel: viewModel)
    }
}

private extension ListCell {
    func show(image data: Data?) {
        data.map { imgView.image = UIImage(data: $0) }
    }

    func setupConstraint() {
        imgView.activate(constraints: [
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
        ], on: contentView)
        nameLabel.activate(constraints: [
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 0),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10)
        ], on: contentView)
    }
}

private extension UIView {
    func activate(constraints: [NSLayoutConstraint], on view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        NSLayoutConstraint.activate(constraints)
    }
}
