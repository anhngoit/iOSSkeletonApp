// Generated using Sourcery 2.3.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable all
@preconcurrency import Combine
@preconcurrency import SwiftUI

import Foundation

@testable import iOSSkeletonApp
nonisolated class GetMovieListUseCaseMock: GetMovieListUseCase, @unchecked Sendable {

    //MARK: - execute

    private let executeCallsCountLock = NSLock()
    private nonisolated(unsafe) var executeUnderlyingCallsCount = 0
    var executeCallsCount: Int {
        get { executeCallsCountLock.withLock { executeUnderlyingCallsCount } }
        set { executeCallsCountLock.withLock { executeUnderlyingCallsCount = newValue } }
    }
    var executeCalled: Bool {
        return executeCallsCount > 0
    }

    private let executeReturnValueLock = NSLock()
    private nonisolated(unsafe) var executeUnderlyingReturnValue: AnyPublisher<MoviePage, any Error>!
    var executeReturnValue: AnyPublisher<MoviePage, any Error>! {
        get { executeReturnValueLock.withLock { executeUnderlyingReturnValue } }
        set { executeReturnValueLock.withLock { executeUnderlyingReturnValue = newValue } }
    }
    nonisolated(unsafe) var executeClosure: (() -> AnyPublisher<MoviePage, any Error>)?

    func execute() -> AnyPublisher<MoviePage, any Error> {
        executeCallsCountLock.withLock { executeUnderlyingCallsCount += 1 }
        if let executeClosure = executeClosure {
            return executeClosure()
        } else {
            return executeReturnValue
        }
    }
}
nonisolated class MovieListRepositoryMock: MovieListRepository, @unchecked Sendable {

    //MARK: - getRemotePopularMovies

    private let getRemotePopularMoviesCallsCountLock = NSLock()
    private nonisolated(unsafe) var getRemotePopularMoviesUnderlyingCallsCount = 0
    var getRemotePopularMoviesCallsCount: Int {
        get { getRemotePopularMoviesCallsCountLock.withLock { getRemotePopularMoviesUnderlyingCallsCount } }
        set { getRemotePopularMoviesCallsCountLock.withLock { getRemotePopularMoviesUnderlyingCallsCount = newValue } }
    }
    var getRemotePopularMoviesCalled: Bool {
        return getRemotePopularMoviesCallsCount > 0
    }

    private let getRemotePopularMoviesReturnValueLock = NSLock()
    private nonisolated(unsafe) var getRemotePopularMoviesUnderlyingReturnValue: AnyPublisher<MoviePage, any Error>!
    var getRemotePopularMoviesReturnValue: AnyPublisher<MoviePage, any Error>! {
        get { getRemotePopularMoviesReturnValueLock.withLock { getRemotePopularMoviesUnderlyingReturnValue } }
        set { getRemotePopularMoviesReturnValueLock.withLock { getRemotePopularMoviesUnderlyingReturnValue = newValue } }
    }
    nonisolated(unsafe) var getRemotePopularMoviesClosure: (() -> AnyPublisher<MoviePage, any Error>)?

    func getRemotePopularMovies() -> AnyPublisher<MoviePage, any Error> {
        getRemotePopularMoviesCallsCountLock.withLock { getRemotePopularMoviesUnderlyingCallsCount += 1 }
        if let getRemotePopularMoviesClosure = getRemotePopularMoviesClosure {
            return getRemotePopularMoviesClosure()
        } else {
            return getRemotePopularMoviesReturnValue
        }
    }
    //MARK: - getLocalPopularMovies

    private let getLocalPopularMoviesCallsCountLock = NSLock()
    private nonisolated(unsafe) var getLocalPopularMoviesUnderlyingCallsCount = 0
    var getLocalPopularMoviesCallsCount: Int {
        get { getLocalPopularMoviesCallsCountLock.withLock { getLocalPopularMoviesUnderlyingCallsCount } }
        set { getLocalPopularMoviesCallsCountLock.withLock { getLocalPopularMoviesUnderlyingCallsCount = newValue } }
    }
    var getLocalPopularMoviesCalled: Bool {
        return getLocalPopularMoviesCallsCount > 0
    }

    private let getLocalPopularMoviesReturnValueLock = NSLock()
    private nonisolated(unsafe) var getLocalPopularMoviesUnderlyingReturnValue: AnyPublisher<MoviePage?, Error>!
    var getLocalPopularMoviesReturnValue: AnyPublisher<MoviePage?, Error>! {
        get { getLocalPopularMoviesReturnValueLock.withLock { getLocalPopularMoviesUnderlyingReturnValue } }
        set { getLocalPopularMoviesReturnValueLock.withLock { getLocalPopularMoviesUnderlyingReturnValue = newValue } }
    }
    nonisolated(unsafe) var getLocalPopularMoviesClosure: (() -> AnyPublisher<MoviePage?, Error>)?

    func getLocalPopularMovies() -> AnyPublisher<MoviePage?, Error> {
        getLocalPopularMoviesCallsCountLock.withLock { getLocalPopularMoviesUnderlyingCallsCount += 1 }
        if let getLocalPopularMoviesClosure = getLocalPopularMoviesClosure {
            return getLocalPopularMoviesClosure()
        } else {
            return getLocalPopularMoviesReturnValue
        }
    }
    //MARK: - savePopularMovies

    private let savePopularMoviesMovieResponseCallsCountLock = NSLock()
    private nonisolated(unsafe) var savePopularMoviesMovieResponseUnderlyingCallsCount = 0
    var savePopularMoviesMovieResponseCallsCount: Int {
        get { savePopularMoviesMovieResponseCallsCountLock.withLock { savePopularMoviesMovieResponseUnderlyingCallsCount } }
        set { savePopularMoviesMovieResponseCallsCountLock.withLock { savePopularMoviesMovieResponseUnderlyingCallsCount = newValue } }
    }
    var savePopularMoviesMovieResponseCalled: Bool {
        return savePopularMoviesMovieResponseCallsCount > 0
    }
    private let savePopularMoviesMovieResponseReceivedMovieResponseLock = NSLock()
    private nonisolated(unsafe) var savePopularMoviesMovieResponseUnderlyingReceivedMovieResponse: MoviePage?
    var savePopularMoviesMovieResponseReceivedMovieResponse: MoviePage? {
        get { savePopularMoviesMovieResponseReceivedMovieResponseLock.withLock { savePopularMoviesMovieResponseUnderlyingReceivedMovieResponse } }
        set { savePopularMoviesMovieResponseReceivedMovieResponseLock.withLock { savePopularMoviesMovieResponseUnderlyingReceivedMovieResponse = newValue } }
    }
    private let savePopularMoviesMovieResponseReceivedInvocationsLock = NSLock()
    private nonisolated(unsafe) var savePopularMoviesMovieResponseUnderlyingReceivedInvocations: [MoviePage] = []
    var savePopularMoviesMovieResponseReceivedInvocations: [MoviePage] {
        get { savePopularMoviesMovieResponseReceivedInvocationsLock.withLock { savePopularMoviesMovieResponseUnderlyingReceivedInvocations } }
        set { savePopularMoviesMovieResponseReceivedInvocationsLock.withLock { savePopularMoviesMovieResponseUnderlyingReceivedInvocations = newValue } }
    }

    private let savePopularMoviesMovieResponseReturnValueLock = NSLock()
    private nonisolated(unsafe) var savePopularMoviesMovieResponseUnderlyingReturnValue: AnyPublisher<Void, Error>!
    var savePopularMoviesMovieResponseReturnValue: AnyPublisher<Void, Error>! {
        get { savePopularMoviesMovieResponseReturnValueLock.withLock { savePopularMoviesMovieResponseUnderlyingReturnValue } }
        set { savePopularMoviesMovieResponseReturnValueLock.withLock { savePopularMoviesMovieResponseUnderlyingReturnValue = newValue } }
    }
    nonisolated(unsafe) var savePopularMoviesMovieResponseClosure: ((MoviePage) -> AnyPublisher<Void, Error>)?

    func savePopularMovies(movieResponse: MoviePage) -> AnyPublisher<Void, Error> {
        savePopularMoviesMovieResponseCallsCountLock.withLock { savePopularMoviesMovieResponseUnderlyingCallsCount += 1 }
        savePopularMoviesMovieResponseReceivedMovieResponse = movieResponse
        savePopularMoviesMovieResponseReceivedInvocationsLock.withLock { savePopularMoviesMovieResponseUnderlyingReceivedInvocations.append(movieResponse) }
        if let savePopularMoviesMovieResponseClosure = savePopularMoviesMovieResponseClosure {
            return savePopularMoviesMovieResponseClosure(movieResponse)
        } else {
            return savePopularMoviesMovieResponseReturnValue
        }
    }
}
// swiftlint:enable all
