//
//  ContainerViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 26.03.2023.
//

import UIKit

class ContainerViewController: UIViewController, CoordinatedProtocol {
    
    enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed
    
    var coordinator: CoordinatorProtocol?
    
    var profileVC: ProfileViewController?
    
    var sideMenuVC: SideMenuViewController?
    
    var navVc: UINavigationController?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildControllers()

    }

    // MARK: - Setup

    private func addChildControllers() {
        addChild(sideMenuVC!)
        view.addSubview(sideMenuVC!.view)
        sideMenuVC?.didMove(toParent: self)
        let navVc = UINavigationController(rootViewController: profileVC!)
        profileVC!.delegate = self
        addChild(navVc)
        view.addSubview(navVc.view)
        navVc.didMove(toParent: self)
        self.navVc = navVc
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.isHidden = true
    }

}

//MARK: - SideMenuViewControllerDelegate

extension ContainerViewController: SideMenuViewControllerDelegate {
    func likedTapped() {
        coordinator!.setTabTo(tab: .liked)
    }
    
    func settingsTapped() {
        coordinator?.ivent(action: .showSettings, iniciator: self)
    }
    
    func logOutTapped() {
        print("Log out tapped")
    }
    
    func galleryTapped() {
        print("Gallery tapped")
    }
}

//MARK: - ProfileViewControllerDelegate

extension ContainerViewController: ProfileViewControllerDelegate {
    
    func menuButtonTapped() {
        switch menuState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,options: .curveEaseOut) {
                self.navVc?.view.frame.origin.x = -(self.profileVC?.view.frame.size.width)! + 100
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
                }
            }
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,options: .curveEaseOut) {
                self.navVc?.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                }
            }
        }
    }
}
