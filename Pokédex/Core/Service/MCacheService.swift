import Foundation

protocol MCacheable {
    func set(obj: Any, for key: String)
    func object(for key: String) -> AnyObject?
}

struct MCacheableItem {
    let time: Date
    let value: Any
    
    init(value: Any) {
        self.value = value
        self.time = Date()
    }
}

class MCacheService: NSCache<AnyObject, AnyObject>, MCacheable {
    private let expiration: TimeInterval

    init(expiration: Int = MConstants.Cache.expiration) {
        self.expiration = TimeInterval(expiration)
    }
    
    func set(obj: Any, for key: String) {
        let item = MCacheableItem(value: obj)
        self.setObject(item as AnyObject, forKey: key as AnyObject)
    }
    
    func object(for key: String) -> AnyObject? {
        guard let item = self.object(forKey: key as AnyObject) as? MCacheableItem else {
            return nil
        }
        
        guard item.time.isValid(expiration) else {
            self.removeObject(forKey: key as AnyObject)
            return nil
        }
        
        return item.value as AnyObject
    }
}

class DefaultCache: NSCache<AnyObject, AnyObject>, MCacheable {
    func set(obj: Any, for key: String) {}
    func object(for key: String) -> AnyObject? { return nil }
}

extension Date {
    func isValid(_ time: TimeInterval) -> Bool {
        return self.addingTimeInterval(time) > Date()
    }
}
