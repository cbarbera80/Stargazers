import Foundation

struct UserViewData: Hashable {
    let user: GithubUser
    
    init(user: GithubUser) {
        self.user = user
    }
    
    var userText: String {
        return user.login
    }
    
    var userPictureURL: URL? {
        return URL(string: user.avatarUrl)
    }
}
