import UIKit
import SignalProtocol
import SignalProtocolC

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let sender = SignalAddress(name: "bob", deviceID: 12351)
        let recipient = SignalAddress(name: "alice", deviceID: 12355)

        let recipientStore = SignalStoreInMemoryStorage()
        let recipientStorage = SignalStorage(signalStore: recipientStore)
        let recipientContext = SignalContext(storage: recipientStorage)
        let recipientKeyHelper = SignalKeyHelper(context: recipientContext)

        let recipientIdentityKeyPair = recipientKeyHelper.generateIdentityKeyPair()
        let recipientLocalRegistrationId = recipientKeyHelper.generateRegistrationID()

        recipientStore.identityKeyPair = recipientIdentityKeyPair
        recipientStore.localRegistrationID = recipientLocalRegistrationId

        let recipientPreKeys = recipientKeyHelper.generatePreKeys(withStartingPreKeyID: 0, count: 100)
        // let recipientLastResortPreKey = recipientKeyHelper.generateLastResortPreKey()
        let recipientSignedPreKey = recipientKeyHelper.generateSignedPreKey(withIdentity: recipientIdentityKeyPair, signedPreKeyID: 0)

        let recipientPreKeyFirst = recipientPreKeys.first!
        recipientStore.storePreKey(recipientPreKeyFirst.serializedData(), preKeyID: recipientPreKeyFirst.preKeyId())
        recipientStore.storeSignedPreKey(recipientSignedPreKey.serializedData(), signedPreKeyID: recipientSignedPreKey.preKeyID())

        let recipientPreKeyBundle = SignalPreKeyBundle(registrationID: recipientLocalRegistrationId, deviceID: recipient.deviceID, preKeyID: recipientPreKeyFirst.preKeyId(), preKeyPublic: recipientPreKeyFirst.keyPair().publicKey, signedPreKeyID: recipientSignedPreKey.preKeyID(), signedPreKeyPublic: recipientSignedPreKey.keyPair().publicKey, signature: recipientSignedPreKey.signature(), identityKey: recipientIdentityKeyPair.publicKey)

        let senderStore = SignalStoreInMemoryStorage()
        let senderStorage = SignalStorage(signalStore: senderStore)
        let senderContext = SignalContext(storage: senderStorage)
        let senderKeyHelper = SignalKeyHelper(context: senderContext)

        let senderIdentityKeyPair = senderKeyHelper.generateIdentityKeyPair()
        let senderLocalRegistrationId = senderKeyHelper.generateRegistrationID()

        senderStore.identityKeyPair = senderIdentityKeyPair
        senderStore.localRegistrationID = senderLocalRegistrationId

        let senderSessionBuilder = SignalSessionBuilder(address: recipient, context: senderContext)
        senderSessionBuilder.processPreKeyBundle(recipientPreKeyBundle)
        let senderSessionCipher = SignalSessionCipher(address: recipient, context: senderContext)

        let senderMessage = "Hey I'm Bob!"
        let messageData = senderMessage.data(using: .utf8)!
        let senderCipheredText = senderSessionCipher.encryptData(messageData, error: nil)

        let recipientSessionCipher = SignalSessionCipher(address: sender, context: recipientContext)
        let decryptedMessage = recipientSessionCipher.decryptCipherText(senderCipheredText, error: nil)
        let decryptedString = String(data: decryptedMessage, encoding: .utf8)!

        print("Bob sent: \(senderMessage)")
        print("Alice received: \(decryptedString)")

        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

