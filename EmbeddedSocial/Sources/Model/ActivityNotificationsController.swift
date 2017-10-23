//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


final class ActivityNotificationsController {
    weak var notificationUpdater: NotificationsUpdater?
    let interval: TimeInterval
    private var timer: Timer?
    
    @objc private func handleTimerTick() {
        notificationUpdater?.updateNotifications()
    }

    private func buildTimer() -> Timer {
        return Timer.scheduledTimer(timeInterval: interval,
                             target: self,
                             selector: #selector(handleTimerTick),
                             userInfo: nil,
                             repeats: true)
    }
    
    init(interval: TimeInterval = Constants.Notifications.pollInterval) {
        self.interval = interval
    }
    
    func start() {
        timer = buildTimer()
    }
    
    // Must be called before deinit because Timer retains object
    func finish() {
        timer?.invalidate()
        timer = nil
    }
}
