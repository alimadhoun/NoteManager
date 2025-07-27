//
//  Date+Extension.swift
//  NoteManager
//
//  Created by Ali Madhoun on 27/07/2025.
//

import Foundation

extension Date {
    
    func getDateComponents() -> (day: Int, month: Int, year: Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: self)
        return (day: components.day ?? 0, month: components.month ?? 0, year: components.year ?? 0)
    }
}
