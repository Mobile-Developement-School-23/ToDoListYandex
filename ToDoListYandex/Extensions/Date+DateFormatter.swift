//
//  Date+DateFormatter.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 03.07.2023.
//

import Foundation

private let dateFormatterDayMonth: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMMM"
    return dateFormatter
}()

private let dateFormatterDayMonthYear: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMMM yyyy"
    return dateFormatter
}()

extension Date {
    var dayMonthDate: String { dateFormatterDayMonth.string(from: self) }
    
    var dayMonthYearDate: String { dateFormatterDayMonthYear.string(from: self) }
}
