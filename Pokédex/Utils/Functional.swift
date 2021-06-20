extension Swift.Optional {
    func fold<T>(some: (Wrapped) -> T, none: () -> T) -> T {
        guard let unwrapped = self else {
            return none()
        }
        return some(unwrapped)
    }
}

extension Swift.Optional where Wrapped == String {
    var notNil: String {
        guard let self = self else {
            return ""
        }
        return self
    }

    var nilIfEmpty: Wrapped? {
        flatMap { $0.nilIfEmpty }
    }
}

private extension String {
    var nilIfEmpty: String? {
        guard !isEmpty else {
            return nil
        }
        return self
    }
}
