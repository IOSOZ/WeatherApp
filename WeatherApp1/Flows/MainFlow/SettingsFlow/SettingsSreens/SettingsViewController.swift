//
//  SettingsViewController.swift
//  WeatherApp
//
//  Created by Олег Зуев on 07.05.2026.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    // MARK: - UI
    private let titleLabel = UILabel()
    
    // MARK: - VM
    private let viewModel: SettingsViewModel
    
    // MARK: - Init
    init(viewModel: SettingsViewModel) {
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
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

private extension SettingsViewController {
    // MARK: -  Setup UI
    func setupUI() {
        
        // MARK: - Views Setup
        view.backgroundColor = .green
        
        // MARK: - Labels Setup
        titleLabel.text = "Тут типа экран настроек"
        titleLabel.font = UIFont(name: "SFPro-Semibold", size: 24)
        titleLabel.textColor = UIColor(red: 0/255, green: 26/255, blue: 52/255, alpha: 1)
        
        // MARK: -  Add Views
        view.addSubview(titleLabel)
    }
    
    // MARK: - Setup NavigationBar
    func setupNavBar() {
        
        navigationItem.title = "Настройки"
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(didTapBack)
        )
        
        let logOutButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(didTapLogOut)
        )
        
        navigationItem.rightBarButtonItem = logOutButton
        navigationItem.leftBarButtonItem = backButton
    }
    
    // MARK: -  Setup Layout
    func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - OBJC Methods
    @objc func didTapBack() {
        viewModel.didTapBackOnTabFlow()
    }
    
    @objc func didTapLogOut() {
        viewModel.didTapLogOut()
    }
}
