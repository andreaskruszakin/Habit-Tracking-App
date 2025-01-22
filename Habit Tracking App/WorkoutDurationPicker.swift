import SwiftUI

struct WorkoutDurationPicker: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMinutes: Int = 30
    @Binding var showingWorkout: Bool
    let availableMinutes = [15, 30, 45]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text("How much")
                        .foregroundStyle(.gray.opacity(0.7))
                    Image(systemName: "clock")
                        .font(.system(size: 32))
                    Text("time")
                }
                
                HStack(spacing: 8) {
                    Text("do you have today?")
                        .foregroundStyle(.gray.opacity(0.7))
                }
            }
            .font(.system(size: 32, design: .rounded))
            .fontWeight(.semibold)
            
            // Time Picker
            VStack {
                Picker("Duration", selection: $selectedMinutes) {
                    ForEach(availableMinutes, id: \.self) { minutes in
                        Text("~\(minutes) minutes")
                            .font(.system(size: 24, design: .rounded))
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 150)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            
            Spacer(minLength: 4)
            
            // Start Button
            Button(action: {
                showingWorkout = true
            }) {
                Text("Start")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.black)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.bottom, 4)
        }
        .padding(.top, 48)
        .padding(.horizontal, 32)
        .padding(.bottom, 16)
        .fullScreenCover(isPresented: $showingWorkout) {
            WorkoutView(showingWorkout: $showingWorkout)
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("DismissDurationPicker"))) { _ in
            dismiss()
        }
    }
}

#Preview {
    WorkoutDurationPicker(showingWorkout: .constant(false))
} 