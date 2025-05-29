import Foundation

@objc(LocalNotifications)
class LocalNotifications: CDVPlugin {

    @objc(coolMethod:)
    func coolMethod(command: CDVInvokedUrlCommand) {
        print("Something GOES here")
    }

}