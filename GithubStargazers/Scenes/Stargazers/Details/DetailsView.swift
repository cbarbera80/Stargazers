import UIKit
import Anchorage
import Combine

class DetailsView: UIView {
    
    // MARK: - Properties
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UI properties
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(UserTableViewCell.self)
        return view
    }()
    
    var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.backgroundColor.color
        return view
    }()
    
    var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
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
    
    private func refreshStatus(_ status: DetailsViewStatus) {
        switch status {
        case .idle:
            loadingView.isHidden = true
            activityIndicatorView.stopAnimating()
        case .loading:
            loadingView.isHidden = false
            activityIndicatorView.startAnimating()
        }
    }
    
    func update(with viewModel: DetailsViewModel) {
        viewModel
            .$status
            .sink { [weak self] status in self?.refreshStatus(status) }
            .store(in: &cancellables)
    }
    
    private func configureUI() {
        backgroundColor = .white
        
        // tableView
        addSubview(tableView)
        
        // activity
        loadingView.addSubview(activityIndicatorView)
        
        // loadingView
        addSubview(loadingView)
    }
    
    private func configureConstraints() {
        // tableView
        tableView.edgeAnchors == edgeAnchors
        
        loadingView.leadingAnchor == leadingAnchor
        loadingView.trailingAnchor == trailingAnchor
        loadingView.bottomAnchor == bottomAnchor
        loadingView.heightAnchor == 50
        
        activityIndicatorView.centerAnchors == loadingView.centerAnchors
    }
}
