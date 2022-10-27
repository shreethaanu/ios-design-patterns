import UIKit
import Foundation

protocol LoadData {
    func load(completion: @escaping (Result<Data, Error>) -> Void)
}
class LoadRemoteData: LoadData {
    func load(completion: @escaping (Result<Data, Error>) -> Void) {
        completion(.failure(NSError(domain: "any error", code: 0)))
    }
}
class LoadLocalData: LoadData {
    func load(completion: @escaping (Result<Data, Error>) -> Void) {
        completion(.success("'my local data'".data(using: .utf8)!))
    }
}
class CompositeFallbackLoader: LoadData {
    let remote: LoadData
    let local: LoadData
    init(remote: LoadData, local: LoadData) {
        self.remote = remote
        self.local = local
    }
    func load(completion: @escaping (Result<Data, Error>) -> Void) {
        remote.load(completion: { [weak self] result in
            switch result {
            case .success:
                print("fetch \(result) remotely")
            case .failure:
                self?.retrieveLocalData()
            }
        })
    }
    private func retrieveLocalData() {
        local.load(completion: { localResult in
            switch localResult {
            case let .success(data):
                let myData = String(data: data, encoding: .utf8)!
                print("fetch \(myData) locally")
            case let .failure(error):
                print(error)
            }
        })
    }
}
// Client
let composite = CompositeFallbackLoader(
    remote: LoadRemoteData(),
    local: LoadLocalData()
)
composite.load(completion: { result in
    switch result {
    case let .success(data):
        print(data)
    case let .failure(error):
        print(error)
    }
})
