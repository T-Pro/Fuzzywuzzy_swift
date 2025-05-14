//
//  String_Fuzzywuzzy.swift
//  Fuzzywuzzy_swift
//
//  Created by XianLi on 30/8/2016.
//  Copyright © 2016 LiXian. All rights reserved.
//

import Foundation

public extension String {

  /// Basic Scoring Functions
  static func fuzzRatio(lhs: String, rhs: String) -> Int {
    let matcher: StringMatcher = StringMatcher(lhs: lhs, rhs: rhs)
    return Int(matcher.fuzzRatio() * 100)
  }

  /// trys to match the shorter string with the most common substring of the longer one
  static func fuzzPartialRatio(lhs: String, rhs: String) -> Int {
    let shorter: String
    let longer: String
    if lhs.count < rhs.count {
      shorter = lhs
      longer = rhs
    } else {
      shorter = rhs
      longer = lhs
    }

    let matcher: StringMatcher = StringMatcher(lhs: shorter, rhs: longer)
    let commonSubstringPairs: [CommonSubstringPair] = matcher.commonSubStringPairs

    let scores: [Float] = commonSubstringPairs.map { (pair) -> Float in
      /// filter out pairs that are too short ( < 20% of the lenght of the shoter string )
      if pair.len * 5 < shorter.count {
        return 0
      }
      let sub2RemLen: Int = longer.distance(from: pair.rhsSubRange.lowerBound, to: longer.endIndex)
      var longSubStart: String.Index = pair.rhsSubRange.lowerBound
      if sub2RemLen < shorter.count {
        longSubStart = longer.index(longSubStart, offsetBy: sub2RemLen - shorter.count)
      }
      let longSubEnd: String.Index = longer.index(longSubStart, offsetBy: shorter.count - 1)
      let closedRange: Range<String.Index> = longSubStart..<longSubEnd
      let longSubStr: String = String(longer[closedRange])
      let ratio: Float = StringMatcher(lhs: shorter, rhs: longSubStr).fuzzRatio()
      if ratio > 0.995 { /// magic number appears in original python code
        return 1
      }
      return ratio
    }
    return Int((scores.max() ?? 0) * 100)
  }

  static private func fuzzProcessAndSort(value: String, fullProcess: Bool = true) -> String {
    let value: String = fullProcess ? StringProcessor.process(value: value) : value
    return Array(value.components(separatedBy: " "))
      .sorted()
      .joined(separator: " ")
      .trimmingCharacters(in: CharacterSet(charactersIn: " "))
  }

  static private func fuzzTokenSort(lhs: String, rhs: String, partial: Bool = true, fullProcess: Bool = true) -> Int {
    let sortedLhs: String = fuzzProcessAndSort(value: lhs, fullProcess: fullProcess)
    let sortedRhs: String = fuzzProcessAndSort(value: rhs, fullProcess: fullProcess)
    return partial
      ? fuzzPartialRatio(lhs: sortedLhs, rhs: sortedRhs)
      : fuzzRatio(lhs: sortedLhs, rhs: sortedRhs)
  }

  static func fuzzTokenSortRatio(lhs: String, rhs: String, fullProcess: Bool = true) -> Int {
    fuzzTokenSort(lhs: lhs, rhs: rhs, partial: false, fullProcess: fullProcess)
  }

  static func fuzzPartialTokenSortRatio(lhs: String, rhs: String, fullProcess: Bool = true) -> Int {
    fuzzTokenSort(lhs: lhs, rhs: rhs, partial: true, fullProcess: fullProcess)
  }

  private static func tokenSetFrom(_ value: String) -> Set<String> {
    Set(value.components(separatedBy: " "))
  }

  private static func sortedJoined(_ tokens: Set<String>) -> String {
    tokens.sorted().joined(separator: " ")
  }

  private static func combineAndTrim(_ lhs: String, _ rhs: String) -> String {
    (lhs + " " + rhs).trimmingCharacters(in: .whitespaces)
  }

  static private func tokenSet(lhs: String, rhs: String, partial: Bool = true, fullProcess: Bool = true) -> Int {
    let processedLhs: String = fullProcess ? StringProcessor.process(value: lhs) : lhs
    let processedRhs: String = fullProcess ? StringProcessor.process(value: rhs) : rhs

    if processedLhs.isEmpty && processedRhs.isEmpty {
      return 100
    }
    if processedLhs.isEmpty || processedRhs.isEmpty {
      return 0
    }

    let tokensLhs: Set<String> = tokenSetFrom(processedLhs)
    let tokensRhs: Set<String> = tokenSetFrom(processedRhs)

    let intersection: Set<String> = tokensLhs.intersection(tokensRhs)
    let diffLhs: Set<String> = tokensLhs.subtracting(intersection)
    let diffRhs: Set<String> = tokensRhs.subtracting(intersection)

    let sortedSect: String = sortedJoined(intersection)
    let sortedLhsToRhs: String = sortedJoined(diffLhs)
    let sortedRhsToLhs: String = sortedJoined(diffRhs)

    let combinedLhsToRhs: String = combineAndTrim(sortedSect, sortedLhsToRhs)
    let combinedRhsToLhs: String = combineAndTrim(sortedSect, sortedRhsToLhs)

    let pairwise: [(String, String)] = [
      (sortedSect, combinedLhsToRhs),
      (sortedSect, combinedRhsToLhs),
      (combinedLhsToRhs, combinedRhsToLhs)
    ]
    let ratios: [Int] = pairwise.map { (lhs, rhs) -> Int in
      partial
        ? String.fuzzPartialRatio(lhs: lhs, rhs: rhs)
        : String.fuzzRatio(lhs: lhs, rhs: rhs)
    }

    return ratios.max() ?? 0
  }

  static func fuzzTokenSetRatio(
    lhs: String,
    rhs: String,
    fullProcess: Bool = true
  ) -> Int {
    tokenSet(
      lhs: lhs,
      rhs: rhs,
      partial: false,
      fullProcess: fullProcess
    )
  }

  static func fuzzPartialTokenSetRatio(
    lhs: String,
    rhs: String,
    fullProcess: Bool = true
  ) -> Int {
    tokenSet(
      lhs: lhs,
      rhs: rhs,
      partial: true,
      fullProcess: fullProcess
    )
  }
}
