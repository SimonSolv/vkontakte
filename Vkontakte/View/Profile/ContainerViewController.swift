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
    
    lazy var settingsVC: UIViewController = {
        let factory = Factory()
        let controller = factory.createController(type: .settings, coordinator: self.coordinator!)
        return controller
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildControllers()
    }

    // MARK: - Setup

    private func addChildControllers() {
        //SideMenu
        sideMenuVC?.delegate = self
        addChild(sideMenuVC!)
        view.addSubview(sideMenuVC!.view)
        sideMenuVC?.didMove(toParent: self)
        
        //Profile
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
    func didSelect(menuItem: SideMenuViewController.MenuOptions) {
        toggleMenu { [weak self] in
            switch menuItem {
            case .liked:
                print("Liked selected")
                self?.coordinator?.setTabTo(tab: .liked)
            case .photos:
                break
            case .settings:
                guard let strongSelf = self else {
                    return
                }
                strongSelf.addSettings()
            case .logOut:
                break
            case .home:
                guard let strongSelf = self else {
                    return
                }
                for child in strongSelf.profileVC!.children {
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                }
                strongSelf.profileVC!.title = "@\(strongSelf.profileVC?.user.nickName ?? "NickName")"
            }
        }
    }
    
    private func addSettings() {
        profileVC?.addChild(settingsVC)
        profileVC?.view.addSubview(settingsVC.view)
        settingsVC.view.frame = view.frame
        settingsVC.didMove(toParent: profileVC)
        profileVC?.title = settingsVC.title
    }
    
    func showProfile() {
        self.profileVC?.didMove(toParent: self)
    }
}

//MARK: - ProfileViewControllerDelegate

extension ContainerViewController: ProfileViewControllerDelegate {
    
    func menuButtonTapped() {
        toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?) {
        switch menuState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,options: .curveEaseOut) {
                self.navVc?.view.frame.origin.x = -(self.profileVC?.view.frame.size.width)! + 100
                self.profileVC?.view.isUserInteractionEnabled = false
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
                }
            }
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,options: .curveEaseOut) {
                self.navVc?.view.frame.origin.x = 0
                self.profileVC?.view.isUserInteractionEnabled = true
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
}
