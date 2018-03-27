If you'd like to include PDF's as attachment's to your letter, you can upload these and use the unique id's the API gives you to attach them to your letter.

```swift
let body = UploadDocumentRequestBody(filename: "1.pdf", fileData: pdfData, username: "apiusername", password: "apipassword")
let request = UploadDocumentRequest(body: body)

LetterAPI.make(request: request) { result in
	switch result {
	case .succeed(let answer):
		// Save file's GUID to use it in Letter's Body
		print(answer.fileCreatedGUID)
	case .failed(let error):
		// Some network / parse errors
		print("\(error)")
	}
}
```

After uploads completed add file GUIDs to `SubmitLetterForPostingRequestBody.Letter.fileAttachementGUIDs` array.
