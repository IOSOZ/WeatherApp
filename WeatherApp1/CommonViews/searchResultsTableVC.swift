//
//  searchResultsTableVC.swift
//  WeatherApp
//
//  Created by Олег Зуев on 15.04.2026.
//
import Foundation
import UIKit
import SnapKit

final class SearchResultsViewController: UITableViewController {
    
    // MARK: - Public API
    var onCitySelected: ((CitySuggestion) -> Void)?
    
    // MARK: - Private Properties
    private var suggestions: [CitySuggestion] = []
    
    private let rowHeight: CGFloat = 52
    private let maxRows = 3
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    // MARK: - Configure(Public)
    
    func configure(with suggestions: [CitySuggestion]) {
        self.suggestions = Array(suggestions.prefix(maxRows))
        tableView.reloadData()
        print("🔵 Таблица обновлена, строк: \(self.suggestions.count)")
    }
}
    
private extension SearchResultsViewController {
    func setupUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = rowHeight
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
        tableView.clipsToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = true
        tableView.snp.makeConstraints { make in
            make.height.equalTo(rowHeight * CGFloat(maxRows))
        }
    }
}

// MARK: - TableView Protocol Methods 
extension SearchResultsViewController {
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        suggestions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = suggestions[indexPath.row].title
        cell.textLabel?.font = UIFont(name: "SFPro-Regular", size: 16)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onCitySelected?(suggestions[indexPath.row])
    }
}

