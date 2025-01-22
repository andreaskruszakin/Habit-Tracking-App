import SwiftUI

struct Exercise {
    let name: String
    let icon: String
    let description: String
    let defaultReps: Int
    var setsRemaining: Int
    var progress: Double // Value between 0 and 1
}

// List of all exercises in the workout
let workoutExercises = [
    Exercise(
        name: "Push-Ups",
        icon: "figure.strengthtraining.traditional",
        description: "Start in a high plank. Lower your body by bending your elbows until chest nearly touches ground. Push back up.",
        defaultReps: 15,
        setsRemaining: 3,
        progress: 0.125
    ),
    Exercise(
        name: "Squats",
        icon: "figure.strengthtraining.functional",
        description: "Stand with feet shoulder-width apart. Lower your body as if sitting back into a chair. Keep chest up.",
        defaultReps: 20,
        setsRemaining: 3,
        progress: 0.25
    ),
    Exercise(
        name: "Plank",
        icon: "figure.core.training",
        description: "Hold a forearm plank position. Keep body straight from head to heels. Engage your core.",
        defaultReps: 45,
        setsRemaining: 3,
        progress: 0.375
    ),
    Exercise(
        name: "Mountain Climbers",
        icon: "figure.run",
        description: "Start in plank position. Alternate bringing knees toward chest in a running motion.",
        defaultReps: 30,
        setsRemaining: 3,
        progress: 0.5
    ),
    Exercise(
        name: "Lunges",
        icon: "figure.step.training",
        description: "Step forward with one leg. Lower until both knees are bent 90°. Push back to start. Alternate legs.",
        defaultReps: 24,
        setsRemaining: 3,
        progress: 0.625
    ),
    Exercise(
        name: "Burpees",
        icon: "figure.mixed.cardio",
        description: "Drop to plank, do a push-up, jump feet forward, then jump up with hands overhead.",
        defaultReps: 12,
        setsRemaining: 3,
        progress: 0.75
    ),
    Exercise(
        name: "Dips",
        icon: "figure.arms.open",
        description: "Using a chair, lower body by bending elbows. Push back up to straight arms.",
        defaultReps: 12,
        setsRemaining: 3,
        progress: 0.875
    ),
    Exercise(
        name: "High Knees",
        icon: "figure.highintensity.intervaltraining",
        description: "Run in place bringing knees up to hip level. Keep a quick pace. Land on balls of feet.",
        defaultReps: 40,
        setsRemaining: 3,
        progress: 1.0
    )
]

struct WorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showingWorkout: Bool
    @State private var currentExerciseIndex = 0
    @State private var currentReps: Int
    @State private var showingCompletion = false
    
    private var currentExercise: Exercise {
        workoutExercises[currentExerciseIndex]
    }
    
    private var isLastExercise: Bool {
        currentExerciseIndex == workoutExercises.count - 1
    }
    
    init(showingWorkout: Binding<Bool>) {
        self._showingWorkout = showingWorkout
        self._currentReps = State(initialValue: workoutExercises[0].defaultReps)
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                HStack {
                    Button(action: {
                        // Dismiss the duration picker first
                        NotificationCenter.default.post(name: NSNotification.Name("DismissDurationPicker"), object: nil)
                        // Then dismiss workout view
                        showingWorkout = false
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark.circle.fill")
                            Text("Cancel")
                        }
                        .foregroundStyle(.gray)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Button(action: {
                        moveToNextExercise()
                    }) {
                        HStack(spacing: 4) {
                            Text("Skip")
                            Image(systemName: "chevron.right.circle.fill")
                        }
                        .foregroundStyle(.gray)
                    }
                }
                
                // Exercise Icon
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(uiColor: .secondarySystemBackground))
                    .frame(height: 200)
                    .overlay(
                        Image(systemName: currentExercise.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.primary)
                    )
                
                // Exercise Info
                VStack(alignment: .leading, spacing: 16) {
                    // Sets remaining
                    HStack(spacing: 8) {
                        Text("\(currentExercise.setsRemaining)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        Text("sets remaining")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundStyle(.gray)
                    }
                    
                    // Exercise name
                    Text(currentExercise.name)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                    
                    // Exercise description
                    Text(currentExercise.description)
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundStyle(.gray)
                        .lineSpacing(4)
                }
                
                Spacer()
                
                // Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(uiColor: .secondarySystemBackground))
                            .frame(height: 4)
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(uiColor: .label))
                            .frame(width: geometry.size.width * currentExercise.progress, height: 4)
                    }
                }
                .frame(height: 4)
                .padding(.vertical, 16)
                
                // Repetitions control
                HStack {
                    Text("Repetitions")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            if currentReps > 1 { currentReps -= 1 }
                        }) {
                            Image(systemName: "minus")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.gray)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        Text("\(currentReps) x")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                            .foregroundStyle(.gray)
                            .contentTransition(.numericText())
                            .frame(minWidth: 40)
                        
                        Button(action: {
                            currentReps += 1
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.gray)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                // Next Set Button
                Button(action: {
                    if isLastExercise {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showingCompletion = true
                        }
                        // Update last workout date
                        UserDefaults.standard.set(Date(), forKey: "LastWorkoutDate")
                        // Dismiss after a delay to show completion animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            // Dismiss both views after showing completion
                            NotificationCenter.default.post(name: NSNotification.Name("DismissDurationPicker"), object: nil)
                            withAnimation {
                                showingCompletion = false
                                showingWorkout = false
                            }
                            dismiss()
                        }
                    } else {
                        moveToNextExercise()
                    }
                }) {
                    Text(isLastExercise ? "Finish Workout" : "Next Set")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(uiColor: .label))
                        .foregroundColor(Color(uiColor: .systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(30)
            
            if showingCompletion {
                // Background
                Color(uiColor: .systemBackground)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                // Completion overlay
                VStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.green)
                        .symbolEffect(.bounce, options: .repeating)
                    
                    Text("Workout Complete!")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    private func moveToNextExercise() {
        if currentExerciseIndex < workoutExercises.count - 1 {
            currentExerciseIndex += 1
            currentReps = workoutExercises[currentExerciseIndex].defaultReps
        }
    }
}

#Preview {
    WorkoutView(showingWorkout: .constant(true))
        .preferredColorScheme(.light)
} 