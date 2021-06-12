//
//  ViewController.swift
//  Covid Tracker
//
//  Created by Alley Pereira on 10/06/21.
//

import UIKit

class ViewController: UIViewController {

    private var scope: APICaller.DataScope = .national

    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        formatter.formatterBehavior = .default
        return formatter
    }()

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    private var dayData: [DayData] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        title = "Covid cases"
        createFilterButton()
        configureTable()
        fetchData()
    }

    private func fetchData() {
        APICaller.shared.getCovidData(for: scope) { [weak self] result in
            switch result {
            case .success(let dayData):
                self?.dayData = dayData
                break
            case .failure(let error):
                print(error)
            }
        }
    }

    private func createFilterButton() {

        let buttonTitle: String = {
            switch scope {
            case .national:
                return "National"
            case .state(let state):
                return state.name
            }
        }()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: buttonTitle,
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapFilter))
    }

    @objc private func didTapFilter() {
        let vc = FilterViewController()
        vc.completion = { [weak self] state in
            self?.scope = .state(state)
            self?.fetchData()
            self?.createFilterButton()
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }

}

extension ViewController: UITableViewDataSource {

    private func configureTable() {
        view.addSubview(tableView)
        tableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dayData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = createText(with: data)
        return cell
    }

    private func createText(with data: DayData) -> String? {
        guard let date = DateFormatter.americanDateFormatter.date(from: data.date) else { return nil }
        let dateString = DateFormatter.brazilianDateFormatter.string(from: date)
        let total = Self.numberFormatter.string(from: NSNumber(value: data.count))
        return "\(dateString): \(total ?? "\(data.count)")"
    }
}
