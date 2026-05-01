# 🧵 Memory Weave

> _Weave Your Life's Story._

A beautifully crafted Flutter app for preserving and reliving your most cherished memories — powered by Firebase, SQLite, and AI-driven insights.

---

## ✨ Features

- 🔐 **Authentication** — Email/Password & Google Sign-In via Firebase Auth
- 🏠 **Home** — Browse your active timelines with live search filtering
- 🗓️ **Timeline** — A swipeable, chronological view of all your memories with delete support
- 🧠 **Memories** — Filter by type (Photos, Voice, Stories, Notes) with real-time search
- ➕ **Add Memory** — Capture a title, date, narrative, and photo from your gallery
- 👤 **Profile** — Edit your name & job title, manage settings, view your memory stats
- 💡 **AI Insights** — Dynamic cards generated from your real memory data (weekly report, streaks, patterns)
- 🎨 **Onboarding** — Smooth animated onboarding with SharedPreferences persistence

---

## 🛠️ Tech Stack

| Layer            | Technology                                                                                 |
| ---------------- | ------------------------------------------------------------------------------------------ |
| Framework        | Flutter                                                                                    |
| Language         | Dart                                                                                       |
| Auth             | Firebase Authentication                                                                    |
| Cloud DB         | Cloud Firestore                                                                            |
| Local DB         | SQLite (sqflite)                                                                           |
| State Management | Provider                                                                                   |
| Local Storage    | SharedPreferences                                                                          |
| UI Extras        | shimmer, google_nav_bar, timeline_tile, smooth_page_indicator, dotted_border, cherry_toast |

---

## 🗂️ Project Structure

```
lib/
├── Authentication/
│   ├── login.dart
│   └── signup.dart
├── data/
│   └── timeline_data.dart
├── models/
│   ├── memory_model.dart
│   ├── onboardingData.dart
│   └── timeline_model.dart
├── providers/
│   └── Auth_provider.dart
├── screens/
│   ├── home.dart
│   ├── TimelineScreen.dart
│   ├── MemoriesScreen.dart
│   ├── ProfileScreen.dart
│   ├── AddScreen.dart
│   ├── onboarding_screen.dart
│   ├── splash_screen.dart
│   └── auth_wrapper.dart
├── Sqldb/
│   └── sqldb.dart
├── themes/
│   └── colors.dart
├── utils/
│   └── insight_engine.dart
├── widgets/
│   ├── AiCard.dart
│   ├── TimelineCard.dart
│   ├── MemoryBigCard.dart
│   ├── MemorySmallCard.dart
│   ├── AddPhoto.dart
│   ├── PulsingDot.dart
│   ├── ScrollAnimator.dart
│   └── ...
└── main.dart
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- A Firebase project with **Authentication** and **Firestore** enabled

### Installation

1. **Clone the repo**

   ```bash
   git clone https://github.com/your-username/memory-weave.git
   cd memory-weave
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Setup Firebase**
   - Create a project at [Firebase Console](https://console.firebase.google.com)
   - Enable Email/Password and Google Sign-In under Authentication
   - Enable Cloud Firestore
   - Download `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 🔒 Firebase Firestore Rules (recommended)

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## 📦 Key Dependencies

```yaml
dependencies:
  firebase_core:
  firebase_auth:
  cloud_firestore:
  google_sign_in:
  provider:
  sqflite:
  path:
  shared_preferences:
  image_picker:
  shimmer:
  cherry_toast:
  google_nav_bar:
  timeline_tile:
  smooth_page_indicator:
  dotted_border:
  visibility_detector:
  google_fonts:
```

---

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you'd like to change.

---

## 👨‍💻 Author

Built with ❤️ by **[Abdallah Saad]**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat&logo=linkedin)](https://www.linkedin.com/in/abdallah-saad-flutter/)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black?style=flat&logo=github)](https://github.com/abdon2006)
