//
//  NotificationsUp$.swift
//  weatherApp
//
//  Created by Ahassouni, Nadia on 20/03/2018.
//  Copyright © 2018 Ahassouni, Nadia. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Notifications{
    var notifToken: RLMNotificationToken? = nil
    var notificationRunLoop: CFRunLoop? = nil
    
    func initNotificationToken(){
        DispatchQueue.global(qos: .background).async {
            // current runloop reference needed to stop the running
            self.notificationRunLoop = CFRunLoopGetCurrent()
            
            CFRunLoopPerformBlock(self.notificationRunLoop, CFRunLoopMode.defaultMode.rawValue){
                _ = try! Realm()
                
                let xx = DBManager.sharedInstance.getCitiesFromDb()
                
                self.notifToken = xx.observe { [weak self] (changes: RealmCollectionChange) in
                    switch changes {
                    case .initial:
                        print ( " ------> initial ")
                        let x  = self?.notifToken
                        print ( "jkhlkj" , x ?? "<#default value#>")
                        
                    case .update(_, let deletions, let insertions, let modifications):
                        print ("-----> del " , deletions.count)
                        print ("-----> inse " , insertions.count)
                        print ("-----> modi " , modifications.count)
                    case .error(let error):
                        fatalError("-----> \(error)")
                    }
                }
            }
            CFRunLoopRun()
        }
    }
    deinit {
        self.notifToken?.invalidate()
        if let runLoop = notificationRunLoop {
            CFRunLoopStop(runLoop)
        }
    }
}


