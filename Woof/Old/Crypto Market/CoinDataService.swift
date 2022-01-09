//
//  CoinService.swift
//  Woof
//
//  Created by Mike Choi on 12/17/21.
//

import Foundation
import Combine

final class CoinDataService {
    var coinNetworkSink: AnyCancellable?
    
    func getCoinData(completion: @escaping (Data) -> ()) {
        let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")!
        
        coinNetworkSink = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output -> Data in
                guard let resp = output.response as? HTTPURLResponse,
                      resp.statusCode >= 200 && resp.statusCode < 300 else {
                          throw URLError(.badServerResponse)
                      }
                
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    case .failure(let err):
                        print(err.localizedDescription)
                    default:
                        break
                }
            } receiveValue: { [weak self] data in
                completion(data)
                self?.coinNetworkSink?.cancel()
            }
    }
}
