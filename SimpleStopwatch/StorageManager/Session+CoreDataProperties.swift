import Foundation
import CoreData


extension Session {

    @nonobjc public class func sessionFetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: Int32
    @NSManaged public var timestamp: Int32
    @NSManaged public var title: String?
    @NSManaged public var laps: NSSet?

}

// MARK: Generated accessors for laps
extension Session {

    @objc(addLapsObject:)
    @NSManaged public func addToLaps(_ value: Lap)

    @objc(removeLapsObject:)
    @NSManaged public func removeFromLaps(_ value: Lap)

    @objc(addLaps:)
    @NSManaged public func addToLaps(_ values: NSSet)

    @objc(removeLaps:)
    @NSManaged public func removeFromLaps(_ values: NSSet)

}

extension Session : Identifiable {

}
