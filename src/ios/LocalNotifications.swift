import Foundation
import UserNotifications

struct MyData: Codable {
    let title: String
    let subtitle: String
    let body: String
    let actions: [ActionStruct]
    let interval: TimeInterval
}

struct ActionStruct: Codable {
    let identifier: String
    let title: String
}

@objc(LocalNotifications)
class LocalNotifications: CDVPlugin {

    @objc(coolMethod:)
    func coolMethod(command: CDVInvokedUrlCommand) {
        print("Something GOES here")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error {
                print(error.localizedDescription)
            }
        }
        
        let content = UNMutableNotificationContent()
        
        let jsonData = "{\"title\":\"Some Title\",\"subtitle\": \"idk what\",\"body\":\"My notification stuff\",\"actions\":[{\"identifier\":\"accept\",\"title\":\"Accept\"}], \"interval\":5}";
        
          
        do {
            let jsonObj = jsonData.data(using: .utf8)!
            let jsonObject = try JSONSerialization.jsonObject(with: jsonObj, options: [])
            
            if let dictionary = jsonObject as? [String: Any] {
                let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
                print("asdkasd")
                let acts = dictionary["actions"] as? [[String: Any]]
                
                print(acts)
                print(dictionary["interval"] as? TimeInterval)
                
                var actionList: [UNNotificationAction] = []
                
                if let actions = acts {
                    for action in actions {
                        let identifier = action["identifier"] as! String
                        let actionTitle = action["title"] as! String
                        actionList.append(UNNotificationAction(identifier: identifier, title: actionTitle, options: [.foreground]))
                        print("Action: \(identifier ?? "") - \(actionTitle ?? "")")
                    }
                }
                
                let categoryIdentifier = "customCategory"
                let category = UNNotificationCategory(identifier: categoryIdentifier, actions: actionList, intentIdentifiers: [], options: [])
                
                UNUserNotificationCenter.current().setNotificationCategories([category])
                
                let content = UNMutableNotificationContent()
                
                let myInterval = dictionary["interval"] as! TimeInterval
                content.sound = UNNotificationSound.default
                content.title = dictionary["title"] as! String
                content.subtitle = dictionary["subtitle"] as! String
                content.body = dictionary["body"] as! String
                content.categoryIdentifier = "customCategory"

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: myInterval, repeats: false)

                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request)
                
                
            
                // Use the data as needed
            } else {
                print("Invalid JSON format")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }

        sendPluginResult(status: CDVCommandStatus_OK, message: "It ran", callbackId: command.callbackId)
    }
    

    func sendPluginResult(status: CDVCommandStatus, message: String = "", callbackId: String, keepCallback: Bool = false) {
        let pluginResult = CDVPluginResult(status: status, messageAs: message)
        pluginResult?.setKeepCallbackAs(keepCallback)
        self.commandDelegate!.send(pluginResult, callbackId: callbackId)
    }

}
