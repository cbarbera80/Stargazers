import UIKit

class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    var coordinators: [Coordinator] = []
    
    init(withWindow window: UIWindow) {
        self.window = window
    }
    
    func start() {
        coordinators.removeAll { $0 is HomeCoordinator }
        
        let homeCoordinator = HomeCoordinator(window: window)
        homeCoordinator.start()
        coordinators.append(homeCoordinator)
    }
}
