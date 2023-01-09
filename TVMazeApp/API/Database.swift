//
//  Database.swift
//  TVMazeApp
//
//  Created by Davi Pereira on 09/01/23.
//

import RealmSwift

class Database {
    static func saveShows(_ shows: [Show]) throws {
        let realm = try Realm()
        try realm.write {
            realm.add(shows)
        }
    }
}
