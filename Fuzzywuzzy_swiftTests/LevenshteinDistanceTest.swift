//
//  LevenshteinDistanceTest.swift
//  Fuzzywuzzy_swift
//
//  Created by Pedro Paulo de Amorim on 13/05/2025.
//

import XCTest
@testable import Fuzzywuzzy_swift

class LevenshteinDistanceTest: XCTestCase {

  func testLevenshteinDistance_basicCases() {
    // Identical strings
    XCTAssertEqual(LevenshteinDistance.distance(str1: "some", str2: "some"), 0)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "", str2: ""), 0)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "a", str2: "a"), 0)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "abc", str2: "abc"), 0)
  }

  func testLevenshteinDistance_emptyStrings() {
    // One empty, one non-empty
    XCTAssertEqual(LevenshteinDistance.distance(str1: "", str2: "some"), 4)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "some", str2: ""), 4)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "", str2: "a"), 1)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "a", str2: ""), 1)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "", str2: ""), 0)
  }

  func testLevenshteinDistance_insertionsDeletions() {
    // Insertions
    XCTAssertEqual(LevenshteinDistance.distance(str1: "abc", str2: "ab"), 1)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "ab", str2: "abc"), 1)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "a", str2: "abc"), 2)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "abc", str2: "a"), 2)
    // Deletions
    XCTAssertEqual(LevenshteinDistance.distance(str1: "kitten", str2: "kitt"), 2)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "kitt", str2: "kitten"), 2)
  }

  func testLevenshteinDistance_substitutions() {
    // Substitutions
    XCTAssertEqual(LevenshteinDistance.distance(str1: "kitten", str2: "sitten"), 1)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "kitten", str2: "sittin"), 2)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "flaw", str2: "lawn"), 2)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "gumbo", str2: "gambol"), 2)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "book", str2: "back"), 2)
  }

  func testLevenshteinDistance_mixedOperations() {
    // Mix of insertions, deletions, substitutions
    XCTAssertEqual(LevenshteinDistance.distance(str1: "intention", str2: "execution"), 5)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "abcdef", str2: "azced"), 3)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "Saturday", str2: "Sunday"), 3)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "distance", str2: "editing"), 5)
  }

  func testLevenshteinDistance_unicode() {
    // Unicode and emoji
    XCTAssertEqual(LevenshteinDistance.distance(str1: "我something", str2: "someth"), 4)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "我好饿啊啊啊啊", str2: "好烦啊"), 5)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "🐱", str2: "🐶"), 1)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "🐱🐶", str2: "🐱"), 1)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "🐱🐶", str2: "🐶🐱"), 2)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "你好", str2: "您好"), 1)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "你好世界", str2: "世界你好"), 4)
  }

  func testLevenshteinDistance_longStrings() {
    let str1 = String(repeating: "a", count: 100)
    let str2 = String(repeating: "a", count: 100)
    XCTAssertEqual(LevenshteinDistance.distance(str1: str1, str2: str2), 0)

    let str3 = String(repeating: "a", count: 100)
    let str4 = String(repeating: "b", count: 100)
    XCTAssertEqual(LevenshteinDistance.distance(str1: str3, str2: str4), 100)

    let str5 = String(repeating: "a", count: 50) + String(repeating: "b", count: 50)
    let str6 = String(repeating: "a", count: 100)
    XCTAssertEqual(LevenshteinDistance.distance(str1: str5, str2: str6), 50)
  }

  func testLevenshteinDistance_edgeCases() {
    // Single character
    XCTAssertEqual(LevenshteinDistance.distance(str1: "a", str2: "b"), 1)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "a", str2: ""), 1)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "", str2: "a"), 1)

    // Completely different
    XCTAssertEqual(LevenshteinDistance.distance(str1: "abc", str2: "xyz"), 3)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "123", str2: "abc"), 3)

    // Case sensitivity
    XCTAssertEqual(LevenshteinDistance.distance(str1: "abc", str2: "ABC"), 3)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "Abc", str2: "abc"), 1)
  }

  func testLevenshteinDistance_originalCases() {
    // Original test cases from previous version
    XCTAssertEqual(LevenshteinDistance.distance(str1: "something", str2: "some"), 5)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "something", str2: "omethi"), 3)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "something", str2: "same"), 6)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "something", str2: "samewrongthong"), 7)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "something", str2: ""), 9)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "", str2: "some"), 4)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "some", str2: "some"), 0)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "", str2: ""), 0)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "我something", str2: "someth"), 4)
    XCTAssertEqual(LevenshteinDistance.distance(str1: "我好饿啊啊啊啊", str2: "好烦啊"), 5)
  }
}
