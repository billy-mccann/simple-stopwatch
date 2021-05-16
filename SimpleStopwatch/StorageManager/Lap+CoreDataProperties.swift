import Foundation
import CoreData


extension Lap {

    @nonobjc public class func lapFetchRequest() -> NSFetchRequest<Lap> {
        return NSFetchRequest<Lap>(entityName: "Lap")
    }

    @NSManaged public var lap_number: Int16
    @NSManaged public var lap_time: String?
    @NSManaged public var session_id: Int32
    @NSManaged public var id: Int32
    @NSManaged public var session: Session?

}

extension Lap : Identifiable {

}
