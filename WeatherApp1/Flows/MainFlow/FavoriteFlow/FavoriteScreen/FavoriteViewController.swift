//
//  FavoriteViewController.swift
//  WeatherApp
//
//  Created by Олег Зуев on 07.05.2026.
//

import UIKit
import SnapKit

class FavoriteViewController: UIViewController {

    // MARK: - UI
    private let titleLabel = UILabel()
    
    // MARK: - VM
    private let viewModel: FavoriteViewModel
    
    // MARK: - Init
    init(viewModel: FavoriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
}

private extension FavoriteViewController {
    // MARK: -  Setup UI
    func setupUI() {
        
        // MARK: - Navigation
        navigationController?.navigationBar.backgroundColor = .orange
        navigationItem.title = "Отдельный флоу со своим NavBarom"
        
        // MARK: - Views Setup
        view.backgroundColor = .orange
        
        // MARK: - Labels Setup
        titleLabel.text = "Тут типа экран избраного"
        titleLabel.font = UIFont(name: "SFPro-Semibold", size: 24)
        titleLabel.textColor = UIColor(red: 0/255, green: 26/255, blue: 52/255, alpha: 1)
        
        // MARK: -  Add Views
        view.addSubview(titleLabel)
    }
    
    // MARK: -  Setup Layout
    func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
