//
//  OverlayViewController.swift
//  DebugOverlay
//
//  Created by Pavel Kondrashkov on 11/17/20.
//

import UIKit

final class OverlayViewController: UIViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else {
            return UIInterfaceOrientationMask.portrait
        }
        return rootViewController.supportedInterfaceOrientations
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIApplication.shared.statusBarStyle
    }

    override var prefersStatusBarHidden: Bool {
        return UIApplication.shared.isStatusBarHidden
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else {
            return .none
        }
        return rootViewController.preferredStatusBarUpdateAnimation
    }

    override var shouldAutorotate: Bool {
        guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else {
            return false
        }
        return rootViewController.shouldAutorotate
    }

    private var childViewController: UIViewController?
    private var childShadowView: PassthroughView?
    private let configuration: OverlayConfiguration

    init(configuration: OverlayConfiguration) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func toggleDebugMenu() {
        if childViewController != nil {
            hideDebugMenu()
        } else {
            showDebugMenu()
        }
    }

    func showDebugMenu() {
        let navigation = UINavigationController()
        let debugMenu = ListViewController(items: configuration.items)
        navigation.viewControllers = [debugMenu]
        navigation.view.layer.cornerRadius = 16

        var debugFrame = view.bounds
        debugFrame = debugFrame.insetBy(dx: 8, dy: 0)
        debugFrame = debugFrame.offsetBy(dx: 0, dy: view.bounds.height / 6)
        debugFrame.size.height = view.bounds.height * 0.6

        attachChild(navigation, frame: debugFrame)
        childViewController = navigation

        debugMenu.closeAction = { [weak self] in
            self?.hideDebugMenu()
        }

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        navigation.navigationBar.addGestureRecognizer(panGesture)
    }

    func hideDebugMenu() {
        guard let childViewController = childViewController else { return }
        detachChild(childViewController)
        self.childViewController = nil
    }
}

private extension OverlayViewController {
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        guard let child = childViewController else {
            gesture.setTranslation(.zero, in: view)
            return
        }
        let translatedFrame = child.view.frame.offsetBy(dx: translation.x, dy: translation.y)
        child.view.frame = translatedFrame
        childShadowView?.frame = translatedFrame
        gesture.setTranslation(.zero, in: view)
    }

    private func attachChild(_ child: UIViewController, frame: CGRect?) {
        addChild(child)
        view.addSubview(child.view)
        if let frame = frame {
            child.view.frame = frame
        }
        child.didMove(toParent: self)
        childViewController = child

        let childShadowView = PassthroughView()
        childShadowView.backgroundColor = .white
        childShadowView.frame = child.view.frame

        childShadowView.layer.cornerRadius = 16
        childShadowView.layer.masksToBounds = false
        childShadowView.layer.shadowColor = UIColor.black.cgColor
        childShadowView.layer.shadowOpacity = 0.2
        childShadowView.layer.shadowOffset = CGSize(width: 0, height: -1)
        childShadowView.layer.shadowRadius = 15
        childShadowView.layer.shadowPath = nil

        view.addSubview(childShadowView)
        view.bringSubviewToFront(child.view)
        self.childShadowView = childShadowView
    }

    private func detachChild(_ child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()

        childShadowView?.removeFromSuperview()
        childShadowView = nil
    }
}

extension OverlayViewController: OverlayTouchDelegate {
    func shouldHandleTouch(at point: CGPoint) -> Bool {
        let pointInLocalCoordinates = view.convert(point, from: nil)

        if childViewController?.view.frame.contains(pointInLocalCoordinates) == true {
            return true
        }

        var root = UIApplication.shared.windows.first?.rootViewController
        while root?.presentedViewController != nil {
            root = root?.presentedViewController
        }

        if let presented = root {
            let pointInPresentedView = presented.view.convert(point, from: nil)
            if presented.view.frame.contains(pointInPresentedView) {
                return true
            }
        }
        return false
    }
}
