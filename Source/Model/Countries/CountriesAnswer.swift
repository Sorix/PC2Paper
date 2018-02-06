//
//  CountriesRequest.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 06/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

/// Answer for `CountriesList.fetch(...)` request, returning the list of countries for PC2Paper.
public struct CountriesAnswer {
	
	/// Array of countries
	public let countries: [Country]

	// MARK: - Models
	public struct Country {
		
		/// Internal ID for a country, used by other API methods
		public let id: Int
		
		/// Country name
		public let name: String
		
	}

	init(from data: Data) throws {
		guard let text = String(data: data, encoding: .utf8) else {
			throw ApiError.parseFailed(error: TextError("Unable to convert data to string"))
		}
		
		var countries = [Country]()
		
		let rows = text.components(separatedBy: .newlines)
		for row in rows {
			guard !row.isEmpty else { continue } // it is last line
			
			let country = try CountriesAnswer.parse(row: row)
			countries.append(country)
		}
		
		self.countries = countries
	}
	
	/// Parse CSV row to country
	///
	/// - Parameter row: row at CSV file, example: `10,"Antigua & Barbuda	"`
	/// - Throws: `ApiError.parseFailed` if row has unexpected format
	private static func parse(row: String) throws -> Country {
		let columns = row.components(separatedBy: ",")
		guard columns.count == 2 else {
			throw ApiError.parseFailed(error: TextError("Unexpected number of columns: \(columns.count)"))
		}
		
		// Raw values
		let rawId = columns[0]
		let rawCountry = columns[1]
		
		// Convert ID to Int
		guard let id = Int(rawId) else {
			throw ApiError.parseFailed(error: TextError("Incorrect country id: \(rawId)"))
		}
		
		// Trim country (raw value: `"Abu Dhabi (use UAE)	"`
		var characterSetToTrim = CharacterSet.whitespaces
		characterSetToTrim.insert(charactersIn: "\"")
		let country = rawCountry.trimmingCharacters(in: characterSetToTrim)
		
		return Country(id: id, name: country)
	}
	
}
