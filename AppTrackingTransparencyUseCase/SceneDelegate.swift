import AppTrackingTransparency
import AppTrackingKit
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var userDefaults: UserDefaults { UserDefaults.standard }
    private lazy var searchUserActionStorage = SearchUserActionStorage(userDefaults: userDefaults)
    private lazy var appLaunchIDFAStorage = AppLaunchIDFAStorage(userDefaults: userDefaults)
    private lazy var idfaPopupPresentationStorage = IDFAPopupPresentationStorage(userDefaults: userDefaults)

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }

        appLaunchIDFAStorage.incrementAppLaunch()

        window = UIWindow(windowScene: scene)
        window?.rootViewController = makeRootViewController()
        window?.makeKeyAndVisible()
    }

    // MARK: Helpers

    private func makeRootViewController() -> UIViewController {
        let navigationController = UINavigationController()

        let navigationFlow = NavigationFlow(
            navigationController: navigationController,
            searchViewController: SearchViewController(onViewDidAppear: { [unowned self] in
                searchUserActionStorage.didSearch()
            })
        )

        let homeViewController = HomeViewController(
            launchCount: appLaunchIDFAStorage.appLaunchCount,
            didSearch: { [unowned self] in self.searchUserActionStorage.markedDidSearch },
            presentedIDFAPopup: { [unowned self] in self.idfaPopupPresentationStorage.presentedIDFAPopup },
            idfaAuthStatus: { "\(ATTrackingManager.trackingAuthorizationStatus.description)" },
            onViewDidAppear: { [unowned self] homeVC in
                self.requestTrackingAuthorization { [weak homeVC] in
                    DispatchQueue.main.async {
                        homeVC?.updateStatusText()
                    }
                }
            },
            onSearch: navigationFlow.presentSearch
        )

        navigationController.viewControllers = [homeViewController]
        return navigationController
    }

    private func requestTrackingAuthorization(completion: @escaping () -> Void) {
        IDFAPresentationService.requestTrackingAuthorization(
            with: .init(
                searchUserActionStorage: searchUserActionStorage,
                appLaunchIDFAStorage: appLaunchIDFAStorage,
                idfaPopupPresentationStorage: idfaPopupPresentationStorage,
                permissionManager: ATTrackingManager.self
            ),
            showPopup: { [weak self] request in
                guard let self = self
                else { return }

                self.window?.rootViewController?.present(
                    self.makeIDFAPopup(onAllow: {
                        request.run()
                    }),
                    animated: true
                )
            },
            openSettings: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            },
            completionHandler: { _ in
                completion()
            }
        )
    }

    private func makeIDFAPopup(onAllow: @escaping () -> Void) -> UIViewController {
        let alert = UIAlertController(
            title: "Ads personalization",
            message: "Would you like to allow personalized ads?",
            preferredStyle: .alert
        )

        let allowAction = UIAlertAction(title: "Allow", style: .default, handler: { _ in onAllow() })
        let maybeLaterAction = UIAlertAction(title: "Maybe later", style: .cancel)
        [allowAction, maybeLaterAction].forEach { alert.addAction($0) }
        return alert
    }
}
