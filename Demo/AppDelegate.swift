import UIKit
import SignalProtocol
import SignalProtocolC

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
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
        let retrievedBobCipher = SignalCipherText(data: bobCipheredText.data, type: .message)
        let decryptedMessage = aliceSessionCipher.decryptCipherText(retrievedBobCipher, error: nil)
        let decryptedString = String(data: decryptedMessage, encoding: .utf8)!

        print("Bob sent: \(bobMessage)")
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

