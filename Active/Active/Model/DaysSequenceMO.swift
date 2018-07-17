//
//  DaysSequenceMO.swift
//  Active
//
//  Created by Tiago Maia Lopes on 16/07/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import CoreData

/// A sequence of n days a User has setup for an specific Habit entity to be
/// tracked and executed on.
class DaysSequenceMO: NSManagedObject {
    
    // MARK: Imperatives
    
    /// Returns the executed days from the sequence.
    func getExecutedDays() -> Set<HabitDayMO>? {
        let executedPredicate = NSPredicate(format: "wasExecuted = true")
        return days?.filtered(using: executedPredicate) as? Set<HabitDayMO>
    }
    
    /// Returns the missed days from the sequence.
    func getMissedDays() -> Set<HabitDayMO>? {
        let executedPredicate = NSPredicate(format: "wasExecuted = false")
        return days?.filtered(using: executedPredicate) as? Set<HabitDayMO>
    }
}
