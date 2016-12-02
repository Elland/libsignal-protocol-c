import Foundation
import SignalProtocolC

class Demo {
    init() {
        let aliceSignal = Signal()
        let bobSignal = Signal()

        let bob = SignalProtocolUser(username: "Bob", signal: bobSignal, deviceID: 12351)
        let alice = SignalProtocolUser(username: "Alice", signal: aliceSignal, deviceID: 12355)

        let bobSessionBuilder = SignalSessionBuilder(address: alice.address, context: bobSignal.context)

        let preKey = alice.preKeys.first!
        aliceSignal.store.storePreKey(preKey.serializedData(), preKeyID: preKey.preKeyId())
        aliceSignal.store.storeSignedPreKey(alice.signedPreKey.serializedData(), signedPreKeyID: alice.signedPreKey.preKeyID())
        let alicePreKeyBundle = alice.preKeyBundle(for: preKey)

        bobSessionBuilder.processPreKeyBundle(alicePreKeyBundle)

        let bobSessionCipher = SignalSessionCipher(address: alice.address, context: bobSignal.context)

        let bobMessage = "Hey I'm Bob!"
        let messageData = bobMessage.data(using: .utf8)!
        let bobCipheredText = bobSessionCipher.encryptData(messageData, error: nil)

        let aliceSessionCipher = SignalSessionCipher(address: bob.address, context: aliceSignal.context)
        let decryptedMessage = aliceSessionCipher.decryptCipherText(bobCipheredText, error: nil)
        let decryptedString = String(data: decryptedMessage, encoding: .utf8)!

        print("Bob sent: \(bobMessage)")
        print("Alice received: \(decryptedString)")
    }
}
