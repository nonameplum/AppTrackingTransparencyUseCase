import Foundation
import UIKit

final class SearchViewController: UIViewController {
    private let onViewDidAppear: () -> Void

    init(onViewDidAppear: @escaping () -> Void) {
        self.onViewDidAppear = onViewDidAppear
        super.init(nibName: nil, bundle: nil)
        self.title = "Search"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        onViewDidAppear()
    }
}
