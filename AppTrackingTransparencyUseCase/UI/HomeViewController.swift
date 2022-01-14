import Foundation
import UIKit

final class HomeViewController: UIViewController {
    private let launchCount: Int
    private let didSearch: () -> Bool
    private let presentedIDFAPopup: () -> Bool
    private let idfaAuthStatus: () -> String
    private let onViewDidAppear: (HomeViewController) -> Void
    private let onSearch: () -> Void
    private var label: UILabel!

    init(
        launchCount: Int,
        didSearch: @escaping () -> Bool,
        presentedIDFAPopup: @escaping () -> Bool,
        idfaAuthStatus: @escaping () -> String,
        onViewDidAppear: @escaping (HomeViewController) -> Void,
        onSearch: @escaping () -> Void
    ) {
        self.launchCount = launchCount
        self.didSearch = didSearch
        self.presentedIDFAPopup = presentedIDFAPopup
        self.idfaAuthStatus = idfaAuthStatus
        self.onViewDidAppear = onViewDidAppear
        self.onSearch = onSearch
        super.init(nibName: nil, bundle: nil)
        self.title = "Home"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateStatusText()

        onViewDidAppear(self)
    }

    func updateStatusText() {
        label.text = """
                     App launch count: \(launchCount)
                     Did search: \(didSearch())
                     Presented IDFA Popup: \(presentedIDFAPopup())
                     Authorization status: \(idfaAuthStatus())
                     """
    }

    // MARK: Helpers

    private func setupView() {
        view.backgroundColor = .white

        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(
                title: "Search",
                image: nil,
                identifier: nil,
                discoverabilityTitle: nil,
                handler: { [weak self] _ in
                    self?.onSearch()
                }
            )
        )
        button.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.numberOfLines = 0
        label.font = .monospacedSystemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])

        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(label)

        self.label = label
    }
}
