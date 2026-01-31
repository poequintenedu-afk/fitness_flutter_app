# Fitness Tracker App 🏃‍♂️

A beautiful, feature-rich Flutter fitness tracking application with smooth animations, step counting, calorie estimation, and personalized workout planning.

## ✨ Features

### 1️⃣ **Step Counter**
- **Real/Simulated Steps**: Button-based step counting for testing (sensor integration ready)
- **Daily Tracking**: Automatically tracks steps taken throughout the day
- **Dashboard Display**: Shows current day's step count prominently
- **Persistent Storage**: Steps saved automatically using SharedPreferences

### 2️⃣ **Calorie Estimation**
- **Smart Calculation**: Uses formula: Calories = Steps × 0.04
- **Auto-Update**: Calories burn amount updates automatically as steps increase
- **Display**: Shows calorie metrics on dashboard and activity log
- **Customizable**: Easy to adjust calorie calculation factor

### 3️⃣ **Dashboard (Home Screen)**
- **Real-time Stats**: 
  - Today's step count with large, animated display
  - Calories burned with fire icon
  - Daily goal progress with smooth progress bar
  - Current fitness level and workout plan
- **Quick Actions**: 
  - Add 100 steps button (simulated input)
  - Edit workout goal button
- **Beautiful UI**: Gradient backgrounds, smooth animations, responsive design

### 4️⃣ **Activity Log**
- **Daily Records**: Complete history of all activities
- **Information Stored**:
  - Date and day of week
  - Step count for the day
  - Calories burned
  - Associated workout plan
- **Timeline View**: Newest activities shown first
- **Detailed Cards**: Each day shows comprehensive fitness data

### 5️⃣ **Progress Tracking**
- **Weekly Charts**: Beautiful bar chart showing weekly progress
- **Statistics**:
  - Total weekly steps
  - Daily average steps
  - Daily breakdown with progress indicators
- **Visual Indicators**:
  - Color-coded bars (green for 10K+, blue for 7K+, orange for 5K+, red for less)
  - Smooth animations and transitions
  - Weekly progress bars
- **Motivation**: Daily motivational messages
- **FL Chart Integration**: Professional-grade chart visualization

### 6️⃣ **Workout Planning** ⭐ (Unique Feature)
- **Fitness Levels**: Choose from 3 levels
  - 👶 **Beginner**: 5,000 steps/day (Light walking)
  - 💪 **Intermediate**: 8,000 steps/day (Brisk walking & jogging)
  - 🔥 **Advanced**: 12,000 steps/day (Speed walking & running)
  
- **Customizable Goals**: 
  - Adjust daily step goal (3,000 - 20,000 steps)
  - Real-time slider with visual feedback
  - Recommended goals based on fitness level

- **Workout Plans**: Pre-configured plans for each level
  - Beginner: Morning Walk, Evening Stroll
  - Intermediate: Brisk Walk, Morning Jog + Walk
  - Advanced: Speed Walking Challenge, Running Session
  
- **Plan Details**: Each plan includes
  - Description and benefits
  - Target step count
  - Estimated duration
  - Specific exercise instructions

## 🎨 Design & Animations

### Smooth Animations Throughout:
- **Fade Transitions**: Smooth opacity changes for content appearance
- **Slide Animations**: Directional slides for screen navigation
- **Scale Animations**: Growing/shrinking effects for emphasis
- **Pulse Effects**: Subtle pulsing on important metrics
- **Progress Bar Animation**: Smooth filling of progress bars
- **Staggered List**: Sequential animation of list items

### Color Palette:
- **Primary**: Indigo (#6366F1)
- **Secondary**: Violet (#8B5CF6)
- **Accent Orange**: #F97316 (Calories)
- **Accent Cyan**: #06B6D4 (Activity Log)
- **Accent Green**: #10B981 (Progress)

### Modern UI Elements:
- Gradient backgrounds
- Rounded corners (12-16px border radius)
- Material Design 3 compliance
- Responsive layouts
- Smooth bottom navigation

## 📱 Screen Navigation

```
Dashboard (Home)
├── View today's stats
├── Add steps (simulated)
└── Edit fitness goal

Activity Log
├── View daily activity history
├── See past records
└── Track trends

Progress Tracking
├── Weekly bar chart
├── Daily statistics
├── Progress breakdown
└── Motivation messages

Workout Planning
├── Select fitness level
├── Customize daily goal
├── Choose workout plan
└── Save preferences
```

## 🛠️ Technical Stack

### Dependencies:
- **flutter**: SDK framework
- **provider**: State management
- **shared_preferences**: Local storage
- **fl_chart**: Beautiful charts (bar charts)
- **intl**: Date formatting

### Architecture:
- **Clean Architecture**: Separate screens, models, and providers
- **Provider Pattern**: Centralized state management
- **Model-View-ViewModel**: Clear separation of concerns
- **Persistent Storage**: Data saved locally

## 📦 File Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   └── activity_model.dart           # Data models for activities and goals
├── providers/
│   └── fitness_provider.dart         # State management with Provider
└── screens/
    ├── dashboard_screen.dart         # Home screen with stats
    ├── activity_log_screen.dart      # Activity history
    ├── progress_tracking_screen.dart # Weekly progress & charts
    └── workout_planning_screen.dart  # Goal & plan setup
```

## 🚀 Getting Started

### Prerequisites:
- Flutter SDK 3.10.7 or higher
- Dart 3.10.7 or higher

### Installation:

1. **Clone the repository**:
   ```bash
   cd fitness_app
   ```

2. **Get dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## 💾 Data Storage

Data is stored locally using SharedPreferences:
- **Daily Steps**: `steps_YYYY-MM-DD`
- **Activities**: `daily_activities` (JSON array)
- **Fitness Goal**: `fitness_goal` (JSON object)

## 🎯 Usage Guide

### First Time Setup:
1. Launch the app → Dashboard screen appears
2. Tap "Edit My Goal" or navigate to Workout Planning
3. Select your fitness level
4. Adjust your daily step goal (if desired)
5. Select a workout plan
6. Tap "Save My Goal"

### Daily Tracking:
1. On Dashboard, tap "Add 100 Steps" to simulate steps
2. Watch the animated progress bar fill
3. Check calories burned automatically calculate
4. View detailed activity log

### View Progress:
1. Tap "Progress" in bottom navigation
2. See weekly bar chart
3. Check daily statistics
4. Track improvement over time

### Modify Goals:
1. From Dashboard, tap "Edit My Goal"
2. Change fitness level or step goal
3. Select different workout plan
4. Save changes

## 🔧 Customization

### Adjust Calorie Calculation:
Edit in `fitness_provider.dart`:
```dart
static const double caloriesPerStep = 0.04; // Modify this value
```

### Add Custom Workout Plans:
Edit in `activity_model.dart`:
```dart
static final Map<String, List<WorkoutPlan>> plans = {
  'YourLevel': [
    WorkoutPlan(...)
  ]
};
```

### Change Color Scheme:
Modify in `main.dart`:
```dart
primaryColor: Color(0xFF6366F1), // Change primary color
```

## 🔮 Future Enhancements

- Real sensor integration (pedometer)
- Google Fit/Apple HealthKit integration
- Social sharing features
- Achievement badges
- Custom reminders
- Advanced analytics
- Wearable app support
- Multiple user profiles
- AI-powered recommendations

## 📄 License

This project is open source and available under the MIT License.

## 👨‍💻 Author

Created as a comprehensive Flutter fitness tracking solution with beautiful UI and smooth animations.

---

**Happy Tracking! 💪🏃‍♀️**
