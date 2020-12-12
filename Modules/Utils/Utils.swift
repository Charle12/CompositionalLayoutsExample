//
//  Utils.swift
//  SBINri
//
//  Created by Admin on 12/12/20.
//

import Foundation

class Utils {
    static func loadJson(filename fileName: String) -> Entity? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Entity.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
