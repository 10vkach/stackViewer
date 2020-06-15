
import Foundation

extension Double {
    func smartModified() -> String {
        
        let ago = "ago"
        let calendar = Calendar(identifier: .gregorian)
        let askedtime = Date(timeIntervalSince1970: self)
        let components = calendar.dateComponents([.day, .hour, .minute, .second],
                                                 from: askedtime,
                                                 to: Date())
        
        if let day = components.day {
            if day == 1 {
                return "\(day) day \(ago)"
            } else if day > 1 {
                return "\(day) days \(ago)"
            }
        }
        if let hour = components.hour {
            if hour == 1 {
                return "\(hour) hour \(ago)"
            } else if hour > 1 {
                return "\(hour) hours \(ago)"
            }
        }
        if let minute = components.minute {
            if minute == 1 {
                return "\(minute) minute \(ago)"
            } else if minute > 1 {
                return "\(minute) minutes \(ago)"
            }
        }
        if let second = components.second {
            if second == 1 {
                return "\(second) second \(ago)"
            } else if second > 1 {
                return "\(second) seconds \(ago)"
            }
        }
        return ""
    }
}
