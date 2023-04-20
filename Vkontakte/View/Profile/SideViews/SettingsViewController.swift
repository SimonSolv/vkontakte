//
//  SettingsViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 17.04.2023.
//

import UIKit

class SettingsViewController: UITableViewController, CoordinatedProtocol {
    var coordinator: CoordinatorProtocol?


    // MARK: - Properties

    private let cellReuseIdentifier = "cell"
    private let darkModeSwitch = UISwitch()
    private let languageLabel = UILabel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)

        setupDarkMode()
        setupLanguage()
        setupLogoutButton()
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Dark Mode"
            cell.accessoryView = darkModeSwitch
        case 1:
            cell.textLabel?.text = "Language"
            cell.accessoryView = languageLabel
        case 2:
            cell.textLabel?.text = "Log Out"
            cell.textLabel?.textColor = .red
        default:
            break
        }

        return cell
    }

    // MARK: - Table View Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            switchLanguage()
        case 2:
            showLogoutAlert()
        default:
            break
        }
    }

    // MARK: - Private Methods

    private func setupDarkMode() {

    }

    private func showLogoutAlert() {

    }

    private func setupLanguage() {

    }

    private func switchLanguage() {

    }

    private func setupLogoutButton() {

    }

}

//import UIKit
//
//class SettingsViewController: UITableViewController, CoordinatedProtocol {
//    var coordinator: CoordinatorProtocol?
//
//
//    // MARK: - Properties
//
//    private let settings = [("Dark Mode", "Toggle to enable dark mode"),
//                            ("Language", "Tap to switch between Russian and English"),
//                            ("Log out", "Tap to log out of the app")]
//
//    private let cellId = "cellId"
//
//    // MARK: - Lifecycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
//        tableView.tableFooterView = UIView()
//    }
//
//    // MARK: - UITableViewDataSource
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return settings.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
//        cell.textLabel?.text = settings[indexPath.row].0
//        cell.detailTextLabel?.text = settings[indexPath.row].1
//        cell.accessoryType = .disclosureIndicator
//        return cell
//    }
//
//    // MARK: - UITableViewDelegate
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            // toggle dark mode
//            break
//        case 1:
//            // switch language
//            break
//        case 2:
//            // log out
//            let alertController = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .alert)
//            let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
//                // perform log out
//            }
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            alertController.addAction(yesAction)
//            alertController.addAction(cancelAction)
//            present(alertController, animated: true, completion: nil)
//            break
//        default:
//            break
//        }
//    }
//}

       

