//
//  StringProcessor.swift
//  Fuzzywuzzy_swift
//
//  Created by XianLi on 31/8/2016.
//  Copyright © 2016 LiXian. All rights reserved.
//

import Foundation

class StringProcessor: NSObject {

  // swiftlint:disable force_try
  @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, visionOS 1.0, *)
  private static let cachedRegex: Regex = {
    try! Regex("\\W+").ignoresCase()
  }()

  private static let cachedNSRegularExpression: NSRegularExpression = {
    try! NSRegularExpression(pattern: "\\W+", options: .caseInsensitive)
  }()
  // swiftlint:enable force_try

  /// Process string by
  /// removing all but letters and numbers
  /// trim whitespace
  /// force to lower case
  class func process(value: String) -> String {
    if value.isEmpty {
        return value
    }
    let lowercased: String = value.lowercased()
    let replaced: String
    if #available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, visionOS 1.0, *) {
      replaced = lowercased.replacing(cachedRegex, with: " ")
    } else {
      replaced = cachedNSRegularExpression.stringByReplacingMatches(
        in: lowercased,
        options: [],
        range: NSRange(location: 0, length: lowercased.utf16.count),
        withTemplate: " "
      )
    }
    return replaced.trimmingCharacters(in: CharacterSet(charactersIn: " "))
  }
}
