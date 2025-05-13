//
//  StringProcessor.swift
//  Fuzzywuzzy_swift
//
//  Created by XianLi on 31/8/2016.
//  Copyright © 2016 LiXian. All rights reserved.
//

import Foundation

class StringProcessor: NSObject {
  /// Process string by
  /// removing all but letters and numbers
  /// trim whitespace
  /// force to lower case
  class func process(str: String) -> String {
    let lowercased = str.lowercased()
    let replaced: String
    if #available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, visionOS 1.0, *) {
      let regex = try! Regex("\\W+")
      replaced = lowercased.replacing(regex, with: " ")
    } else {
      let regex = try! NSRegularExpression(pattern: "\\W+", options: .caseInsensitive)
      let range = NSRange(location: 0, length: lowercased.utf16.count)
      replaced = regex.stringByReplacingMatches(in: lowercased, options: [], range: range, withTemplate: " ")
    }
    return replaced.trimmingCharacters(
      in: NSCharacterSet.init(charactersIn: " ") as CharacterSet
    )
  }
}

