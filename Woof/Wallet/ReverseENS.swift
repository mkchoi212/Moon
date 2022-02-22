//
//  ReverseENS.swift
//  Woof
//
//  Created by Mike Choi on 2/21/22.
//

import Foundation

final class ReverseENS {
    func reverseENSLookup(ensName: String) async throws -> String? {
        guard let url = URL(string: "https://0xmade-ens.vercel.app/api/ens/resolve?name=\(ensName)") else {
            return nil
        }
                
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(ReverseENSLookupResponse.self, from: data).address
    }
}
