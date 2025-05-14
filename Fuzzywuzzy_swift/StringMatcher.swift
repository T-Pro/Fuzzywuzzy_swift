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

  lazy var levenshteinDistance: Int = Levenshtein.distance(
    lhs: self.lhs,
    rhs: self.rhs
  )
  lazy var commonSubStringPairs: [CommonSubstringPair] = CommonSubstrings.pairs(
    lhs: self.lhs,
    rhs: self.rhs
  )

  init(lhs: String, rhs: String) {
    self.lhs = lhs
    self.rhs = rhs
    super.init()
  }

  func fuzzRatio() -> Float {
    let lenSum: Int = self.lhs.count + self.rhs.count
    if lenSum == 0 {
      return 1.0
    }
    var levenshteinDistance: Float
    if self.lhs.isEmpty {
      levenshteinDistance = Float(self.rhs.count)
    } else if self.rhs.isEmpty {
      levenshteinDistance = Float(self.lhs.count)
    } else {
      levenshteinDistance = Float(self.levenshteinDistance)
    }
    return (Float(lenSum) - levenshteinDistance) / Float(lenSum)
  }

}
