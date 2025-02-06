import Foundation

protocol Coordinator: AnyObject {
    func start()
    var coordinators: [Coordinator] { get set }
}
