//
//  Extension.swift
//  CurrencyConverterAPI
//
//  Created by yunus emre vural on 16.10.2022.
//

import Foundation

extension String {
    var isDigits: Bool {
        if isEmpty { return false }
        // The inverted set of .decimalDigits is every character minus digits
        let nonDigits = CharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: nonDigits) == nil
    }
}
