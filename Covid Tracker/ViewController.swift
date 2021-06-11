//
//  ViewController.swift
//  Covid Tracker
//
//  Created by Alley Pereira on 10/06/21.
//

import UIKit

class ViewController: UIViewController {

    private var scope: APICaller.DataScope = .national

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        title = "Covid cases"
        createFilterButton()
    }

    private func fetchData() {

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
