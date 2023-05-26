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
        view.backgroundColor = AppColor().background
        title = "Settings"~
        darkModeSwitch.isOn = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        darkModeSwitch.addTarget(self, action: #selector(toggleTheme(_:)), for: .valueChanged)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
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
            cell.textLabel?.text = "Dark Mode"~
            cell.accessoryView = darkModeSwitch
        case 1:
            cell.textLabel?.text = "Language"~
        case 2:
            cell.textLabel?.text = "Log Out"~
            cell.textLabel?.textColor = .red
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        let alert = UIAlertController(title: "Are you sure?"~, message: "Leaving now means you have to log in again", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "I am sure"~, style: .destructive, handler: { [self]_ in
            coordinator?.event(action: .logOut, iniciator: self)
        })
        let cancelAction = UIAlertAction(title: "Cancel"~, style: .cancel, handler: {_ in
            alert.dismiss(animated: true)
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    private func setupLanguage() {
        
    }
    
    @objc func switchLanguage() {
        let alertController = UIAlertController(title: "Language"~, message: "Select language"~, preferredStyle: .actionSheet)
        
        // Add the English option
        let englishAction = UIAlertAction(title: "English", style: .default) { _ in
            // Save the user's preference
            UserDefaults.standard.set("en", forKey: "languageCode")
            
            // Update the language label
            self.updateLanguageLabel()
        }
        if UserDefaults.standard.string(forKey: "languageCode") == "en" {
            englishAction.setValue(true, forKey: "checked")
        }
        alertController.addAction(englishAction)
        
        // Add the Russian option
        let russianAction = UIAlertAction(title: "Russian"~, style: .default) { _ in
            // Save the user's preference
            UserDefaults.standard.set("ru", forKey: "languageCode")
            
            // Update the language label
            self.updateLanguageLabel()
        }
        if UserDefaults.standard.string(forKey: "languageCode") == "ru" {
            russianAction.setValue(true, forKey: "checked")
        }
        alertController.addAction(russianAction)
        
        // Add a cancel option
        let cancelAction = UIAlertAction(title: "Cancel"~, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Update the language label based on the user's preference
    private func updateLanguageLabel() {
        let languageCode = UserDefaults.standard.string(forKey: "languageCode")
        if languageCode == "en" {
            languageLabel.text = "English"~
        } else if languageCode == "ru" {
            languageLabel.text = "Russian"~
        } else {
            languageLabel.text = "Unknown"
        }
    }
    
    
    private func setupLogoutButton() {
        
    }
    
    @objc func toggleTheme(_ sender: UISwitch) {
        if sender.isOn {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
            UserDefaults.standard.set(true, forKey: "isDarkModeEnabled")
        } else {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
            UserDefaults.standard.set(false, forKey: "isDarkModeEnabled")
        }
    }
}
