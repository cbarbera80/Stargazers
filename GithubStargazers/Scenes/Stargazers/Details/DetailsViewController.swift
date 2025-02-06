import UIKit
import Combine

protocol DetailsViewControllerDelegate: AnyObject { }

class DetailsViewController: UIViewController {
    // MARK: - UI properties
    var aview: DetailsView? {
        return view as? DetailsView
    }
    
    // MARK: - Business properties
    weak var delegate: DetailsViewControllerDelegate?
    private let viewModel: DetailsViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UITableViewDiffableDataSource<Int, UserViewData>?
    
    // MARK: - Object lifecycle
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func loadView() {
        view = DetailsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureDataSource()
        bind()
    }
    
    private func bind() {
        aview?.tableView.delegate = self
        
        viewModel.$stargazers
            .sink { [weak self] users in
                self?.updateSnapshot(users: users)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Configure methods
    private func configureUI() {
        title = viewModel.titleText
    }
    
    private func configureDataSource() {
        guard let tableView = aview?.tableView else { return }
        
        dataSource = UITableViewDiffableDataSource<Int, UserViewData>(tableView: tableView) { tableView, indexPath, userViewModel in
            let cell: UserTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configureCell(withViewModel: userViewModel)
            return cell
        }
        
        tableView.dataSource = dataSource
    }
    
    private func updateSnapshot(users: [UserViewData]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, UserViewData>()
        snapshot.appendSections([0])
        snapshot.appendItems(users)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func manageInfiniteScrolling(currentIndexPath: IndexPath) {
        guard viewModel.status == .idle else { return }
        guard currentIndexPath.row >= viewModel.stargazers.count - Constants.infiniteScrollingOffset else { return }
        
        Task {
            try? await viewModel.makeRequest()
        }
    }
}

extension DetailsViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = aview?.tableView else { return }
        let indexPaths = tableView.indexPathsForVisibleRows ?? []
        
        if let lastVisibleIndexPath = indexPaths.last {
            manageInfiniteScrolling(currentIndexPath: lastVisibleIndexPath)
        }
    }
}
