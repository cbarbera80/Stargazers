import UIKit
import Anchorage
import Kingfisher

class UserTableViewCell: UITableViewCell, ReusableView {
    
    // MARK: - business
    private var cancellationToken: DownloadTask?
    
    // MARK: - UI
    var userAvatarView: UIImageView = {
        var view = UIImageView()
        view.layer.cornerRadius = 32
        view.layer.masksToBounds = true
        return view
    }()
    
    var usernameLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
        configureConstraints()
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        userAvatarView.image = nil
        cancellationToken?.cancel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure methods
    
    func configureCell(withViewModel viewModel: UserViewData) {
        usernameLabel.text = viewModel.userText
        cancellationToken = userAvatarView.kf.setImage(with: viewModel.userPictureURL)
    }
    
    private func configureUI() {
        // userAvatarView
        contentView.addSubview(userAvatarView)
        
        // usernameLabel
        contentView.addSubview(usernameLabel)
    }
    
    private func configureConstraints() {
        
        userAvatarView.leadingAnchor == contentView.leadingAnchor + 16
        userAvatarView.heightAnchor == 64
        userAvatarView.widthAnchor == 64
        userAvatarView.centerYAnchor == centerYAnchor
        
        usernameLabel.topAnchor == contentView.topAnchor + 32
        usernameLabel.bottomAnchor == contentView.bottomAnchor - 32
        usernameLabel.leadingAnchor == userAvatarView.trailingAnchor + 16
    }
    
}
