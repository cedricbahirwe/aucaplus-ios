//
//  SupabaseManager.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 22/08/2023.
//

import Foundation
import Supabase

enum DBTable: String {
    case news, internships, aucaUsers
    case jobs, announcements, resources
}

class APIClient {
    internal let client = SupabaseClient(
        supabaseURL: AppSecrets.projectURL,
        supabaseKey: AppSecrets.apiKey)
    
    enum APIError: Error {
        case invalidID
    }
}

extension Supabase.User {
    func toAucaStudent() -> AucaStudent {
        AucaStudent(id: id,
                    firstName: userMetadata["first_name"]?.value as? String ?? "",
                    lastName: userMetadata["last_name"]?.value as? String ?? "",
                    phoneNumber: phone ?? "",
                    email: email ?? "",
                    type: .init(rawValue: userMetadata["account_type"]?.value as? String ?? "") ?? .visitor,
                    about: userMetadata["about"]?.value as? String,
                    picture: userMetadata["picture"]?.value as? URL,
                    createdAt: createdAt,
                    updatedAt: updatedAt)
    }
}

#if DEBUG
extension APIClient {
    func printJson(from table: String) async {
        do {
            let data: Data = try await client.database
                .from(table)
                .select()
                .execute()
                .underlyingResponse.data
            
            if let json = try? JSONSerialization.jsonObject(with: data) {
                Log.debug("Json Found is", json)
            } else {
                Log.debug("❌No Json Found")
            }
        } catch {
            Log.debug("❌Error found during json printing:", error)
        }
    }
}
#endif
