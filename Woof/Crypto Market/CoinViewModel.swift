//
//  CoinViewModel.swift
//  Woof
//
//  Created by Mike Choi on 12/17/21.
//

import Foundation

/**
 TODO: Replace with proxy server
 https://www.youtube.com/watch?v=ZGymN8aFsv4&ab_channel=TraversyMedia
 */
final class CoinViewModel: ObservableObject {
    let decoder = JSONDecoder()
    let service = CoinDataService()
    @Published var coins: [CoinModel] = []
    var symbolNameTable: [String: String]
    
    static let coinsKey = "coins"
    static let coinsLastSavedKey = "coins.last.fetched"
    static let coinsSymbolTable = "coins.symbol.table"
    static let shared = CoinViewModel()
    
    init() {
        symbolNameTable = (UserDefaults.standard.dictionary(forKey: CoinViewModel.coinsSymbolTable) as? [String: String]) ?? [:]
    }
    
    func fetchCoinData() {
        if !coins.isEmpty { return }
        
        let data = UserDefaults.standard.data(forKey: "coins")
        let lastFetchedEpoch = UserDefaults.standard.double(forKey: "coins.last.fetched")
        let lastFetchedDate = Date(timeIntervalSince1970: lastFetchedEpoch)
        let isWithinTenMinutes = false
        
        if let data = data, isWithinTenMinutes {
            coins = (try? decoder.decode([CoinModel].self, from: data)) ?? []
        } else {
            service.getCoinData { [weak self] data in
                self?.processAndCacheData(data: data)
            }
        }
    }
    
    func name(for symbol: String) -> String? {
        symbolNameTable[symbol]
    }
    
    func processAndCacheData(data: Data) {
        if let parsedCoins = try? decoder.decode([CoinModel].self, from: data) {
            coins = parsedCoins
            UserDefaults.standard.set(data, forKey: CoinViewModel.coinsKey)
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: CoinViewModel.coinsLastSavedKey)
            
            let symbolNameTable = Dictionary(uniqueKeysWithValues: coins.map { ($0.symbol, $0.name) })
            self.symbolNameTable = symbolNameTable
            UserDefaults.standard.set(symbolNameTable, forKey: CoinViewModel.coinsSymbolTable)
        }
    }
}
