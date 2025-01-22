import SwiftUI

struct HomeView: View {
    @State private var streakCount: Int = 7
    @State private var restDays: Int = 3
    let fallbackDays: Int = 2
    @State private var usedFallbacks: Int = 0
    @State private var showingDurationPicker = false
    @State private var showingRestDaysPicker = false
    @State private var showingWorkout = false
    @State private var selectedDate = Date()
    @State private var lastWorkoutDate: Date? = nil
    @State private var showingFallbackHelp = false
    @State private var workoutCompletedToday = false
    
    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Start week on Monday
        return calendar
    }
    
    private var currentMonth: [Date] {
        let interval = calendar.dateInterval(of: .month, for: selectedDate)!
        let days = calendar.generateDates(inside: interval, matching: DateComponents(hour: 0, minute: 0, second: 0))
        return days
    }
    
    private var weeks: [[Date]] {
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        let weekdayOffset = weekday >= 2 ? weekday - 2 : 6
        
        var dates: [Date] = Array(repeating: firstDayOfMonth, count: weekdayOffset)
            .enumerated()
            .map { index, _ in
                calendar.date(byAdding: .day, value: -weekdayOffset + index, to: firstDayOfMonth)!
            }
        
        dates += currentMonth
        
        let remainingDays = 42 - dates.count // 6 weeks × 7 days = 42
        if remainingDays > 0 {
            let lastDate = dates.last!
            dates += (1...remainingDays).map { calendar.date(byAdding: .day, value: $0, to: lastDate)! }
        }
        
        return dates.chunked(into: 7)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Streak Count
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(streakCount)")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .foregroundStyle(.green)
                Text("Day Streak")
                    .font(.system(size: 36, weight: .medium, design: .rounded))
            }
            .padding(.bottom, -8)
            
            Divider()
                .padding(.vertical, 8)
            
            // Workout Status
            VStack(alignment: .leading, spacing: 4) {
                // First line
                HStack(spacing: 8) {
                    Text("Today, a")
                        .foregroundStyle(.secondary)
                    HStack(spacing: 8) {
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.system(size: 32))
                        Text("workout")
                    }
                    .foregroundStyle(.white)
                }
                
                // Second line
                HStack(spacing: 8) {
                    Text("is scheduled. You still")
                        .foregroundStyle(.secondary)
                }
                
                // Third line
                HStack(spacing: 8) {
                    Text("have")
                        .foregroundStyle(.secondary)
                    Button {
                        showingRestDaysPicker = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "pause.circle.fill")
                                .font(.system(size: 32))
                            HStack(spacing: 4) {
                                Text("\(restDays)")
                                    .contentTransition(.numericText())
                                Text("rest days")
                            }
                        }
                        .foregroundStyle(.white)
                    }
                }
                
                // Fourth line
                HStack(spacing: 8) {
                    Text("and")
                        .foregroundStyle(.secondary)
                    Button {
                        withAnimation {
                            showingFallbackHelp = true
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 32))
                            Text("\(fallbackDays - usedFallbacks) fallback")
                        }
                        .foregroundStyle(.white)
                    }
                    Text("left.")
                        .foregroundStyle(.secondary)
                }
            }
            .font(.system(size: 32, design: .rounded))
            .fontWeight(.semibold)
            
            // Fallback Help Popup
            .sheet(isPresented: $showingFallbackHelp) {
                VStack {
                    Spacer(minLength: 32)
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(uiColor: .secondarySystemBackground))
                        .overlay(
                            (Text("Fallbacks").fontWeight(.bold).foregroundColor(.primary) +
                            Text(" are your safety net to protect your streak if you miss a workout or stretching session. Start with 2 fallbacks, if used, your streak stays alive. Run out, and your streak resets to 0.")
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary))
                                .font(.system(size: 20, design: .rounded))
                                .padding(24)
                                .multilineTextAlignment(.center)
                        )
                        .padding(.horizontal, 32)
                        .frame(height: 220)
                    Spacer(minLength: 24)
                }
                .presentationDetents([.height(280)])
                .presentationCornerRadius(32)
                .background(Color(uiColor: .systemBackground))
            }
            
            Divider()
                .padding(.vertical, 8)
            
            // Calendar Grid
            VStack(spacing: 8) {
                HStack(spacing: 16) {
                    ForEach(["M", "T", "W", "T", "F", "S", "S"], id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                ForEach(weeks, id: \.first) { week in
                    HStack(spacing: 8) {
                        ForEach(week, id: \.self) { date in
                            let isToday = calendar.isDate(date, inSameDayAs: Date())
                            let isCurrentMonth = calendar.isDate(date, equalTo: selectedDate, toGranularity: .month)
                            let isRestDay = isRestDayForDate(date)
                            let isWorkoutCompleted = isWorkoutCompletedForDate(date)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(isToday ? Color.green : (isCurrentMonth ? Color.green.opacity(0.2) : Color.gray.opacity(0.1)))
                                    .frame(height: 32)
                                
                                if isRestDay && isCurrentMonth {
                                    Image(systemName: "pause.circle.fill")
                                        .font(.system(size: 16))
                                        .foregroundStyle(.white)
                                } else if isWorkoutCompleted && isCurrentMonth {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 16))
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            // Start Workout Button
            Button(action: {
                handleWorkoutStart()
            }) {
                Text(workoutCompletedToday ? "Workout Completed" : "Start Workout")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(workoutCompletedToday ? .gray : .white)
                    .foregroundColor(workoutCompletedToday ? .white : .black)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .disabled(workoutCompletedToday)
        }
        .padding(32)
        .background(Color(uiColor: .systemBackground))
        .onAppear {
            checkMissedWorkout()
            checkTodayWorkout()
        }
        .sheet(isPresented: $showingDurationPicker) {
            WorkoutDurationPicker(showingWorkout: $showingWorkout)
                .presentationDetents([.height(500)])
                .presentationCornerRadius(32)
        }
        .sheet(isPresented: $showingRestDaysPicker) {
            RestDaysPicker(restDays: $restDays)
                .presentationDetents([.height(500)])
                .presentationCornerRadius(32)
        }
    }
    
    private func handleWorkoutStart() {
        if !workoutCompletedToday {
            showingDurationPicker = true
        }
    }
    
    private func checkMissedWorkout() {
        guard let lastWorkout = lastWorkoutDate else { return }
        
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        // Check if we missed a workout yesterday
        if !calendar.isDate(lastWorkout, inSameDayAs: today) &&
           !calendar.isDate(lastWorkout, inSameDayAs: yesterday) &&
           !isRestDayForDate(yesterday) {
            // Missed a workout on a non-rest day
            if fallbackDays - usedFallbacks > 0 {
                // Use a fallback
                usedFallbacks += 1
            } else {
                // Reset streak if no fallbacks left
                streakCount = 0
            }
        }
    }
    
    private func isRestDayForDate(_ date: Date) -> Bool {
        // Only process current month dates
        guard calendar.isDate(date, equalTo: selectedDate, toGranularity: .month) else {
            return false
        }
        
        // Get the week of the month for the date
        let weekOfMonth = calendar.component(.weekOfMonth, from: date)
        let weekday = calendar.component(.weekday, from: date)
        
        // Calculate rest days distribution based on total rest days
        switch restDays {
        case 1:
            // One rest day per week on Wednesday
            return weekday == 4
        case 2:
            // Two rest days per week on Tuesday and Friday
            return weekday == 3 || weekday == 6
        case 3:
            // Three rest days per week on Monday, Wednesday, and Friday
            return weekday == 2 || weekday == 4 || weekday == 6
        case 4:
            // Four rest days per week on Monday, Tuesday, Thursday, and Saturday
            return weekday == 2 || weekday == 3 || weekday == 5 || weekday == 7
        case 5:
            // Five rest days per week, excluding Wednesday and Sunday
            return weekday != 4 && weekday != 1
        case 6:
            // Six rest days per week, only workout on Sunday
            return weekday != 1
        case 7:
            // Rest every day
            return true
        default:
            // No rest days
            return false
        }
    }
    
    private func isWorkoutCompletedForDate(_ date: Date) -> Bool {
        guard let lastWorkout = lastWorkoutDate else { return false }
        return calendar.isDate(date, inSameDayAs: lastWorkout)
    }
    
    private func checkTodayWorkout() {
        if let lastWorkoutDateData = UserDefaults.standard.object(forKey: "LastWorkoutDate") as? Date {
            lastWorkoutDate = lastWorkoutDateData
            workoutCompletedToday = calendar.isDate(lastWorkoutDateData, inSameDayAs: Date())
        }
    }
}

// Helper extensions
extension Calendar {
    func generateDates(inside interval: DateInterval, matching components: DateComponents) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(startingAfter: interval.start,
                      matching: components,
                      matchingPolicy: .nextTime) { date, _, stop in
            if let date = date {
                if date <= interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return dates
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

struct RestDaysPicker: View {
    @Binding var restDays: Int
    @Environment(\.dismiss) private var dismiss
    let availableDays = Array(0...7)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text("How many")
                        .foregroundStyle(.secondary)
                    Image(systemName: "pause.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(.primary)
                    Text("rest")
                }
                
                HStack(spacing: 8) {
                    Text("days do you need?")
                        .foregroundStyle(.secondary)
                }
            }
            .font(.system(size: 32, design: .rounded))
            .fontWeight(.semibold)
            
            // Days Picker
            VStack {
                Picker("Rest Days", selection: $restDays) {
                    ForEach(availableDays, id: \.self) { days in
                        Text("\(days) days")
                            .font(.system(size: 24, design: .rounded))
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 150)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            
            Spacer(minLength: 4)
            
            // Save Button
            Button(action: {
                dismiss()
            }) {
                Text("Save")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.white)
                    .foregroundColor(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.bottom, 4)
        }
        .padding(.top, 48)
        .padding(.horizontal, 32)
        .padding(.bottom, 16)
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview {
    HomeView()
} 
