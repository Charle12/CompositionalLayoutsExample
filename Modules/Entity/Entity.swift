//
//  Entity.swift
//  SBINri
//
//  Created by Admin on 13/10/20.
//

import Foundation
import UIKit

struct Entity: Codable {
    let message: String?
    let page: [Page]?

    enum CodingKeys: String, CodingKey {
        case message       = "message"
        case page          = "page"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decode(String.self, forKey: .message)
        self.page = try container.decode([Page].self, forKey: .page)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.message, forKey: .message)
        try container.encode(self.page, forKey: .page)
    }
}


struct Page: Codable {
  let title: String?
  let viewType: String?
  let value: [Value]?

  enum CodingKeys: String, CodingKey {
      case title            = "title"
      case viewType         = "viewType"
      case value            = "value"
  }

  init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.title = try container.decode(String.self, forKey: .title)
      self.viewType = try container.decode(String.self, forKey: .viewType)
      self.value = try container.decode([Value].self, forKey: .value)
  }

  func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(self.title, forKey: .title)
      try container.encode(self.viewType, forKey: .viewType)
      try container.encode(self.value, forKey: .value)
  }
}

class Value: Codable {
    let title: String?
    let value: String?
}

struct Element: Hashable {
    let name: String
    let imageName: String
    let value: String?
    
    init(name: String, imageName: String, value: String) {
        self.name = name
        self.imageName = imageName
        self.value = value
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }

    static func == (lhs: Element, rhs: Element) -> Bool {
      return lhs.identifier == rhs.identifier
    }

    private let identifier = UUID()
}
