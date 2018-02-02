This interface returns all the "extras" available to a user based on the zone they wish to send their letter from (as discussed in the **Postage Options**) section). This will return options such as recorded delivery, signed for etc...

If we call this method using zone 3 (UK first class postage):

```swift
let request = ZoneOffersRequest(zoneID: 3)

PricingAPI().make(request: request) { (result) in
	switch result {
	case .succeed(let answer):
		print(answer.offers)
	case .failed(let error):
		print(error)
	}
}
```

The above would return the following:
```
[
  Offer(itemID: 6, name: "Add PC2Paper logo for a 3p discount"),
  Offer(itemID: 12, name: "Stapling")
]
```

You can use it as "extra" features in your application.
