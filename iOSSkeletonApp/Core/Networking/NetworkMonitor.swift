//
//  NetworkMonitor.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation
import Network
import OSLog

class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "NetworkMonitor")
    @Published var isNotConnected = false
    
    init() {
        AppLogger.networking.info("Initializing NetworkMonitor.")
        
        networkMonitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            let statusMessage = path.status == .satisfied ? "Connected" : "Not Connected"
            AppLogger.networking.info("Network status changed: \(statusMessage)")
            
            DispatchQueue.main.async {
                self.isNotConnected = path.status != .satisfied
            }
        }
        
        AppLogger.networking.info("Starting network monitor.")
        networkMonitor.start(queue: workerQueue)
    }
    
    deinit {
        AppLogger.networking.info("Stopping network monitor.")
        networkMonitor.cancel()
    }
}
