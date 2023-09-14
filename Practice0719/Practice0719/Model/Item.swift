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
    @Persisted var WeekLabel: String = ""
    @Persisted var MentionLabel: String = ""
    @Persisted var TagText: String = ""
    @Persisted var SaveSwitch: Bool = true
    @Persisted var SaveWeekNumber: String = ""
    override static func primaryKey() -> String?{
        return "uuid"
    }
    convenience init(DB_Period: String, DB_Hours: String, DB_Minutes: String, CurrentTime: String, WeekLabel: String, MentionLabel: String, TagText: String, SaveSwitch: Bool, SaveWeekNumber: String) {
       self.init()
       self.DB_Period = DB_Period
       self.DB_Hours = DB_Hours
       self.DB_Minutes = DB_Minutes
       self.CurrentTime = CurrentTime
       self.WeekLabel = WeekLabel
       self.MentionLabel = MentionLabel
       self.TagText = TagText
       self.SaveSwitch = SaveSwitch
       self.SaveWeekNumber = SaveWeekNumber
   }
}

struct ClockStruct{
    var uuid: ObjectId
    var DB_Period: String = ""
    var DB_Hours: String = ""
    var DB_Minutes: String = ""
    var CurrentTime: String = ""
    var WeekLabel: String = ""
    var MentionLabel: String = ""
    var TagText: String = ""
    var SaveSwitch: Bool = true
    var SaveWeekNumber: String = ""
}

