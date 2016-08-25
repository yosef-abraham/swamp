// https://github.com/Quick/Quick

import Quick
import Nimble
import Swamp

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        describe("Basic connection") {
            it("Should work") {
                let session = SwampSession(realm: "buster-network", transport: WebSocketSwampTransport(wsEndpoint: NSURL(string: "ws://localhost:8080/ws")!))
                session.connect()
                expect(session.sessionId).toEventually( beTruthy(), timeout: 5 )
            }
        }
    }
}
