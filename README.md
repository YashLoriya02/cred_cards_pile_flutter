# Swipeable Vertical Carousel (Flutter + BLoC)

## Objective

This project implements a **swipeable vertical carousel** in Flutter, powered by data fetched from a mock API.
The carousel supports smooth animations with zero frame drops and handles multiple UI states dynamically.

---

## Architecture Overview

### **Architecture Pattern**

This project follows the **BLoC (Business Logic Component)** pattern for robust **state management** and **separation of concerns**.

### **Folder Structure**

```
lib/
│
├── data/
│   ├── models/
│   ├── remote/
│   ├── repository/
│
├── features/
│   └── bills/               # UI and logic for carousel feature
│       ├── view/            # Widgets and screens
│       ├── widgets/         # Bloc, events, and states
│
├── state/
│   └── bills_bloc.dart
│   └── bills_event.dart
│   └── bills_state.dart
│
├── utils/
│   ├── bills_util.dart       # Reusable constants
│
├── app.dart                 # Root app widget and navigation setup
└── main.dart                # Entry point of the application
```

---

## Features Implemented

* **Vertical swipeable carousel** with smooth animations.
* **Dynamic data loading** from mock API endpoints:

  * [2 items mock](https://jsonblob.com/api/jsonBlob/1425067032428339200)
  * [9 items mock](https://jsonblob.com/api/jsonBlob/1425066643679272960)
* **Tag text flipping animation**:

  * Bottom tag flips if flipper config is present.
  * Otherwise, footer text displays.
* **Responsive UI states**:

  * Handles `≤ 2 items` and `> 2 items` (10+ cards).
* **BLoC-based state management** ensures clean and optimized code.
* **Zero frame drops**.

---

## Running the Project

1. **Clone or unzip the repo**
2. **Get dependencies:**

   ```bash
   flutter pub get
   ```
3. **Run the app:**

   ```bash
   flutter run
   ```
4. **Build APK:**

   ```bash
   flutter build apk --release
   ```

---

## Tech Stack

* **Flutter SDK:** ≥3.0.0
* **State Management:** Flutter BLoC
* **Networking:** `http` package
* **Animation:** Flutter’s `AnimatedBuilder`, `PageView`, and `Transform` APIs

---

## Assumptions Made

* API endpoints return data in a consistent format (used /api/id endpoint for getting res in json format).
* Frame drop detection uses Flutter’s built-in performance overlay.
* Only vertical swiping is required (no horizontal movement).

---

## Deliverables

* Source code (zipped)
* Working APK
* Demo video showing:

  * 2-item state
  * > 2-item (9-item) state
  * Smooth animation and tag flipping behavior

---

## Notes

* **AI assistance (ChatGPT - GPT-5)** was used for documentation, README, code review and code optimization.
