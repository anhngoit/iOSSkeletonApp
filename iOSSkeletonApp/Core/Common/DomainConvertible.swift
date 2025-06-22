//
//  DomainConvertible.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation

protocol DomainConvertible {
    associatedtype DomainType
    func toDomain() -> DomainType
}
