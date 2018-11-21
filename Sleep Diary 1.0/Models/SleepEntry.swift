//
//  SleepEntry.swift
//  Sleep Diary 1.0
//
//  Created by VIS Swimming on 25/5/18.
//  Copyright © 2018 TOR. All rights reserved.
//

import Foundation
import UIKit

struct SleepEntry: Codable {
    var date: Date?
    var dateLabel: String
    var location: String
    var caffiene: String?
    var timeCaffieneIntake: String?
    var caffienePicker: Date
    var caffieneAmount: String?
    var phoneUse: String?
    var phoneUseTime: String?
    var arousal: String
    var bedtime: Date
    var bedtimeLabel: String
    var wakeupTime: Date
    var wakeupLabel: String
    var totalSleepTime: String
    var sleepQuality: String
    var alertness: String
    var additionalComments: String?

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()

static func saveToFile(sleepEntry: [SleepEntry]) {
    let encoder = PropertyListEncoder()
    let encodedSleepEntry = try? encoder.encode(sleepEntry)
    try? encodedSleepEntry?.write(to: archiveURL, options: .noFileProtection)
}

static func loadList() -> [SleepEntry]? {
    let decoder = PropertyListDecoder()
    if
        let data = try? Data(contentsOf: archiveURL),
        let decodedSleepEntry = try? decoder.decode(Array<SleepEntry>.self, from: data)
    {
        return decodedSleepEntry
    } else {
        return nil
    }
}

static var archiveURL: URL {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let archiveURL = documentsDirectory
        .appendingPathComponent("SleepEntries")
        .appendingPathExtension("plist")
    return archiveURL
    }
    
}


