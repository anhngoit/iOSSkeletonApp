//
//  AppState.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation

/// App-wide state shared across features, resolved as a singleton from
/// `Container.appState`.
///
/// Kept deliberately small: put feature state in its own view model and only
/// promote it here when more than one feature genuinely needs it. Navigation
/// routing is the usual first candidate.
final class AppState {
}
