//
//  FireTimeFactory.swift
//  Active
//
//  Created by Tiago Maia Lopes on 22/07/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import CoreData

/// Factory in charge of generating HabitDayMO dummies.
struct FireTimeFactory: DummyFactory {

    // MARK: Types

    // This factory generates entities of the FireTimeMO class.
    typealias Entity = FireTimeMO

    // MARK: Properties

    var context: NSManagedObjectContext

    // MARK: Imperatives

    /// Generates a new empty FireTimeMO entity.
    /// - Returns: the generated FireTime.
    func makeDummy() -> FireTimeMO {
        let fireTime = FireTimeMO(context: context)
        fireTime.id = UUID().uuidString
        fireTime.createdAt = Date()
        fireTime.hour = Int16(Int.random(0..<24))
        fireTime.minute = Int16(Int.random(0..<59))

        return fireTime
    }
}
