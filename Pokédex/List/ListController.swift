import Foundation
import UIKit

final class ListViewController: UITableViewController {
    private let viewModel: ListViewModel
    private var dataSource: [ListCellViewModel] {
        didSet { tableView.reloadData() }
    }
    private var error: Error? {
        didSet { alert(title: "Error", message: error?.localizedDescription ?? "Unknown") }
    }

    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        self.dataSource = []
        self.error = nil
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not availble!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Pokédex"

        tableView.register(ListCell.self, forCellReuseIdentifier: "listCell")

        loadData()
    }

    func loadData() {
        viewModel.fetch(success: { [weak self] in self?.dataSource = $0 },
                        failure: { [weak self] in self?.error = $0 })
    }
    
    func nextData() {
        viewModel.fetchNext(success: { [weak self] in self?.dataSource = $0 },
                            failure: { [weak self] in self?.error = $0 })
    }
}

extension ListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell",
                                                 for: indexPath) as? ListCell
        cell?.setup(viewModel: dataSource[indexPath.row])
        return cell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dataSource[indexPath.row].open { [weak self] in
            viewModel.show(pokemon: $0, sender: self)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataSource.count - 1 { nextData() }
    }
}
