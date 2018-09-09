//
//  Seeder.swift
//  Active
//
//  Created by Tiago Maia Lopes on 02/07/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import Foundation
import CoreData

/// Class in charge of seeding entities into sqlite every time the app runs.
class Seeder {

    // MARK: Types

    typealias SeedProcedure = (NSManagedObjectContext) -> Void

    // MARK: Properties

    /// The container in which the entities are going to be seeded.
    private let container: NSPersistentContainer

    /// The basic seeds to be applied in any kind of environment and situation.
    /// - Note: An User entity is always needed, so the base Seeder class always seeds it.
    private let baseProcedures: [SeedProcedure] = [ {
        context in
        print("Seeding user.")

        // Try to fetch any users in the database.
        let request: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        let results = try? context.fetch(request)

        // If there's already a saved UserMO,
        // don't proceed with the user seed.
        if let results = results, !results.isEmpty {
            return
        }

        // Instantiate a new user factory using the context.
        let userFactory = UserFactory(context: context)

        // Make a new dummy.
        _ = userFactory.makeDummy()
    }]

    /// An array of blocks containing the seeding code in the correct order.
    /// - Note: Every time a new entity needs to be seeded, add a new block
    ///         containing the code in charge of the seed. This array will
    ///         be iterated and the blocks run with a given managed context.
    var seedProcedures: [SeedProcedure] {
        return []
    }

    // MARK: Initializers

    /// - Parameter container: The container used when seeding the entities.
    init(container: NSPersistentContainer) {
        self.container = container
    }

    // MARK: Imperatives

    /// Seeds the sqlite database using the provided container and running the
    /// each code in the array of seed procedures defined internally.
    final func seed() {
        // Get a background context.
        container.performBackgroundTask { context in
            print("===========================================================")

            // Iterate over each seed procedure and call each one passing the context.
            // Seed the base precedures (to be always applied).
            let procedures = self.baseProcedures + self.seedProcedures

            for procedure in procedures {
                procedure(context)
            }

            do {
                try context.save()
            } catch {
                print("\nOops =(")
                print("There was an error when trying to save the seed context:")
                print(error.localizedDescription)
            }

            self.printEntitiesCount()

            print("===========================================================")
        }
    }

    /// Removes all previously seeded entities from the persistent stores.
    func erase() {
        print("Removing seeded entities.")

        // Declare the context to be used for the seed erase.
        let context = container.viewContext

        // Delete all DayMO entities.
        let daysRequest: NSFetchRequest<DayMO> = DayMO.fetchRequest()

        if let days = try? context.fetch(daysRequest) {
            for day in days {
                context.delete(day)
            }
        }

        // Get a new user storage instance.
        let userStorage = UserStorage()

        // Get the current user.
        if let user = userStorage.getUser(using: context) {
            // Delete it.
            context.delete(user)
        }

        // Save the context.
        do {
            try context.save()
        } catch {
            assertionFailure("Error when erasing the seed.")
        }
    }

    /// Prints the number of entities within the database after the seed.
    /// - Note: Every time a new entity class is added and seeded, this code
    ///         will need to be modified to print the new entity's count.
    func printEntitiesCount() {
        // Declare a dictionary containing the entities and fetch requests
        // for each one of them.
        let entities = [
            "User": UserMO.fetchRequest(),
            "Habit": HabitMO.fetchRequest(),
            "HabitDay": HabitDayMO.fetchRequest(),
            "Notification": NotificationMO.fetchRequest(),
            "Day": DayMO.fetchRequest()
        ]

        // Iterate through the dictionary and print the count of each entity.
        print("\nSeed results:")
        for (entity, fetchRequest) in entities {
            let count = (try? container.viewContext.count(for: fetchRequest)) ?? 0
            print("The number of \(entity) entities in the database is: \(count)")
        }
    }
}
