//
//  DIContainer.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation
import Moya
import Alamofire
import Factory

extension Container {
    
    // MARK: - AppState
    var appState: Factory<AppState> {
        Factory(self) {
            AppState()
        }
        .singleton
    }
    
    // MARK: - Network
    private var alamofireSession: Factory<Session> {
        Factory(self) {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 60
            configuration.timeoutIntervalForResource = 120
            configuration.waitsForConnectivity = true
            configuration.httpMaximumConnectionsPerHost = 5
            configuration.requestCachePolicy = .returnCacheDataElseLoad
            configuration.urlCache = .shared
            configuration.httpCookieAcceptPolicy = .always
            configuration.httpCookieStorage = HTTPCookieStorage.shared
            configuration.httpShouldSetCookies = true

            if #available(iOS 15.0, *) {
                configuration.allowsExpensiveNetworkAccess = true
                configuration.allowsConstrainedNetworkAccess = true
            }

            let backgroundQueue = DispatchQueue(label: "com.app.network", qos: .background)

            return Session(configuration: configuration, rootQueue: backgroundQueue)
        }
        .singleton
    }
    
    private var moyaPlugins: Factory<[PluginType]> {
        Factory(self) {
            [CustomMoyaPlugin()]
        }
        .singleton
    }
    

    // MARK: - Datasources
    var movieApiDataSource: Factory<MoyaProvider<MovieAPI>> {
        Factory(self) {
            MoyaProvider<MovieAPI>(session: self.alamofireSession(), plugins: self.moyaPlugins())
        }
        .cached
    }

    var movieLocalDataSource: Factory<CDDataSource<MoviePageCDModel>> {
        Factory(self) {
            CDDataSource<MoviePageCDModel>()
        }
        .cached
    }
    
    
    // MARK: - Repositories
    var movieListRepository: Factory<MovieListRepository> {
            Factory(self) {
                MovieListRepositoryImpl()
            }
            .cached
        }
    

    // MARK: - Use Cases
    var movieListUseCase: Factory<GetMovieListUseCase> {
        Factory(self) {
            GetMovieListUseCaseImpl()
        }
        .cached
    }
}
