//
//  StringProcessorTest.swift
//  Fuzzywuzzy_swift
//
//  Created by Pedro Paulo de Amorim on 14/05/2025.
//

import XCTest
@testable import Fuzzywuzzy_swift

class StringProcessorTest: XCTestCase {

  func testProcess_emptyString() {
    XCTAssertEqual(StringProcessor.process(value: ""), "")
  }

  func testProcess_lowercaseConversion() {
    XCTAssertEqual(StringProcessor.process(value: "Hello World"), "hello world")
  }

  func testProcess_whitespaceTrimming() {
    XCTAssertEqual(StringProcessor.process(value: "  Hello   World  "), "hello world")
  }

  func testProcess_specialCharactersRemoval() {
    XCTAssertEqual(StringProcessor.process(value: "Hello, World!"), "hello world")
  }

  func testProcess_mixedContent() {
    XCTAssertEqual(StringProcessor.process(value: "  Hello, 123 World!  "), "hello 123 world")
  }
}
