The first request is to find out what postage options are available to the user based on what country they are sending their letter to. You do this by making the following request.

```swift
let request = ZonesLetterCanBeSentFromRequest(countryCode: 1)
PricingAPI().make(request: request) { result in
	switch result {
	case .succeed(let answer):
		print(answer)
	case .failed(let error):
		print("\(error)")
	}
}
```

The parameter `countryCode` is the country code we wish to receive available pricing for. In this case the country code 1 represents the UK.

Let's print example output for that call:

```
ZonesLetterCanBeSentFromAnswer(zones: [
  Zone(id: 31, postageClass: "UK 2nd Class"),
  Zone(id: 3, postageClass: "UK 1st Class"),
  Zone(id: 34, postageClass: "UK Special Next Day Delivery"),
  Zone(id: 20, postageClass: "UK Signed For 1st class")
])
```

PC2Paper represents each postage option as a Zone. The API has worked out that you can send a letter to the UK via 3 zones Thailand or Via the UK using 1st class or 2nd class postage. If you were making your own application you would probably present these options to your user in a drop down list.

*Your application will need to store the zoneid selected by the user and feed this into the other API methods which all require them.*
