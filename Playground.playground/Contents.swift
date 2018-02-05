import PlaygroundSupport
import PC2Paper
PlaygroundPage.current.needsIndefiniteExecution = true

let user = "testuser"
let password = "testpassword"

//http://www.pc2paper.co.uk/datagetpostage.asp?method=getTotalForLetterByPages&str=3,5,1,0,1 (Total Letter Cost)

//let request = TotalLetterCostRequest(zoneID: 3, paperTypeID: 5, numberOfPages: 1, zoneOfferID: 0, envelopeTypeID: 1)
//
//let api = PricingAPI()
//api.make(request: request) { (result) in
//	switch result {
//	case .succeed(let answer):
//		print(answer)
//	case .failed(let error):
//		print(error)
//	}
//
//	PlaygroundPage.current.finishExecution()
//}

CountriesList().fetch { result in
	switch result {
	case .succeed(let answer):
		print(answer)
	case .failed(let error):
		debugPrint(error)
	}
	
	PlaygroundPage.current.finishExecution()
}
