import Foundation
import UIKit

final class DetailViewController: UIViewController {
    private var viewModel: DetailViewModel {
        didSet {
            show(name: viewModel.name,
                 weight: viewModel.weight,
                 height: viewModel.height)
            show(abilities: viewModel.abiltyViewModel)
            show(moves: viewModel.moveViewModel)
            show(types: viewModel.typeViewModel)
            show(stats: viewModel.statViewModel)
            show(sprites: viewModel.spritesViewModel)
        }
    }
    private var error: Error? {
        didSet { alert(title: "Error", message: error?.localizedDescription ?? "Unknown") }
    }

    private let baseInfoStackView : UIStackView = {
        UIStackView.vertical()
    }()

    private lazy var abilitiesStackView: UIStackView = {
        UIStackView.vertical()
    }()

    private lazy var movesStackView: UIStackView = {
        UIStackView.vertical()
    }()

    private lazy var typesStackView: UIStackView = {
        UIStackView.vertical()
    }()

    private lazy var statsStackView: UIStackView = {
        UIStackView.vertical()
    }()

    private lazy var imagesStackView: UIStackView = {
        UIStackView.horizontal()
    }()

    private lazy var imagesScrollView: UIScrollView = {
        UIScrollView()
    }()

    private lazy var scrollView: UIScrollView = {
        UIScrollView()
    }()

    private lazy var container: UIView = {
        let vw = UIView()
        vw.backgroundColor = .white
        return vw
    }()

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        self.error = nil
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not availble!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        container.insert(in: view)

        layout()

        loadData()
    }

    func layout() {
        scrollView.insert(in: container)
        
        imagesStackView.insert(in: imagesScrollView)
        imagesStackView.heightAnchor.constraint(equalTo: imagesScrollView.heightAnchor).isActive = true

        scrollView.addView(imagesScrollView)
        scrollView.addView(baseInfoStackView)
        scrollView.addView(abilitiesStackView)
        scrollView.addView(movesStackView)
        scrollView.addView(typesStackView)
        scrollView.addView(statsStackView)

        let stacks = ["imagesScrollView": imagesScrollView,
                      "baseInfoStackView": baseInfoStackView,
                      "statsStackView": statsStackView,
                      "typesStackView": typesStackView,
                      "abilitiesStackView": abilitiesStackView,
                      "movesStackView": movesStackView]

        stacks.forEach {
            scrollView.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "H:|[\($0.key)]|",
                                                                      options: [],
                                                                      metrics: nil,
                                                                      views: stacks))
        }
        let vFormat = "V:|[imagesScrollView(200)]-16-[baseInfoStackView]-16-[statsStackView]-16-[typesStackView]-16-[abilitiesStackView]-16-[movesStackView]|"
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vFormat,
                                                           options: [],
                                                           metrics: nil,
                                                           views: stacks))
    }

    func loadData() {
        viewModel.fetch(success: { [weak self] in self?.viewModel = $0 },
                        failure: { [weak self] in self?.error = $0 })
    }
}

extension DetailViewController {
    func show(name: String,
              weight: String,
              height: String) {
        title = name
        ["weight: \(weight)", "height: \(height)"]
            .forEach { baseInfoStackView.addArrangedSubview(UILabel(text: $0)) }
    }

    func show(abilities: AbilityViewModel) {
        abilitiesStackView.addArrangedSubview(UILabel(text: "- ABILITIES -", size: 20))
        abilities
            .names
            .forEach { abilitiesStackView.addArrangedSubview(UILabel(text: $0)) }
    }

    func show(moves: MoveViewModel) {
        movesStackView.addArrangedSubview(UILabel(text: "- MOVES -", size: 20))
        moves
            .name
            .forEach { movesStackView.addArrangedSubview(UILabel(text: $0)) }
    }

    func show(types: TypeViewModel) {
        typesStackView.addArrangedSubview(UILabel(text: "- TYPES -", size: 20))
        types
            .name
            .forEach { typesStackView.addArrangedSubview(UILabel(text: $0)) }
    }

    func show(stats: StatViewModel) {
        statsStackView.addArrangedSubview(UILabel(text: "- STATS -", size: 20))
        stats
            .stat
            .forEach { statsStackView.addArrangedSubview(UILabel(text: "\($0.name): \($0.value)")) }
    }

    func show(sprites: [SpriteViewModels]) {
        sprites.forEach { sprite in
            sprite.fetchImage { [weak self ] data in
                guard let data = data,
                      let self = self else { return }
                let imgView = UIImageView(data: data)
                imgView.contentMode = .scaleAspectFit
                imgView.translatesAutoresizingMaskIntoConstraints = false
                self.imagesStackView.addArrangedSubview(imgView)
                imgView.widthAnchor.constraint(equalTo: self.imagesScrollView.widthAnchor).isActive = true
                imgView.heightAnchor.constraint(equalTo: self.imagesScrollView.heightAnchor).isActive = true
            }
        }
    }
}
 
private extension UIStackView {
    static func vertical() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }

    static func horizontal() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }
}

private extension UILabel {
    convenience init(text: String, size: CGFloat = 15) {
        self.init()
        textColor = .black
        font = UIFont.boldSystemFont(ofSize: size)
        textAlignment = .center
        self.text = text
    }
}

private extension UIScrollView {
    func addView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
}

private extension UIImageView {
    convenience init(data: Data) {
        self.init(image: UIImage(data: data))
    }
}
