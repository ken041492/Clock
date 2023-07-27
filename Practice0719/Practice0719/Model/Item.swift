//
//  Item.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/7/19.
//

import Foundation
import Realm
import RealmSwift

class Clock: Object {
    @Persisted(primaryKey: true) var uuid: ObjectId
    @Persisted var DB_Period: String = ""
    @Persisted var DB_Hours: String = ""
    @Persisted var DB_Minutes: String = ""
    @Persisted var CurrentTime: String = ""
    @Persisted var WeekLabel: String = "鬧鐘"
    @Persisted var MentionLabel: String = ""
    
    override static func primaryKey() -> String?{
        return "uuid"
    }
    convenience init(DB_Period: String, DB_Hours: String, DB_Minutes: String, CurrentTime: String, WeekLabel: String, MentionLabel: String) {
       self.init()
       self.DB_Period = DB_Period
       self.DB_Hours = DB_Hours
       self.DB_Minutes = DB_Minutes
       self.CurrentTime = CurrentTime
       self.WeekLabel = WeekLabel
       self.MentionLabel = MentionLabel
   }
}

struct ClockStruct{
    var uuid: ObjectId
    var DB_Period: String = ""
    var DB_Hours: String = ""
    var DB_Minutes: String = ""
    var CurrentTime: String = ""
    var WeekLabel: String = "鬧鐘"
    var MentionLabel: String = ""
}

