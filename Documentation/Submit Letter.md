To submit letter for sending via PC2Paper you need to construct request. It consists from several steps.

#### Receiver Address
Let's fill receiver's address

```swift
var receiverAddress = SubmitLetterForPostingRequestBody.Letter.Address()
address.name = "John Smith"
address.addressLine1 = "1 Acme Road"
address.addressLine2 = "My Street"
address.townCity = "London"
address.postCode = "420000"
```

#### Letter Header
Now we can construct letter's header.

```swift
var letter = SubmitLetterForPostingRequestBody.Letter(sourceClient: "My app name",
													  addresses: [receiverAddress],
													  receiverCountryCode: 1,
													  postage: 1,
													  paper: 1,
													  envelope: 1,
													  extras: 1)

letter.letterBody = "Hello, John! See you later."
```

Don't forget to change additional fields, you can read about all fields at `SubmitLetterForPostingRequestBody.Letter` structure's documentation.

#### Request
We have all information to construct API request.

```swift
let requestBody = SubmitLetterForPostingRequestBody(letter: letter, username: "apiusername", password: "apipassword")
let request = SubmitLetterForPostingRequest(body: requestBody)
```

#### API call
Now we have ready request and we can send it via API.

```swift
LetterAPI.make(request: request) { result in
	switch result {
	case .succeed(let answer):
		// Answer is `SubmitLetterForPostingAnswer`
		print(answer.letterId)
	case .failed(let error):
		// Some network / parse errors
		print("\(error)")
	}
}
```
