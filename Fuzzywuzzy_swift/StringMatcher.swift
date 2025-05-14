//
//  StringMatcher.swift
//  Fuzzywuzzy_swift
//
//  Created by XianLi on 30/8/2016.
//  Copyright © 2016 LiXian. All rights reserved.
//

import Foundation

class StringMatcher: NSObject {
  let lhs: String
  let rhs: String

  lazy var levenshteinDistance: Int = LevenshteinDistance.distance(lhs: self.lhs, rhs: self.rhs)
  lazy var commonSubStringPairs: [CommonSubstringPair] = CommonSubstrings.pairs(lhs: self.lhs, rhs: self.rhs)

  init(lhs: String, rhs: String) {
    self.lhs = lhs
    self.rhs = rhs
    super.init()
  }

  func fuzzRatio() -> Float {
    let lenSum: Int = lhs.count + rhs.count
    if lenSum == 0 {
      return 1
    }
    if lhs.count == rhs.count && levenshteinDistance == lhs.count {
      return 0
    }
    return Float(lenSum - levenshteinDistance) / Float(lenSum)
  }

}
