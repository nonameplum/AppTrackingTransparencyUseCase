// Copyright © 2020 Omio. All rights reserved.

#if canImport(AppTrackingTransparency)
import AppTrackingTransparency
#endif
import Foundation

@available(iOS 14, *)
struct ATTrackingManagerAdapter {
    // MARK: Types
    private enum Constants {
        static let didRequestTrackingAuthorizationKey = "ATTrackingService_didRequestTrackingAuthorizationKey"
    }

    // MARK: Properties
    private let trackingManager: ATTrackingManagerProtocol.Type

    // MARK: Initialization
    init(trackingManager: ATTrackingManagerProtocol.Type) {
        self.trackingManager = trackingManager
    }

    func requestTrackingAuthorization(
        openSettings: @escaping () -> Void,
        completionHandler: @escaping (ATTrackingManagerAuthorizationState) -> Void
    ) {
        guard self.trackingManager.trackingAuthorizationState != .authorized
        else { return }

        if self.didRequestTrackingAuthorization {
            openSettings()
        } else {
            self.trackingManager.requestTrackingAuthorization(completionHandler: completionHandler)
        }
    }

    // MARK: Helpers
    private var didRequestTrackingAuthorization: Bool {
        return self.trackingManager.trackingAuthorizationState != .notDetermined
    }
}

#if canImport(AppTrackingTransparency)
@available(iOS 14, *)
extension ATTrackingManager: ATTrackingManagerProtocol {
    public static var trackingAuthorizationState: ATTrackingManagerAuthorizationState {
        let status: ATTrackingManager.AuthorizationStatus = ATTrackingManager.trackingAuthorizationStatus
        switch status {
        case .authorized: return .authorized
        case .denied: return .denied
        case .notDetermined: return .notDetermined
        case .restricted: return .restricted
        @unknown default:
            return .notDetermined
        }
    }

    public static func requestTrackingAuthorization(
        completionHandler completion: @escaping (ATTrackingManagerAuthorizationState) -> Void
    ) {
        self.requestTrackingAuthorization { (status) in
            completion(status.idfaAuthorizationState)
        }
    }
}

@available(iOS 14, *)
extension ATTrackingManager.AuthorizationStatus {
    fileprivate var idfaAuthorizationState: ATTrackingManagerAuthorizationState {
        switch self {
        case .authorized: return .authorized
        case .denied: return .denied
        case .notDetermined: return .notDetermined
        case .restricted: return .restricted
        @unknown default:
            return .notDetermined
        }
    }
}
#endif
