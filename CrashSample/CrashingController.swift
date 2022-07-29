import UIKit
import SwiftUI

class CrashingController: UIViewController {

    private lazy var crashButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 8
        btn.setTitle("CRASH IT", for: .normal)
        btn.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return btn
    }()

    private var component: UIViewController?

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.accessibilityIdentifier = "crash_content_stack"
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "I should be hidden"

        contentStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentStack)
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: view.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        crashButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(crashButton)
        NSLayoutConstraint.activate([
            crashButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            crashButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            crashButton.widthAnchor.constraint(equalToConstant: 200)
        ])

        update(includeSwiftUI: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        // <<< Crash here >>>
        view.layoutIfNeeded()
    }

    @objc
    private func didTapButton() {
        update(includeSwiftUI: true)
    }

    private func update(includeSwiftUI: Bool) {
        removeExistingComponent()

        let component = createComponent(swiftUI: includeSwiftUI)
        self.component = component

        addComponent_Crashing(component)
        // Would not crash, but navigation bar would be visible
//        addComponent_Working(component)
    }

    private func createComponent(swiftUI: Bool) -> UIViewController {
        if swiftUI {
            let hostingController = UIHostingController(rootView: Text("Oh, have you fixed it?!"))
            hostingController.view.accessibilityIdentifier = "crash_hosting_view"
            hostingController.view.backgroundColor = .systemGreen
            return hostingController
        } else {
            let someController = UIViewController()
            someController.view.backgroundColor = .systemOrange
            return someController
        }
    }

    private func addComponent_Crashing(_ component: UIViewController) {
        addChild(component)
        contentStack.addArrangedSubview(component.view)
        component.didMove(toParent: self)
    }

    private func addComponent_Working(_ component: UIViewController) {
        addChild(component)
        contentStack.addSubview(component.view)
        component.didMove(toParent: self)
        contentStack.addArrangedSubview(component.view)
    }

    private func removeExistingComponent() {
        if let component = component {
            component.willMove(toParent: nil)
            component.view.removeFromSuperview()
            component.removeFromParent()
        }
        self.component = nil
    }
}
