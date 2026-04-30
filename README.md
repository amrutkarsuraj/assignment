#  Smart Recipe App (Flutter)

A production-grade Flutter application that suggests recipes based on **time, location, and user preferences**, with a fully **offline-first experience** and automated **CI/CD pipeline**.

---

##  Features

###  Smart Discovery & Search

* Integrated with **TheMealDB API**
* **Time-based suggestions**

    * Morning → Breakfast
    * Afternoon → Lunch
    * Evening → Dinner
*  **Location-based filtering**

    * Country-based cuisine prioritization
*  **Search with Debounce**

    * Prevents unnecessary API calls

---

###  Offline-First Experience

* Favorite recipes saved locally using **Hive**
*  Works without internet:

    * Cached recipes available offline
    * Favorites accessible anytime
*  Smart fallback:

    * API → Cache → Favorites → Empty state

---

###  Proactive Engagement

* Scheduled notifications:

    * Breakfast (8 AM)
    * Lunch (2 PM)
    * Dinner (8 PM)
* Dynamic recipe suggestions in notifications
* Graceful permission handling

---

##  Architecture

This project follows **Clean Architecture + Riverpod**

```
Presentation (UI)
    ↓
State (Riverpod - StateNotifier)
    ↓
Domain (UseCases)
    ↓
Data (Repository)
    ↓
Datasource (Remote + Local)
```

---

##  Tech Stack

* **Flutter 3.41.2**
* **Riverpod** (State Management)
* **Hive** (Local Storage)
* **Dio** (API calls)
* **Geolocator + Geocoding** (Location)
* **Flutter Local Notifications**
* **Cached Network Image**
* **GitHub Actions (CI/CD)**

---

##  UI/UX Highlights

*  Shimmer loading for async states
*  Animated favorite button
*  Hero animations (List → Detail)
* ️ Global error handling (Snackbar + UI)
*  Offline banner and fallback UI

---

##  Project Structure

```
lib/
 ├── core/
 │    ├── network/
 │    ├── services/
 │    ├── utils/
 │
 ├── features/
 │    └── recipe/
 │         ├── data/
 │         ├── domain/
 │         ├── presentation/
 │
 └── main.dart
```

---

## Setup Instructions

### 1 Clone the repository

```
git clone https://github.com/amrutkarsuraj/assignment.git
cd assignment
```

### 2 Install dependencies

```
flutter pub get
```

###  Run the app

```
flutter run
```

---

##  Run Tests

```
flutter test
```

---

## CI/CD Pipeline

GitHub Actions automatically:

1. Runs `flutter analyze`
2. Runs `flutter test`
3. Builds release APK
4. Uploads APK to **GitHub Releases**

 Workflow file:

```
.github/workflows/main.yml
```

---

##  Download APK

 Go to:
**GitHub → Releases → Download latest APK**

---

##  Permissions Used

* Location (for smart suggestions)
* Notifications (for meal reminders)

---

##  Key Decisions

* Used **Riverpod** for scalability and testability
* Implemented **offline-first architecture**
* Handled **API limitations** (MealDB categories) with intelligent mapping
* Prioritized **UX performance** with shimmer and caching

---

##  Screenshots

(Add screenshots here before submission)

---

##  Author

**Suraj Amrutkar**

---

##  Submission Checklist

* Functional requirements completed
* Offline-first implemented
* Clean architecture
* Riverpod state management
* CI/CD pipeline working
* APK available in GitHub Releases

---

##  Conclusion

This project demonstrates:

* Real-world Flutter architecture
* Performance optimization
* Offline-first design
* DevOps integration (CI/CD)

---

 Feel free to star the repo if you like it!
