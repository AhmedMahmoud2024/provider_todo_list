# Advanced Task Management Application (Provider State Architecture)

Welcome to the **Week 6 Core Milestone** of Phase 2 for the DevelopersHub Internship program. This branch features an enterprise-grade, architecture-driven **Task Management System** built fully on top of the **Provider Pattern**. 

This ecosystem serves as a direct architectural evolution from our baseline **To-Do Provider App**, expanding structural complexity to handle full **CRUD Operations**, advanced reactive state hydration, and micro-UX component layers without relying on a single native `setState()` call.

---

## 🎯 The Evolutionary Roadmap: From To-Do to Task Management

1. **The To-Do Foundation:** We initiated state isolation by purging inline state management from a simple To-Do tracker, migrating data into a centralized `TodoProvider` container.
2. **The Task Management Upgrade:** We escalated the architecture to manage complex real-world data interactions. The system now seamlessly coordinates dynamic state changes across nested presentation interfaces including **Modal Bottom Sheets**, asynchronous input pipelines, and transactional **Alert Dialogs**.

---

## 🧠 Architectural Problem-Solving & Implementation Details

To achieve absolute decoupling, the application completely encapsulates state transformations within the Business Logic Layer (`TaskProvider`) and hooks into the presentation grid using highly optimized consumption channels:

### 1. State Encapsulation (Create, Toggle, Update, Delete)
- **Create (`addTask`):** Triggered imperatively from an input sheet. It captures text inputs, validates bounds, generates unique cryptographic timestamps as IDs, and injects the payload into a strictly `private` tracking list before announcing updates via `notifyListeners()`.
- **Toggle (`toggleTaskStatus`):** Intercepts check actions and flips completion states safely by matching indices, maintaining state data integrity.
- **Update (`updateTaskTitle`):** Leverages an immutable `.copyWith()` scheme on the underlying Data Model, mutating text titles securely without destroying historical reference structures.
- **Delete (`deleteTask`):** Dynamically evicts target nodes from the memory matrix based on strict ID constraints, instantly updating the underlying list view.

### 2. High-Performance UI Integration (Bottom Sheets & Dialogs)
- **Persistent Bottom Sheet Input:** By using `context.read<TaskProvider>()` inside the Bottom Sheet's submission buttons, the layout fires dispatch signals *silently*, ensuring that the FloatingActionButton and the sheet itself bypass expensive rendering cycles during layout injections.
- **Transactional Alert Dialogs (Inline Editing):** Built a specialized editing gate utilizing local text controllers encapsulated safely inside native `showDialog` streams. Changes are pushed directly into the provider pipeline only when explicit commits are captured.

---

## 🏗️ Folder Directory & Decoupled Clean Architecture
The codebase strictly segregates core structural duties to ensure zero layout-to-logic pollution:

```text
lib/
│
├── models/
│   └── task_model.dart          # Immutable Blueprint & Data Schemas (.copyWith enabled)
│
└── presentation/
├── providers/
│   └── task_provider.dart       # Core State Machine & Synchronous CRUD Operations
    ├── widgets/
    │   └── task_item_tile.dart  # Contextual Reactive Component with Implicit Tween Animations
    └── screens/
        └── task_list_screen.dart # Pure Presentation View Grid governed by context.watch
