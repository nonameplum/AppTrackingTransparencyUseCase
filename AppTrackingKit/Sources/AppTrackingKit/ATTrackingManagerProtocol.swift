import Foundation

public enum ATTrackingManagerAuthorizationState: UInt {
    case notDetermined = 0
    case restricted = 1
    case denied = 2
    case authorized = 3
}

@available(iOS 14, *)
public protocol ATTrackingManagerProtocol {
    static var trackingAuthorizationState: ATTrackingManagerAuthorizationState { get }
    static func requestTrackingAuthorization(
        completionHandler completion: @escaping (ATTrackingManagerAuthorizationState) -> Void
    )
}
