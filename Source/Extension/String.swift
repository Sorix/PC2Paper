//
//  String.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 02/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

extension String {
	
	/// Returns a percent-escaped string following RFC 3986 for a query string key or value.
	///
	/// RFC 3986 states that the following characters are "reserved" characters.
	///
	/// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
	/// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
	///
	/// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
	/// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
	/// should be percent-escaped in the query string.
	///
	/// - parameter string: The string to be percent-escaped.
	///
	/// - returns: The percent-escaped string.
	func escaped() -> String {
		let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
		let subDelimitersToEncode = "!$&'()*+,;="
		
		var allowedCharacterSet = CharacterSet.urlQueryAllowed
		allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
		
		return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? String()
	}
	
}
