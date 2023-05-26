//
//  LocalizationShortCutString.swift
//  Vkontakte
//
//  Created by Simon Pegg on 21.04.2023.
//

import Foundation

postfix operator ~

postfix func ~ (string: String) -> String {
    return NSLocalizedString(string, comment: "")
}
