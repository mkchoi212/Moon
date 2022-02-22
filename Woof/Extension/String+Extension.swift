//
//  String+Extension.swift
//  Woof
//
//  Created by Mike Choi on 12/15/21.
//

import Foundation

extension String {
    var capitalizeFirstLetter: String {
        prefix(1).capitalized + dropFirst()
    }
}

extension String: Error { }
