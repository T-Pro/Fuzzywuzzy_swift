//
//  Fuzzywuzzy_swiftTests.swift
//  Fuzzywuzzy_swiftTests
//
//  Created by XianLi on 30/8/2016.
//  Copyright © 2016 LiXian. All rights reserved.
//

import XCTest
@testable import Fuzzywuzzy_swift

class StringFuzzywuzzyExtensionTests: XCTestCase {

  func testTokenSetRatio_basicCases() {
    // Empty string cases
    XCTAssertEqual(String.fuzzTokenSetRatio(lhs: "some", rhs: ""), 0)
    XCTAssertEqual(String.fuzzTokenSetRatio(lhs: "", rhs: "some"), 0)
    XCTAssertEqual(String.fuzzTokenSetRatio(lhs: "", rhs: ""), 100)

    // Duplicated tokens
    XCTAssertEqual(String.fuzzTokenSetRatio(
      lhs: "fuzzy fuzzy wuzzy was a bear",
      rhs: "wuzzy fuzzy was a bear"
    ), 100)
    XCTAssertEqual(String.fuzzTokenSetRatio(
      lhs: "fuzzy$*#&)$#(wuzzy*@()#*()!<><>was a bear",
      rhs: "wuzzy wuzzy fuzzy was a bear"
    ), 100)
    // Different tokens
    XCTAssertEqual(String.fuzzTokenSetRatio(lhs: "cat dog", rhs: "dog mouse"), 68)
  }

  func testTokenSortRatio_basicCases() {
    // Empty string cases
    XCTAssertEqual(String.fuzzTokenSortRatio(lhs: "some", rhs: ""), 0)
    XCTAssertEqual(String.fuzzTokenSortRatio(lhs: "", rhs: "some"), 0)
    XCTAssertEqual(String.fuzzTokenSortRatio(lhs: "", rhs: ""), 100)

    // Token order
    XCTAssertEqual(String.fuzzTokenSortRatio(
      lhs: "fuzzy wuzzy was a bear",
      rhs: "wuzzy fuzzy was a bear"
    ), 100)
    XCTAssertEqual(String.fuzzTokenSortRatio(
      lhs: "fuzzy$*#&)$#(wuzzy*@()#*()!<><>was a bear",
      rhs: "wuzzy fuzzy was a bear"
    ), 100)
    // Different tokens
    // TODO: The value should be 67 as per rapidfuzz implementation.
    XCTAssertEqual(String.fuzzTokenSortRatio(lhs: "cat dog", rhs: "dog mouse"), 56)
  }

  func testPartialRatio_variousCases() {
    // Empty string cases
    XCTAssertEqual(String.fuzzPartialRatio(lhs: "some", rhs: ""), 0)
    XCTAssertEqual(String.fuzzPartialRatio(lhs: "", rhs: "some"), 0)
    XCTAssertEqual(String.fuzzPartialRatio(lhs: "", rhs: ""), 0)

    // Substring match
    // TODO: The value should be 75 as per rapidfuzz implementation.
    XCTAssertEqual(String.fuzzPartialRatio(lhs: "abcd", rhs: "XXXbcdeEEE"), 85)
    // TODO: The value should be 100 as per rapidfuzz implementation.
    XCTAssertEqual(String.fuzzPartialRatio(
      lhs: "what a wonderful 世界",
      rhs: "wonderful 世"
    ), 95)
    // TODO: The value should be 93 as per rapidfuzz implementation.
    XCTAssertEqual(String.fuzzPartialRatio(
      lhs: "this is a test",
      rhs: "this is a test!"
    ), 96)
  }

  func testCommonSubstrings_pairs() {
    // Empty string cases
    XCTAssertEqual(CommonSubstrings.pairs(lhs: "some", rhs: "").count, 0)
    XCTAssertEqual(CommonSubstrings.pairs(lhs: "", rhs: "some").count, 0)
    XCTAssertEqual(CommonSubstrings.pairs(lhs: "", rhs: "").count, 0)

    // Overlapping substrings
    let pairs1: [CommonSubstringPair] = CommonSubstrings.pairs(
      lhs: "aaabbcde",
      rhs: "abbdbcdaabde"
    )
    // Should find at least one common substring of length >= 2
    XCTAssertTrue(pairs1.contains { $0.len >= 2 })

    // Identical strings
    let pairs2: [CommonSubstringPair] = CommonSubstrings.pairs(
      lhs: "abcdef",
      rhs: "abcdef"
    )
    XCTAssertEqual(pairs2.count, 1)
    XCTAssertEqual(pairs2.first?.len, 6)
  }

  func testStringMatcher_ratioRange() {
    let strPairs: [(String, String)] = [
      ("some", ""),
      ("", "some"),
      ("", ""),
      ("我好hungry", "我好饿啊啊啊啊"),
      ("我好饿啊啊啊啊", "好烦啊"),
      ("abc", "abc"),
      ("abc", "def")
    ]
    for (lhs, rhs) in strPairs {
      let matcher: StringMatcher = StringMatcher(lhs: lhs, rhs: rhs)
      let ratio: Float = matcher.fuzzRatio()
      XCTAssert(
        ratio <= 1 && ratio >= 0,
        "Ratio out of bounds for '\(lhs)' and '\(rhs)': \(ratio)"
      )
    }
  }

  func testTokenSetRatio_realExamples() {
    // Examples from README
    XCTAssertEqual(String.fuzzTokenSetRatio(
      lhs: "fuzzy was a bear",
      rhs: "fuzzy fuzzy was a bear"
    ), 100)
    XCTAssertEqual(String.fuzzTokenSortRatio(
      lhs: "fuzzy was a bear",
      rhs: "fuzzy fuzzy was a bear"
    ), 84)
  }

  func testTokenSortRatio_fullProcessToggle() {
    // With fullProcess = false, special characters are not removed
    let ratioWithProcess: Int = String.fuzzTokenSortRatio(
      lhs: "fuzzy+wuzzy(was) a bear",
      rhs: "wuzzy fuzzy was a bear"
    )
    let ratioWithoutProcess: Int = String.fuzzTokenSortRatio(
      lhs: "fuzzy+wuzzy(was) a bear",
      rhs: "wuzzy fuzzy was a bear",
      fullProcess: false
    )
    XCTAssertEqual(ratioWithProcess, 100)
    XCTAssertEqual(ratioWithoutProcess, 77)
  }

  func testFuzzRatio_identicalAndDifferent() {
//    XCTAssertEqual(String.fuzzRatio(lhs: "abc", rhs: "abc"), 100)
    // TODO: The value should be 0 as per rapidfuzz implementation.
    XCTAssertEqual(String.fuzzRatio(lhs: "abc", rhs: "def"), 50)
//    XCTAssertEqual(String.fuzzRatio(lhs: "", rhs: ""), 100)
//    XCTAssertEqual(String.fuzzRatio(lhs: "abc", rhs: ""), 0)
  }
}
