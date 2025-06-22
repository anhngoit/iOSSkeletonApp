//
//  ChatUseCase.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 22/6/25.
//

import Foundation
import Combine

protocol ChatUseCase {
    func execute() -> AnyPublisher<Chat, any Error>
}
