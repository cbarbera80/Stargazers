import Anchorage
import UIKit
import Combine

class HomeView: UIView {
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UI properties
    lazy var userLabel: UILabel = {
        let view = UILabel()
        view.text = L10n.Home.UserLabel.text
        return view
    }()
    
    lazy var userTextField: UITextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.placeholder = L10n.Home.UserTextField.text
        view.accessibilityIdentifier = HomeViewAccessibilityIdentifiers.userTextFieldIdentifier.rawValue
        return view
    }()
    
    lazy var repoLabel: UILabel = {
        let view = UILabel()
        view.text = L10n.Home.RepoTLabel.text
        return view
    }()
    
    lazy var repoTextField: UITextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.placeholder = L10n.Home.RepoTextField.text
        view.accessibilityIdentifier = HomeViewAccessibilityIdentifiers.repoTextFieldIdentifier.rawValue
        return view
    }()
    
    lazy var searchButton: UIButton = {
        let view = UIButton()
        view.setTitle(L10n.Home.SearchButton.title, for: .normal)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .red
        view.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)
        view.setTitleColor(UIColor.white, for: .normal)
        view.accessibilityIdentifier = HomeViewAccessibilityIdentifiers.searchButtonIdentifier.rawValue
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.accessibilityIdentifier = HomeViewAccessibilityIdentifiers.activityIndicatorIdentifier.rawValue
        return view
    }()
    
    lazy var resultsLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 16)
        view.textColor = .red
        view.numberOfLines = 2
        return view
    }()
    
    lazy var showDataButton: UIButton = {
        let view = UIButton()
        view.setTitle(L10n.Home.ShowResults.text, for: .normal)
        view.setTitleColor(.red, for: .normal)
        return view
    }()
    
    // MARK: - Object lifecycle
        
    init() {
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) isn't supported")
    }

    // MARK: - Configure methods
    func update(with viewModel: HomeViewModel) {
        viewModel
            .confirmButtonEnabled
            .assign(to: \.isEnabled, on: searchButton)
            .store(in: &cancellables)
        
        viewModel
            .$status
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in self?.setStatus(status) }
            .store(in: &cancellables)
    }
    
    private func setStatus(_ status: HomeViewStatus) {
        switch status {
        case .idle:
            activityIndicator.stopAnimating()
            resultsLabel.isHidden = true
            showDataButton.isHidden = true
        case .loading:
            activityIndicator.startAnimating()
            resultsLabel.isHidden = true
            showDataButton.isHidden = true
        case .noData:
            activityIndicator.stopAnimating()
            resultsLabel.isHidden = false
            resultsLabel.text = L10n.Home.ShowResults.NoData.text
            showDataButton.isHidden = true
        case .dataFound:
            activityIndicator.stopAnimating()
            resultsLabel.isHidden = true
            showDataButton.isHidden = false
        case .error:
            activityIndicator.stopAnimating()
            resultsLabel.isHidden = false
            resultsLabel.text = L10n.Home.ShowResults.NoData.text
            showDataButton.isHidden = true
        }
    }
    
    private func configureUI() {
        backgroundColor = Asset.backgroundColor.color
        
        // userLabel
        addSubview(userLabel)
        
        // userTextField
        addSubview(userTextField)
        
        // repoLabel
        addSubview(repoLabel)
        
        // repoTextField
        addSubview(repoTextField)
        
        // searchButton
        addSubview(searchButton)
        
        // activityIndicator
        addSubview(activityIndicator)
        
        // resultsLabel
        addSubview(resultsLabel)
        
        // showDataButton
        addSubview(showDataButton)
    }
    
    private func configureConstraints() {
        // userLabel
        userLabel.topAnchor == safeAreaLayoutGuide.topAnchor + 16
        userLabel.leadingAnchor == leadingAnchor + 16
        
        // userTextField
        userTextField.topAnchor == userLabel.bottomAnchor + 8
        userTextField.leadingAnchor == userLabel.leadingAnchor
        userTextField.trailingAnchor == trailingAnchor - 16
        
        // repoLabel
        repoLabel.topAnchor == userTextField.bottomAnchor + 16
        repoLabel.leadingAnchor == userTextField.leadingAnchor
        
        // repoTextField
        repoTextField.topAnchor == repoLabel.bottomAnchor + 8
        repoTextField.leadingAnchor == repoLabel.leadingAnchor
        repoTextField.trailingAnchor == userTextField.trailingAnchor
        
        // searchButton
        searchButton.leadingAnchor == repoTextField.leadingAnchor
        searchButton.trailingAnchor == repoTextField.trailingAnchor
        searchButton.topAnchor == repoTextField.bottomAnchor + 24
        searchButton.heightAnchor == 48
        
        activityIndicator.centerXAnchor == centerXAnchor
        activityIndicator.topAnchor == searchButton.bottomAnchor + 50
        
        resultsLabel.centerYAnchor == activityIndicator.centerYAnchor
        resultsLabel.leadingAnchor == searchButton.leadingAnchor
        resultsLabel.trailingAnchor == searchButton.trailingAnchor
        
        // showDataButton
        showDataButton.centerXAnchor == centerXAnchor
        showDataButton.centerYAnchor == activityIndicator.centerYAnchor
    }
}
