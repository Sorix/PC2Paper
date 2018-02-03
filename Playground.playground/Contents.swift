import PlaygroundSupport
import PC2Paper
PlaygroundPage.current.needsIndefiniteExecution = true

let user = "testuser"
let password = "testpassword"

let request = EnvelopesAvailableRequest(zoneID: 1)

let api = PricingAPI()
api.make(request: request) { (result) in
	switch result {
	case .succeed(let answer):
		print(answer)
	case .failed(let error):
		print(error)
	}
	
	PlaygroundPage.current.finishExecution()
}


