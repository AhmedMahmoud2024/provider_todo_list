# Geographic Task Manager (Cross-Platform Geofencing App) 🚀📍

A modern, production-ready, **offline-first Task Management application** built with **Flutter** and **Riverpod** using strict **Clean Architecture** principles. This project originally started as an internship capstone project at **DevelopersHub Corporation** and was personally expanded and enhanced to support full cross-platform capabilities (**Mobile & Web**) alongside **Smart Geofencing Notifications**.

---

## 🧠 The Engineering Journey: Challenges & Solutions

Building a robust, cross-platform architecture that bridges Flutter with native platform components came with its own set of real-world challenges. Here is how those engineering hurdles were encountered and resolved:

### 1. The Native Android Configuration Hurdle (Kotlin DSL vs. Groovy)
* **The Struggle:** Integrating modern dependencies like `flutter_local_notifications` broke the Android build phase. The app threw strict Gradle exceptions requiring **Core Library Desugaring** to support newer Java features on legacy systems.
* **The Solution:** Navigated directly into the host side and refactored the build configurations. Since modern Flutter structures utilize **Kotlin DSL (`build.gradle.kts`)** rather than standard Groovy, the syntax had to be strictly adjusted to Kotlin's type-safe configurations (using explicit assignments `isCoreLibraryDesugaringEnabled = true` and declaring native `dependencies {}` blocks from scratch).

### 2. Dependency Version Incompatibility
* **The Struggle:** After updating the Gradle scripts, the compiler rejected the setup, revealing a strict version mismatch: the notifications plugin strictly demanded `desugar_jdk_libs` version `2.1.4` or above, while the system cache was defaulting to `2.0.4`.
* **The Solution:** Traced the compiler stack logs, directly upgraded the artifact dependency version to `2.1.4` within the Kotlin DSL script, cleared the build cache using `flutter clean`, and successfully compiled a clean build.

### 3. Type-Safe Parameter Enforcement in Plugins
* **The Struggle:** Encountered compilation errors (`Too many positional arguments` / `The named parameter 'id' is required`) when invoking the native notification methods. 
* **The Solution:** Dove into the plugin's source code architecture to analyze its API interface. Discovered that the `.show()` method enforces strict **Named Parameters** enclosed in curly braces `{}`. Refactored the business logic within the state notifier to explicitly pass bound variables (`id: task.id.hashCode`, `title: ...`, `body: ...`), eliminating the syntax errors completely.

---

## ✨ Features

- **Full CRUD Operations**: Create, Read, Update, and Delete tasks with fluid, responsive animations.
- **True Cross-Platform Support**: Fully optimized and responsive UI that runs seamlessly on both **Mobile (Android/iOS)** and **Modern Web Browsers (Chrome, Safari, etc.)**.
- **State Management**: Built using reactive, scalable state management with **Riverpod StateNotifier** (no `build_runner` required for clean, fast development cycles).
- **Offline-First Persistence**: Local storage and cache management utilizing `SharedPreferences`, executing 100% offline.
- **Smart Geofencing**: Real-time live location tracking via `Geolocator` that triggers immediate context alerts when a user approaches within 200 meters of an uncompleted task.
- **Dual-Mode Alerts**: 
  - **On Mobile**: Triggers a native system alert directly into the Android status bar using `flutter_local_notifications`.
  - **On Web**: Triggers a beautiful, contextual responsive in-app alert window.
- **Interactive Mapping**: Seamless task-location binding utilizing an open-source mapping engine (`Flutter Map` & `OpenStreetMap`).

---

## 🏗️ Architectural Pattern

The project strictly follows **Clean Architecture** and SOLID design principles, isolating the application into decoupled layers:

```text
lib/
│
├── data/
│   └── models/          # UpdatedTaskModel with JSON serialization & data binding
│
├── presentation/
│   ├── riverpod/        # Business Logic, Streams, & Geofencing via StateNotifier Providers
│   └── screens/         # UI View Layer (Responsive List View, Add/Edit Screen, Map View)
│
└── main.dart            # Application Root wrapped in ProviderScope