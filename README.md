# Lisaps — To-Do List App

A to-do list app with a modern dark UI (purple-blue gradient), a progress
bar, All/Active/Done filters, and fade + slide animations whenever a task is
added, deleted, or checked off. Written entirely in Python using **Flet**
(Flet wraps Flutter, so the UI is smooth and looks identical on Windows and
Android/iOS from a single source code).

Tasks are saved automatically to `~/.lisaps/tasks.json` (your home folder),
so they persist even after closing the app.

---

## 1. Open the project in VS Code

1. Open the `Lisaps` folder in VS Code (`File > Open Folder...`).
2. Install the **Python** extension (Microsoft) if you don't have it yet.
3. Open a terminal in VS Code (`` Ctrl+` ``).

## 2. Install dependencies

```bash
python -m venv .venv
.venv\Scripts\activate        # Windows
# or: source .venv/bin/activate   # macOS/Linux

pip install -r requirements.txt
```

## 3. Run the app (development mode)

```bash
flet run main.py
```

This opens Lisaps as a desktop window. Every time you save `main.py` in VS
Code, the app automatically reloads (hot reload) — handy for tweaking the UI
and seeing results instantly.

To preview the mobile version without an emulator, run:

```bash
flet run --web main.py
```

then open the `localhost` link that appears in your phone's browser (same
WiFi as your laptop).

## 4. Build into a Windows app (.exe)

```bash
flet build windows
```

The output goes into the `build/windows/` folder as a standalone app that
runs without needing Python installed.

## 5. Build into an Android app (.apk)

Requires the Flutter SDK + Android SDK to be installed (check with
`flet doctor`, and follow the instructions it prints if anything is missing —
usually just installing Android Studio to get the Android SDK).

```bash
flet build apk
```

The resulting `.apk` will be in `build/apk/`, ready to copy to your phone and
install.

> The first build usually takes a while (downloading the Flutter engine).
> After that it's much faster.

## 6. Project structure

```
Lisaps/
├── main.py            # all the app code lives here
├── requirements.txt
└── README.md
```

## Ideas for further development

- Add reminders/notifications for task deadlines
- Add categories/color labels per task
- Switch from JSON storage to SQLite as tasks grow
- Add swipe-to-delete on mobile (Flet supports `GestureDetector`)