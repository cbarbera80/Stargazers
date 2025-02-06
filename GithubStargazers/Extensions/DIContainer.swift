import Foundation
import Swinject

class DIContainer {
    static let shared: Container = {
        let container = Container()
      
        container.register(Networkable.self) { r in
            NetworkingManager()
        }.inObjectScope(.container)
       
        return container
    }()
}
