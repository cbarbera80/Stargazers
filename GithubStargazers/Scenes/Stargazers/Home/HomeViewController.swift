import UIKit
import Combine

protocol HomeViewControllerDelegate: AnyObject {
    func showResults(_ results: [GithubUser], user: String, repo: String)
}

class HomeViewController: UIViewController {
    
    // MARK: - UI properties
    var aview: HomeView? {
        return view as? HomeView
    }
    
    // MARK: - Business properties
    weak var delegate: HomeViewControllerDelegate?
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Object lifecycle
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func loadView() {
        view = HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    // MARK: - Configure methods
    private func configureUI() {
        title = L10n.Home.title
    }
    
    private func bind() {
        cancellables.forEach { $0.cancel() }
        
        guard let aView = aview else { return }
        aView.update(with: viewModel)
        
        aView
            .userTextField
            .textPublisher
            .replaceNil(with: "")
            .assign(to: \.user, on: viewModel)
            .store(in: &cancellables)
        
        aView
            .repoTextField
            .textPublisher
            .replaceNil(with: "")
            .assign(to: \.repo, on: viewModel)
            .store(in: &cancellables)
        
        aView
            .searchButton
            .tapPublisher
            .sink { [weak self] _ in self?.search() }
            .store(in: &cancellables)
        
        aView
            .showDataButton
            .tapPublisher
            .sink { [weak self] _ in self?.showData() }
            .store(in: &cancellables)
    }
    
    // MARK: - Private methods
    @MainActor
    private func search() {
        Task {
            await viewModel.makeRequest()
            view.endEditing(true)
        }
    }
    
    private func showData() {
        guard let data = viewModel.stargazers else { return }
        delegate?.showResults(data, user: viewModel.user, repo: viewModel.repo)
    }
}
