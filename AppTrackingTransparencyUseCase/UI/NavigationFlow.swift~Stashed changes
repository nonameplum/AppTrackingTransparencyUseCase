import Foundation
import UIKit

struct NavigationFlow {
    let navigationController: UINavigationController
    let searchViewController: () -> UIViewController

    init(navigationController: UINavigationController,
         searchViewController: @escaping @autoclosure () -> UIViewController
    ) {
        self.navigationController = navigationController
        self.searchViewController = searchViewController
    }

    func presentSearch() {
        navigationController.pushViewController(searchViewController(), animated: true)
    }
}
