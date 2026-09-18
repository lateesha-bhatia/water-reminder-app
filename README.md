Water Reminder App
A lightweight, frameless, and transparent Windows desktop application built with Flutter. This resident background app gently reminds you to hydrate by bringing an animated character onto your screen every hour.

<img width="297" height="475" alt="image" src="https://github.com/user-attachments/assets/52b8c7bd-ccf1-43bb-bfdb-cc7c76154557" />

Features
Frameless & Transparent UI: Blends seamlessly into your Windows desktop environment without intrusive window borders or shadows.

Always-on-Top: Ensures the reminder is visible over your active windows when it is time to hydrate.

Interactive Animations: Features custom intro and outro GIF animations that trigger based on user interaction.

Snooze Functionality: Built-in quick snooze buttons (5 minutes and 10 minutes) to delay the reminder if you are in the middle of a task.

Resource Efficient: Hides itself completely between reminders, utilizing a lightweight background timer instead of consuming constant UI rendering resources.

Tech Stack
Framework: Flutter (Desktop / Windows)

Packages Used:

window_manager: Handles frameless, transparent, and always-on-top window states.

gif_view: Manages optimized, single-play frame rendering for the animated character assets.

Getting Started
Prerequisites
Flutter SDK (Version 3.0 or higher)

Windows 10 or 11

Visual Studio 2022 (with "Desktop development with C++" workload installed for Windows compilation)
