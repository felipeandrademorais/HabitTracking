import SwiftUI
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {
        requestAuthorization()
    }
    
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification authorization granted")
            } else if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotification(for habit: Habit, completion: ((Bool, String?) -> Void)? = nil) {
        guard habit.notificationsEnabled,
              let notificationTime = habit.notificationTime else {
            completion?(false, "Notifications not enabled or notification time not set")
            return
        }
        
        // Request notification authorization if not already granted
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                print("[NotificationManager] Authorization not granted")
                completion?(false, "Notification authorization not granted")
                return
            }
            
            // Remove existing notifications for this habit
            self.removeNotifications(for: habit)
            print("[NotificationManager] Scheduling notification for habit: \(habit.nome)")
            
            let content = UNMutableNotificationContent()
            content.title = "Lembrete de Hábito"
            content.body = "Hora de realizar seu hábito: \(habit.nome)"
            content.sound = .default
            content.categoryIdentifier = "HABIT_REMINDER"
            
            let calendar = Calendar.current
            var components = calendar.dateComponents([.hour, .minute], from: notificationTime)
            components.timeZone = calendar.timeZone  // Set the user's local timezone
            print("[NotificationManager] Notification time components: \(components)")
            
            // Create notification trigger based on habit repetition type
            switch habit.repeticoes {
            case .daily:
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                if let nextTriggerDate = trigger.nextTriggerDate() {
                    print("[NotificationManager] Next daily trigger date: \(nextTriggerDate)")
                }
                self.scheduleNotification(with: content, trigger: trigger, for: habit) { success, error in
                    completion?(success, error)
                }
                
            case .weekly:
                var scheduledCount = 0
                let totalNotifications = habit.diasDoHabito.count
                
                for weekday in habit.diasDoHabito {
                    var triggerComponents = components
                    triggerComponents.weekday = weekday
                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
                    if let nextTriggerDate = trigger.nextTriggerDate() {
                        print("[NotificationManager] Next weekly trigger date for weekday \(weekday): \(nextTriggerDate)")
                    }
                    
                    self.scheduleNotification(with: content, trigger: trigger, for: habit) { success, error in
                        scheduledCount += 1
                        if scheduledCount == totalNotifications {
                            completion?(success, error)
                        }
                    }
                }
                
            case .monthly:
                let dayOfMonth = calendar.component(.day, from: habit.dataInicio)
                var triggerComponents = components
                triggerComponents.day = dayOfMonth
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
                if let nextTriggerDate = trigger.nextTriggerDate() {
                    print("[NotificationManager] Next monthly trigger date: \(nextTriggerDate)")
                }
                self.scheduleNotification(with: content, trigger: trigger, for: habit) { success, error in
                    completion?(success, error)
                }
            }
        }
    }
    
    private func scheduleNotification(with content: UNNotificationContent, trigger: UNNotificationTrigger, for habit: Habit, completion: ((Bool, String?) -> Void)? = nil) {
        let request = UNNotificationRequest(
            identifier: "habit_\(habit.id.uuidString)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("[NotificationManager] Error scheduling notification: \(error.localizedDescription)")
                completion?(false, error.localizedDescription)
            } else {
                print("[NotificationManager] Successfully scheduled notification for habit: \(habit.nome)")
                completion?(true, nil)
            }
        }
    }
    
    func removeNotifications(for habit: Habit) {
        let identifier = "habit_\(habit.id.uuidString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func updateNotifications(for habit: Habit) {
        if habit.notificationsEnabled {
            scheduleNotification(for: habit)
        } else {
            removeNotifications(for: habit)
        }
    }
}