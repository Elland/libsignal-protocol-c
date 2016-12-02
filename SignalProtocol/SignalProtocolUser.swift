import Foundation
import SignalProtocolC

public class Signal {
    public var context: SignalContext

    public var store: SignalStoreInMemoryStorage

    public var storage: SignalStorage

    public var keyHelper: SignalKeyHelper

    init() {
        self.store = SignalStoreInMemoryStorage()
        self.storage = SignalStorage(signalStore: self.store)
        self.context = SignalContext(storage: self.storage)
        self.keyHelper = SignalKeyHelper(context: self.context)
    }
}

public class SignalProtocolUser {
    unowned var signal: Signal

    public var address: SignalAddress

    public var preKeys: [SignalPreKey]

    public var lastResortPreKey: SignalPreKey

    public var signedPreKey: SignalSignedPreKey

    public var localRegistrationID: UInt32

    public var identityKeyPair: SignalIdentityKeyPair

    public init(username: String, signal: Signal, deviceID: UInt32) {
        self.signal = signal

        self.address = SignalAddress(name: username, deviceID: Int32(deviceID))

        self.identityKeyPair = self.signal.keyHelper.generateIdentityKeyPair()
        self.localRegistrationID = self.signal.keyHelper.generateRegistrationID()

        self.signal.store.identityKeyPair = identityKeyPair
        self.signal.store.localRegistrationID = localRegistrationID

        self.preKeys = self.signal.keyHelper.generatePreKeys(withStartingPreKeyID: 0, count: 100)
        self.lastResortPreKey = self.signal.keyHelper.generateLastResortPreKey()
        self.signedPreKey = self.signal.keyHelper.generateSignedPreKey(withIdentity: identityKeyPair, signedPreKeyID: 0)
    }

    public func preKeyBundle(for preKey: SignalPreKey) -> SignalPreKeyBundle {
        return SignalPreKeyBundle(registrationID: self.signal.store.localRegistrationID, deviceID: UInt32(self.address.deviceID), preKeyID: preKey.preKeyId(), preKeyPublic: preKey.keyPair().publicKey, signedPreKeyID: self.signedPreKey.preKeyID(), signedPreKeyPublic: self.signedPreKey.keyPair().publicKey, signature: self.signedPreKey.signature(), identityKey: self.signal.store.identityKeyPair!.publicKey)
    }
}
