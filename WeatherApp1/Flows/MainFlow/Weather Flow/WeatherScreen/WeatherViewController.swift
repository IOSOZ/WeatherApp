//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Олег Зуев on 30.03.2026.
//

import UIKit
import SnapKit
import Combine

class WeatherViewController: UIViewController {
    
    // MARK: - UI
    private let loadingView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let currentWeatherView = UIView()
    private let searchBar = UISearchBar()
    private let resultsTableView = UITableView()
    
    private let logOutButton = UIButton()
    
    private let cityLabel = UILabel()
    private let weatherIcon = UIImageView()
    private let currentTemperatureLabel = UILabel()
    private let currentWeatherLabel = UILabel()
    private let feelLikeTemperatureLabel = UILabel()
    
    private let windSpeedLabel = UILabel()
    private let humidityLabel = UILabel()
    private let pressureLabel = UILabel()
    
    private let hoursForecastView = Forecast24HoursView()
    
    private let sevenDaysForecastLabel = UILabel()
    private let nightLabel = UILabel()
    private let dayLabel = UILabel()
    private let weeklyForecastView = WeeklyForecastView()
    
    private let searchViewStack = UIStackView()
    private let currentWeatherUpperStack = UIStackView()
    private let currentWetherDescriptionStack = UIStackView()
    private let currentsWeatherDetailsStack = UIStackView()
    private let currentWeatherMainStack = UIStackView()
    private let dayAndNightLabel = UIStackView()
    
    // MARK: - VM
    private let viewModel: WeatherViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Private Properties
    private var snapshot: [CitySuggestion] = []
    
    // MARK: - Init
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupActions()
        bindViewModel()
        setupKeyBoard()
        viewModel.viewDidLoad()
    }
}

private extension WeatherViewController {
    // MARK: - Setup UI
    func setupUI() {
        // MARK: - Views Setup
        view.backgroundColor = .white
        currentWeatherView.backgroundColor = .appBlue
        currentWeatherView.layer.cornerRadius = 24
        currentWeatherView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        currentWeatherView.clipsToBounds = true
        
        // MARK: - SearchBar Setup
        searchBar.placeholder = "Поиск города"
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = UIColor(white: 1, alpha: 0.2)
        searchBar.searchTextField.textColor = .white
        searchBar.tintColor = .white
        searchBar.delegate = self
        
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.layer.cornerRadius = 12
        searchBar.searchTextField.layer.masksToBounds = true
        
        logOutButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
        logOutButton.tintColor = .white
        logOutButton.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        logOutButton.layer.cornerRadius = 12
        
        // MARK: - ResultsTableView Setup
        resultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        resultsTableView.rowHeight = 52
        resultsTableView.isHidden = true
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.isScrollEnabled = false

        resultsTableView.backgroundColor = .white
        resultsTableView.layer.cornerRadius = 12
        resultsTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        resultsTableView.layer.masksToBounds = true
        resultsTableView.separatorColor = UIColor(white: 0, alpha: 0.1)
        resultsTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        // MARK: - ActivityIndicator
        loadingView.isHidden = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .appBlue
        
        // MARK: - Labels Setup
        cityLabel.font = UIFont(name: "SFPro-Semibold", size: 40)
        cityLabel.textColor = .white
        cityLabel.adjustsFontSizeToFitWidth = true
        cityLabel.minimumScaleFactor = 0.6
        cityLabel.numberOfLines = 1
        
        currentTemperatureLabel.font = UIFont(name: "SFPro-Regular", size: 40)
        currentTemperatureLabel.textColor = .white
        
        currentWeatherLabel.font = UIFont(name: "SFPro-Regular", size: 16)
        currentWeatherLabel.textColor = .white
        
        feelLikeTemperatureLabel.font = UIFont(name: "SFPro-Regular", size: 16)
        feelLikeTemperatureLabel.textColor = UIColor(white: 1, alpha: 0.5)
        
        windSpeedLabel.font = UIFont(name: "SFPro-Regular", size: 14)
        windSpeedLabel.textColor = .white
        
        humidityLabel.font = UIFont(name: "SFPro-Regular", size: 14)
        humidityLabel.textColor = .white
        
        pressureLabel.font = UIFont(name: "SFPro-Regular", size: 14)
        pressureLabel.textColor = .white
        
        sevenDaysForecastLabel.font = UIFont(name: "SFPro-Semibold", size: 22)
        sevenDaysForecastLabel.textColor = .black
        sevenDaysForecastLabel.text = "Прогноз на 10 дней"
        
        nightLabel.font = UIFont(name: "SFPro-Regular", size: 18)
        nightLabel.textColor = .black
        nightLabel.text = "День"
        
        dayLabel.font = UIFont(name: "SFPro-Regular", size: 18)
        dayLabel.textColor = UIColor(white: 0, alpha: 0.5)
        dayLabel.text = "Ночь"
        
        // MARK: - Stacks Setup
        searchViewStack.axis = .horizontal
        searchViewStack.spacing = 0
        
        currentWetherDescriptionStack.axis = .vertical
        currentWetherDescriptionStack.alignment = .center
        currentWetherDescriptionStack.spacing = 8
        
        currentsWeatherDetailsStack.axis = .vertical
        currentsWeatherDetailsStack.alignment = .leading
        currentsWeatherDetailsStack.spacing = 8
        
        currentWeatherUpperStack.axis = .horizontal
        currentWeatherUpperStack.alignment = .center
        currentWeatherUpperStack.spacing = 4
        
        dayAndNightLabel.axis = .horizontal
        dayAndNightLabel.alignment = .center
        dayAndNightLabel.spacing = 20
        
        currentWeatherMainStack.axis = .vertical
        currentWeatherMainStack.alignment = .center
        currentWeatherMainStack.spacing = 12
        
        // MARK: - Add Views
        searchViewStack.addArrangedSubview(searchBar)
        searchViewStack.addArrangedSubview(logOutButton)
        
        currentWeatherUpperStack.addArrangedSubview(currentTemperatureLabel)
        currentWeatherUpperStack.addArrangedSubview(weatherIcon)
        
        currentWetherDescriptionStack.addArrangedSubview(currentWeatherLabel)
        currentWetherDescriptionStack.addArrangedSubview(feelLikeTemperatureLabel)
        
        currentsWeatherDetailsStack.addArrangedSubview(windSpeedLabel)
        currentsWeatherDetailsStack.addArrangedSubview(humidityLabel)
        currentsWeatherDetailsStack.addArrangedSubview(pressureLabel)
        
        currentWeatherMainStack.addArrangedSubview(cityLabel)
        currentWeatherMainStack.addArrangedSubview(currentWeatherUpperStack)
        currentWeatherMainStack.addArrangedSubview(currentWetherDescriptionStack)
        
        currentWeatherView.addSubview(searchViewStack)
        currentWeatherView.addSubview(currentWeatherMainStack)
        currentWeatherView.addSubview(currentsWeatherDetailsStack)
        currentWeatherView.addSubview(hoursForecastView)
        
        dayAndNightLabel.addArrangedSubview(nightLabel)
        dayAndNightLabel.addArrangedSubview(dayLabel)
        
        loadingView.contentView.addSubview(activityIndicator)
        
        view.addSubview(currentWeatherView)
        view.addSubview(sevenDaysForecastLabel)
        view.addSubview(dayAndNightLabel)
        view.addSubview(weeklyForecastView)
        view.addSubview(resultsTableView)
        view.addSubview(loadingView)
    }
    
    // MARK: - Setup Layout
    func setupLayout() {
        currentWeatherView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(hoursForecastView).offset(16)
        }
        
        searchViewStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(44)
        }
        
        logOutButton.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
        
        currentWeatherMainStack.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        currentsWeatherDetailsStack.snp.makeConstraints { make in
            make.centerY.equalTo(hoursForecastView)
            make.leading.equalToSuperview().inset(16)
        }
        
        hoursForecastView.snp.makeConstraints { make in
            make.top.equalTo(currentWeatherMainStack.snp.bottom).offset(16)
            make.trailing.equalToSuperview()
            make.leading.equalTo(currentWeatherView.snp.centerX)
            make.height.equalTo(90)
        }
        
        weatherIcon.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
        
        cityLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(view.snp.width).offset(-32)
        }
        
        resultsTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(156)
        }
        
        sevenDaysForecastLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(currentWeatherView.snp.bottom).offset(16)
        }
        
        dayAndNightLabel.snp.makeConstraints { make in
            make.top.equalTo(sevenDaysForecastLabel.snp.bottom)
            make.trailing.equalToSuperview().inset(16)
        }
        
        weeklyForecastView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(dayAndNightLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(loadingView.contentView)
        }

    }
    
    // MARK: - Setup KeyBoard
    func setupKeyBoard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - OBJC Methods
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func logOut() {
        viewModel.didTapLogout()
    }
    
    func setupActions() {
        logOutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
    }
}

private extension WeatherViewController {
    // MARK: - Bind ViewModel
    func bindViewModel() {
        viewModel.$state
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
        
        viewModel.$state
            .map(\.citySuggestions)
            .sink { [weak self] suggestions in
                self?.snapshot = suggestions
                self?.resultsTableView.reloadData()
                self?.updateSearchResultsVisibility(isVisible: !suggestions.isEmpty)
            }
            .store(in: &cancellables)
    }
    // MARK: - Render
    func render(_ state: WeatherViewState) {
        if state.errorMessage != nil {
            loadingView.isHidden = true
            activityIndicator.stopAnimating()
            print("Ошибка получения погоды")
            return
        }
        
        if state.isLoading {
                loadingView.isHidden = false
                activityIndicator.startAnimating()
            } else {
                loadingView.isHidden = true
                activityIndicator.stopAnimating()
            }
        
        guard let forecast = state.forecast else { return }
        
        AppServices.shared.imageCacheService.loadImage(from: forecast.current.icon) { [weak self] image in
            self?.weatherIcon.image = image
        }
        
        cityLabel.text = state.cityTitle
        currentTemperatureLabel.text = "\(forecast.current.temperature)°С"
        currentWeatherLabel.text = forecast.current.description
        feelLikeTemperatureLabel.text = "Ощущается как \(forecast.current.feelLikeTemp) °С"
        windSpeedLabel.text = "Скорость ветра: \(forecast.current.windSpeed) м/с"
        humidityLabel.text = "Влажность воздуха: \(forecast.current.humidity)%"
        pressureLabel.text = "Атм. давление: \(forecast.current.pressure) mm"
        
        hoursForecastView.configure(dayForecast: forecast.hourForecast, currentDate: forecast.localDate)
        weeklyForecastView.configure(daysForecast: forecast.weeklyForecast, currentDate: forecast.localDate)
    }
}

// MARK: - UISearchBarDelegate
extension WeatherViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.didEnter(letters: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        resultsTableView.isHidden = true
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func updateSearchResultsVisibility(isVisible: Bool) {
        if isVisible {
            UIView.animate(withDuration: 0.2) {
                self.logOutButton.transform = CGAffineTransform(translationX: 52, y: 0)
                self.logOutButton.alpha = 0
            } completion: { _ in
                self.logOutButton.isHidden = true
                self.logOutButton.transform = .identity
            }
        } else {
            logOutButton.isHidden = false
            logOutButton.transform = CGAffineTransform(translationX: 52, y: 0)
            logOutButton.alpha = 0
            
            UIView.animate(withDuration: 0.2) {
                self.logOutButton.transform = .identity
                self.logOutButton.alpha = 1
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.resultsTableView.alpha = isVisible ? 1 : 0
            self.searchBar.searchTextField.layer.maskedCorners = isVisible ?
            [.layerMinXMinYCorner, .layerMaxXMinYCorner] :
            [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } completion: { _ in
            self.resultsTableView.isHidden = !isVisible
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        snapshot.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = snapshot[indexPath.row].title
        cell.textLabel?.font = UIFont(name: "SFPro-Regular", size: 16)
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = UIColor(red: 0/255, green: 26/255, blue: 52/255, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let suggestion = snapshot[indexPath.row]
        viewModel.didSelectCity(suggestion)
        searchBar.text = ""
        resultsTableView.isHidden = true
        searchBar.resignFirstResponder()
    }
}
