//
//  SUDateExtension.swift
//  SwiftUtils
//
//  Created by alvaro.grimal.local on 14/09/2020.
//  Copyright © 2020 Babel. All rights reserved.
//

import Foundation

extension DateFormatter {

    public convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
        self.locale = Locale.autoupdatingCurrent
        self.timeZone = TimeZone.autoupdatingCurrent
    }
}

extension Date {
    public enum BSWeekDay: Int {
        case monday = 0
        case tuesday = 1
        case wednesday = 2
        case thurday = 3
        case friday = 4
        case saturday = 5
        case sunday = 6
    }

    public struct Formatter {

        // Full formats
        public static let timeDateFormat = "HH:mm dd/MM/yyyy"
        public static let dateTimeFormat = "dd/MM/yyyy HH:mm"

        // Date formats
        public static let shortFormat = "dd/MM/yyyy"
        public static let shortSpaceFormat = "dd MM yyyy"
        public static let mediumFormat = "dd MMMM yyyy"
        public static let largeFormat = "EEEE dd, MMMM yyyy"
        public static let mediumDateTimeFormat = "dd MMMM yyyy HH:mm"

        // Time formats
        public static let timeShort = "HH:mm"
        public static let timeLong = "HH:mm:ss"

        // Day formats
        public static let dayName = "EEEEE"
        public static let dayNamePartially = "EEE"
        public static let dayNumber = "dd"

        // Months formats
        public static let monthShort = "MMM"
        public static let monthLong = "MMMM"

        // Day/Month format
        public static let dayMonthTimeFormat = "dd MMM HH:mm"

        // Months/Year formats
        public static let monthYearShort = "MM/yy"
        public static let monthYearLong = "MMMM yyyy"

        // Services formats
        public static let serviceShort = "yyyyMMdd"
        public static let serviceISO = "yyyy-MM-dd"
        public static let serviceTimeZone = "HH:mm:ssZZZZ"
        public static let serviceISOTimeZone = "yyyy-MM-dd'T'HH:mm:ssZ"
        public static let serviceISOTime = "yyyy-MM-dd'T'HH:mm:ss"
        public static let serviceISOtimeShort = "yyyy-MM-dd'T'HH:mm"
        public static let serviceReverseDateTime = "dd-MM-yyyy'T'HH:mm:ss"
        public static let serviceDateAndTime = "yyyy-MM-ddHH:mm"
    }

    // MARK: - Public vars

    /// String formatted *HH:mm dd/MM/yyyy*
    public var timeDateFormat: String {
        return Formatter.timeDateFormat.dateFormatter.string(from: self)
    }

    /// String formatted *dd/MM/yyyy HH:mm*
    public var dateTimeFormat: String {
        return Formatter.dateTimeFormat.dateFormatter.string(from: self)
    }

    /// String formatted *dd/MM/yyyy*
    public var shortFormat: String {
        return Formatter.shortFormat.dateFormatter.string(from: self)
    }

    /// String formatted *dd MMMM yyyy*
    public var mediumFormat: String {
        return Formatter.mediumFormat.dateFormatter.string(from: self)
    }

    /// String formatted *EEEE dd, MMMM yyyy*
    public var largeFormat: String {
        return Formatter.largeFormat.dateFormatter.string(from: self)
    }

    /// String formatted *dd MMMM yyyy HH:mm*
    public var mediumDateTimeFormat: String {
        return Formatter.mediumDateTimeFormat.dateFormatter.string(from: self)
    }

    /// String formatted *HH:mm*
    public var timeShort: String {
        return Formatter.timeShort.dateFormatter.string(from: self)
    }

    /// String formatted *HH:mm:ss*
    public var timeLong: String {
        return Formatter.timeLong.dateFormatter.string(from: self)
    }

    /// String formatted *EEEEE*
    public var dayName: String {
        return Formatter.dayName.dateFormatter.string(from: self)
    }

    /// String formatted *EEE*
    public var dayNamePartially: String {
        return Formatter.dayNamePartially.dateFormatter.string(from: self)
    }

    /// String formatted *dd*
    public var dayNumber: String {
        return Formatter.dayNumber.dateFormatter.string(from: self)
    }

    /// String formatted *MMM*
    public var monthShort: String {
        return Formatter.monthShort.dateFormatter.string(from: self)
    }

    /// String formatted *MMMM*
    public var monthLong: String {
        return Formatter.monthLong.dateFormatter.string(from: self)
    }

    /// String formatted *dd MMM HH:mm*
    public var dayMonthTimeFormat: String {
        return Formatter.dayMonthTimeFormat.dateFormatter.string(from: self)
    }

    /// String formatted *MM/yy*
    public var monthYearShort: String {
        return Formatter.monthYearShort.dateFormatter.string(from: self)
    }

    /// String formatted *MMMM yyyy*
    public var monthYearLong: String {
        return Formatter.monthYearLong.dateFormatter.string(from: self)
    }

    /// String formatted *yyyyMMddy*
    public var serviceShort: String {
        return Formatter.serviceShort.dateFormatter.string(from: self)
    }

    /// String formatted *yyyy-MM-dd*
    public var serviceISO: String {
        return Formatter.serviceISO.dateFormatter.string(from: self)
    }

    /// String formatted *HH:mm:ssZZZZ*
    public var serviceTimeZone: String {
        return Formatter.serviceTimeZone.dateFormatter.string(from: self)
    }

    /// String formatted *yyyy-MM-dd'T'HH:mm:ssZ*
    public var serviceISOTimeZone: String {
        return Formatter.serviceISOTimeZone.dateFormatter.string(from: self)
    }

    // String formatted *yyyy-MM-dd'T'HH:mm:ss*
    public var serviceISOTime: String {
        return Formatter.serviceISOTime.dateFormatter.string(from: self)
    }

    /// String formatted *yyyy-MM-dd'T'HH:mm*
    public var serviceISOtimeShortFormat: String {
        return Formatter.serviceISOtimeShort.dateFormatter.string(from: self)
    }

    // String formatted *dd-MM-yyyy'T'HH:mm:ss*
    public var serviceReverseDateTime: String {
        return Formatter.serviceReverseDateTime.dateFormatter.string(from: self)
    }

    /// String formatted *yyyy-MM-ddHH:mm*
    public var serviceDateAndTimeFormat: String {
        return Formatter.serviceDateAndTime.dateFormatter.string(from: self)
    }

    // MARK: - Public methods

    /// Convert local time to UTC (or GMT)
    public func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    /// Convert UTC (or GMT) to local time
    public func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    /// Returns first day of the current date month
    public func startOfMonth() -> Date? {
        var comp: DateComponents = Calendar.current.dateComponents([.year, .month, .hour],
                                                                   from: Calendar.current.startOfDay(for: self))
        comp.hour = 0
        comp.minute = 0
        comp.second = 1

        return Calendar.current.date(from: comp)!
    }

    /// Returns last day of the current date month
    public func endOfMonth() -> Date? {
        var comp: DateComponents = Calendar.current.dateComponents([.month, .day, .hour],
                                                                   from: Calendar.current.startOfDay(for: self))
        comp.month = 1
        comp.day = -1
        comp.hour = 23
        comp.minute = 59
        comp.second = 59

        return Calendar.current.date(byAdding: comp, to: self.startOfMonth()!)
    }

    /// Returns time difference between dates
    public func offsetTime(to date: Date?) -> DateComponents {
        guard let toDate = date else {
            return DateComponents(hour: 0, minute: 0, second: 0)
        }

        let dayHourMinuteSecond: NSCalendar.Unit = [.hour, .minute, .second]
        let difference = (Calendar.current as NSCalendar).components(dayHourMinuteSecond, from: self, to: toDate, options: [])

        return difference
    }

    /// Returns if self is between dates with time
    public func isBetweenTime(start dateInit: Date, end dateEnd: Date) -> Bool {
        return ((self.compareTime(other: dateInit) == .orderedDescending || self.compareTime(other: dateInit) == .orderedSame) &&
            (self.compareTime(other: dateEnd) == .orderedAscending || self.compareTime(other: dateEnd) == .orderedSame))
    }

    /// Returns if self date is between dates without time
    public func isBetween(start dateInit: Date, end dateEnd: Date) -> Bool {
        return ((dateInit.compare(self) == .orderedAscending || dateInit.compare(self) == .orderedSame) &&
            (dateEnd.compare(self) == .orderedDescending ||  dateEnd.compare(self) == .orderedSame))
    }

    /// Returns comparison result between self and another date with time
    public func compareTime(other otherDate: Date) -> ComparisonResult {
        let unitFlags = Set<Calendar.Component>([.hour, .minute, .second])

        let componentsSelf =  Calendar.current.dateComponents(unitFlags, from: self)
        let componentsOther =  Calendar.current.dateComponents(unitFlags, from: otherDate)

        let dateSelf = Calendar.current.date(bySettingHour: componentsSelf.hour!, minute: componentsSelf.minute!, second: 0, of: Date())!
        let dateOther = Calendar.current.date(bySettingHour: componentsOther.hour!, minute: componentsOther.minute!, second: 0, of: Date())!

        return dateSelf.compare(dateOther)
    }

    /// Return human readable time formatted
    public func humanReadableTime() -> String {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.hour, .minute])
        let componentsHeaderTime = calendar.dateComponents(unitFlags, from: self)

        var timeHeader: String = ""
        guard let hours = componentsHeaderTime.hour,
              let minutes = componentsHeaderTime.minute else {
                return timeHeader
        }

        if componentsHeaderTime.minute == 0 {
            timeHeader = (hours > 0 ? ("\(hours) TXT_HOURS_SHORT") : "")
        } else {
            timeHeader = "\(hours) TXT_HOURS_SHORT " + "\(minutes) TXT_MINUTES_SHORT.localized"
        }

        return timeHeader
    }

    /// Return if dates are from the same day
    public func isSameDay(compareDate: Date) -> Bool {
        let dateComponents = self.getComponents()
        let compDateComponents = compareDate.getComponents()
        return dateComponents.day == compDateComponents.day &&
            dateComponents.month == compDateComponents.month &&
            dateComponents.year == compDateComponents.year
    }

    /// Return date with the incrementation
    public func addToComponent(_ componentType: Calendar.Component, value: Int) -> Date {

        var dateComponent = DateComponents()

        switch componentType {
        case .second:
            dateComponent.second = value
        case .minute:
            dateComponent.minute = value
        case .hour:
            dateComponent.hour = value
        case .day:
            dateComponent.day = value
        case .weekday:
            dateComponent.weekday = value
        case .weekdayOrdinal:
            dateComponent.weekdayOrdinal = value
        case .month:
            dateComponent.month = value
        case .weekOfYear:
            dateComponent.weekOfYear = value
        case .year:
            dateComponent.year = value
        default: return self
        }
        return Calendar.current.date(byAdding: dateComponent, to: self) ?? Date()
    }

    /// Return (day, month, year, weekday, hour, minutes)
    public func getComponents() -> (day: Int, month: Int, year: Int, weekday: Int, hour: Int, minutes: Int, dayOfYear: Int) {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        let weekDay: Int = {
            switch calendar.component(.weekday, from: self) {
            case 1: return BSWeekDay.sunday.rawValue
            case 2: return BSWeekDay.monday.rawValue
            case 3: return BSWeekDay.tuesday.rawValue
            case 4: return BSWeekDay.wednesday.rawValue
            case 5: return BSWeekDay.thurday.rawValue
            case 6: return BSWeekDay.friday.rawValue
            case 7: return BSWeekDay.saturday.rawValue
            default: return 0
            }
        }()
        let hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: self) ?? 1
        return (day, month, year, weekDay, hour, minutes, dayOfYear)
    }

     public var startOfDay: Date {
         let calendar = Calendar.current
         let unitFlags = Set<Calendar.Component>([.year, .month, .day])
         let components = calendar.dateComponents(unitFlags, from: self)
         return calendar.date(from: components) ?? Date()
    }

     public var endOfDay: Date {
         var components = DateComponents()
         components.day = 1
         let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
         return (date?.addingTimeInterval(-1)) ?? Date()
     }

    public var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }

    public var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }

    public var startOfYear: Date? {
        let calendar = Calendar.current

        var dateComponents: DateComponents = calendar.dateComponents([.hour, .minute, .second], from: self)

        dateComponents.day = 1
        dateComponents.month = 1
        dateComponents.year = self.getComponents().year
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        let date: Date? = calendar.date(from: dateComponents)
        return date
    }

    public var endOfYear: Date? {
        let calendar = Calendar.current

        var dateComponents: DateComponents = calendar.dateComponents([.hour, .minute, .second], from: self)

        dateComponents.day = 31
        dateComponents.month = 12
        dateComponents.year = self.getComponents().year
        dateComponents.hour = 23
        dateComponents.minute = 59
        dateComponents.second = 59

        let date: Date? = calendar.date(from: dateComponents)
        return date
    }

    public func getNumberOfDaysInMonth() -> Int {
        let calendar = Calendar.current

        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count

        return numDays
    }
}
