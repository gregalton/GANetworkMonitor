// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

import Foundation

public class GANetworkMonitor: URLProtocol {
    
    private static let handledKey = "GANetworkMonitorHandledKey"
    private var startTime: Date?
    private var dataTask: URLSessionDataTask?
    
    // To store information
    public struct RequestInfo {
        public let url: URL
        public let duration: TimeInterval
        public let redirection: Bool
    }
    
    public static var requestInfos: [RequestInfo] = []

    override public class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: GANetworkMonitor.handledKey, in: request) != nil {
            return false
        }
        return true
    }
    
    override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override public func startLoading() {
        self.startTime = Date()
        
        if let newRequest = (self.request as NSURLRequest).mutableCopy() as? NSMutableURLRequest {
            URLProtocol.setProperty(true, forKey: GANetworkMonitor.handledKey, in: newRequest)
            
            self.dataTask = URLSession.shared.dataTask(with: newRequest as URLRequest) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let response = response as? HTTPURLResponse,
                   let url = response.url {
                    let duration = Date().timeIntervalSince(self.startTime ?? Date())
                    let redirection = (300...399).contains(response.statusCode)
                    
                    let requestInfo = RequestInfo(url: url, duration: duration, redirection: redirection)
                    GANetworkMonitor.requestInfos.append(requestInfo)
                }
                
                if let response = response {
                    self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                }
                if let data = data {
                    self.client?.urlProtocol(self, didLoad: data)
                }
                if let error = error {
                    self.client?.urlProtocol(self, didFailWithError: error)
                }
                self.client?.urlProtocolDidFinishLoading(self)
            }
            self.dataTask?.resume()
        }
    }
    
    override public func stopLoading() {
        self.dataTask?.cancel()
    }
    
    public static func startMonitoring() {
        URLProtocol.registerClass(GANetworkMonitor.self)
    }
    
    public static func stopMonitoring() {
        URLProtocol.unregisterClass(GANetworkMonitor.self)
    }
    
    public static func getRequestInfos() -> [RequestInfo] {
        return requestInfos
    }
}
