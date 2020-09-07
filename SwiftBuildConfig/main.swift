//
//  main.swift
//  SwiftBuildConfig
//
//  Created by Langle on 5/16/20.
//  Copyright © 2020 thang-nm. All rights reserved.
//

import Foundation

let prefix = "APP_"
let processInfo = ProcessInfo()

guard
  let outputFile = processInfo.environment.first(where: { $0.key == "SCRIPT_OUTPUT_FILE_0" })?.value,
  let outputUrl = URL(string: "file://" + outputFile)
else {
  print("error: Please add valid configuration output file path")
  exit(1)
}

func camelCase(_ string: String) -> String {
  return string
    .split(separator: "_")
    .map { String($0) }
    .enumerated()
    .map { $0.offset > 0 ? $0.element.capitalized : $0.element.lowercased() }
    .joined()
}

func escape(_ string: String) -> String {
  return string
    .replacingOccurrences(of: "\\", with: "\\\\")
    .replacingOccurrences(of: "\"", with: "\\\"")
}

let className = outputUrl.deletingPathExtension().lastPathComponent
let letExpression = "  static let %@ = "
let template = """
// Auto-generated file. DON'T modify!
// swiftlint:disable all

import Foundation

struct \(className) {
  private init() {}
%@
}
"""
var lines: [String] = []
let variables = processInfo.environment.filter {
  $0.key.starts(with: prefix)
}

variables.forEach {
  let name = String($0.key.dropFirst(prefix.count))
  let value = $0.value
  let swiftPrefix = "swift:"
  var exp = letExpression

  if value.hasPrefix(swiftPrefix) {
    let startIndex = value.index(value.startIndex, offsetBy: swiftPrefix.count)
    let code = value.suffix(from: startIndex).trimmingCharacters(in: .whitespaces)
    if code.contains("{") && code.hasSuffix  ("}") {
      exp = "  static var %@: " + code
    } else {
      exp = "  static let %@: " + code
    }

  } else if let intValue = Int(value) {
    exp += String(intValue)

  } else if let doubleValue = Double(value) {
    exp += String(doubleValue)

  } else if let boolValue = Bool(value) {
    exp += String(boolValue)

  } else {
    let replacement = value.replacingOccurrences(of: "\\/", with: "/")
    exp += "\"" + escape(replacement) + "\""
  }

  lines.append(String(format: exp, camelCase(name)))
}

do {
  let content = String(format: template, lines.joined(separator: "\n"))
  try content.data(using: .utf8)?.write(to: outputUrl)
} catch {
  print("error: ", error.localizedDescription)
  exit(1)
}
