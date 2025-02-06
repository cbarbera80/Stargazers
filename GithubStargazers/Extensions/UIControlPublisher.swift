import UIKit
import Combine

final class UIControlSubscription<SubscriberType: Subscriber, Control: UIControl>: Subscription where SubscriberType.Input == Control {
    private var subscriber: SubscriberType?
    private let control: Control

    init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(eventHandler), for: event)
    }

    func request(_ demand: Subscribers.Demand) {}

    func cancel() {
        subscriber = nil
    }

    @objc private func eventHandler() {
        _ = subscriber?.receive(control)
    }
}

struct UIControlPublisher: Publisher {
    typealias Output = UIControl
    typealias Failure = Never

    let control: UIControl
    let controlEvents: UIControl.Event

    init(control: UIControl, events: UIControl.Event) {
        self.control = control
        self.controlEvents = events
    }
    
    func receive<S>(subscriber: S) where S: Subscriber, S.Failure == UIControlPublisher.Failure, S.Input == UIControlPublisher.Output {
        let subscription = UIControlSubscription(subscriber: subscriber, control: control, event: controlEvents)
        subscriber.receive(subscription: subscription)
    }
}

protocol CombineCompatible { }

extension UIControl: CombineCompatible { }

extension CombineCompatible where Self: UIControl {
    func publisher(for events: UIControl.Event) -> UIControlPublisher {
        return UIControlPublisher(control: self, events: events)
    }
}

extension UIButton {
    var tapPublisher: UIControlPublisher {
        publisher(for: .touchUpInside)
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String?, Never> {
        publisher(for: .editingChanged)
            .map { control -> String? in
                (control as? UITextField)?.text
            }
            .eraseToAnyPublisher()
    }
}
