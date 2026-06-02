# FFAN — Flutter Fast Access Navigator — Design Spec

**Date:** 2026-06-02
**Status:** Approved shape, drilling into Phase 1
**Author:** OlivineStudio614

---

## 1. Overview

FFAN (Flutter Fast Access Navigator) is a symbol-based **AAC** (Augmentative and
Alternative Communication) app: a communication tool for people who are non-speaking
or have limited speech (e.g. autism, developmental disabilities).

The defining principle is **motor planning**: every word lives in a fixed location on
a grid, so users build muscle memory. **Word locations never move** as vocabulary
grows — growth happens by revealing previously-hidden words, never by reshuffling.

### Target users

- **Communicator** — the person speaking through the app. Often a child or
  non-speaking person. Uses the grid only; is **never** forced through a login or
  any friction to communicate.
- **Caregiver / therapist** — manages vocabulary, customizes buttons, reviews
  on-device usage logs. No account required.

---

## 2. Name

**FFAN — Flutter Fast Access Navigator.** "Navigator" captures the fixed-location,
navigate-by-muscle-memory model.

> Note: FFAN is an original app. It must **never** reference or be marketed against
> any existing commercial AAC product. Research assets are not committed to the repo.

---

## 3. Tech Stack

| Concern | Choice | Why |
|---|---|---|
| Framework | Flutter / Dart | Given. |
| State management | **Riverpod** (codegen) | Testable, compile-safe, scales. |
| Persistence | **Drift (SQLite)** | Relational fit for vocab + custom buttons + usage logs. |
| TTS | **flutter_tts** | Native, offline, multilingual. |
| Routing | **go_router** | Declarative, standard. |
| Symbols | **ARASAAC** pictograms, curated core subset bundled offline | Free, openly licensed, attributed. |
| Analytics | **Firebase Analytics + Crashlytics** | Anonymized usage + crash reporting. |
| Architecture | Feature-first, layered (data / domain / presentation) + repository pattern | Isolated, testable units. |

**Target platform:** Tablet-first, iOS + Android. Phones supported as secondary
(responsive grid). Offline-first throughout.

---

## 4. Core Data Model (the motor-planning heart)

The differentiator is **fixed location**: a word never moves, even as vocabulary
grows. The model therefore separates *position* from *visibility*.

- **Vocabulary** — a named set with a fixed grid size (e.g. 7 columns × 12 rows) and
  a language. Composed of **Cells**.
- **Cell** — occupies an immutable `(row, col)`. One of:
  - **Word button** — `label`, `spokenMessage`, ARASAAC `symbolId`, category color,
    part-of-speech, optional `pronunciationOverride`, optional custom `imagePath`.
  - **Folder button** — navigates to a sub-grid (also fixed-layout).
  - **Reserved/empty** — holds a position for future growth or custom additions.
- **Visibility mask (vocabulary level)** — a per-cell `visible` flag layered over the
  vocabulary. Hiding a word **never** reshuffles others; positions are permanent.
  This is what enables progressive vocabulary growth and motor learning.
- **Message bar** — an ordered list of selected words with actions: **speak**,
  **backspace**, **clear**.

### Persistence sketch (Drift tables)

- `vocabularies` (id, name, language, rows, cols)
- `cells` (id, vocabularyId, row, col, type, label, spokenMessage, symbolId,
  categoryColor, partOfSpeech, pronunciationOverride, imagePath, targetFolderId)
- `levels` (id, vocabularyId, name) + `level_cell_visibility` (levelId, cellId, visible)
- `usage_log` (id, timestamp, eventType, cellId?, vocabularyId?) — **on-device only**

---

## 5. Analytics & Privacy Posture

- **Firebase Analytics + Crashlytics only.** Anonymized behavioral events
  (sessions, feature use, button-tap frequency) and crash reports.
- **No utterance content ever leaves the device.** Actual words/sentences spoken,
  custom button text, and language logs stay on-device.
- **No Firebase Auth, no Cloud sync, no Remote Config.**
- Custom vocabulary and settings: **local backup/restore** via file export/import.
- Because no sensitive content leaves the device, the GDPR/COPPA/HIPAA content-logging
  burden is avoided. Standard anonymized-analytics disclosure still applies.

---

## 6. Phased Roadmap

- **Phase 0 — Scaffold + Firebase foundation:** project setup, theming, ARASAAC asset
  pipeline, CI, base navigation, Firebase init (Analytics + Crashlytics), settings shell.
- **Phase 1 — MVP core loop:** one fixed core grid (~84 words) + category folders,
  tap-to-build message bar, native TTS (speak / backspace / clear), offline, tablet
  layout. Analytics instrumented here.
- **Phase 2 — Vocabulary leveling:** the visibility-mask system + preset levels
  (progressively reveal words while positions stay fixed).
- **Phase 3 — Customization:** edit buttons (label, message, pronunciation override,
  image from gallery/camera), add custom buttons into reserved cells, custom
  categories. Local only.
- **Phase 4 — Word Finder:** search a word, animate its fixed tap path (motor plan).
- **Phase 5 — Multi-language:** EN / FR / DE / ES vocabularies + matching TTS voice
  switching.
- **Phase 6 — Local data logging + usage analytics:** on-device language logs for the
  caregiver, file export, plus anonymized Firebase usage metrics surfaced.
- **Phase 7 — Accessibility (stretch):** switch-access / scanning, dwell selection,
  high-contrast themes.

**Cross-cutting from day one:** offline-first, large touch targets, high contrast,
anonymized analytics, settings screen.

---

## 7. Phase 1 (MVP) Detail

The first implementation slice. Goal: prove the core communication loop end to end.

**In scope:**
- A single bundled **core vocabulary** (~84 words) on a fixed grid with a handful of
  category folders.
- **Grid view:** fixed-position word buttons (ARASAAC symbol + label + category
  color) and folder buttons that navigate to sub-grids.
- **Message bar:** tapping a word appends it; folder taps navigate; **speak** reads
  the full utterance via `flutter_tts`; **backspace** removes the last word;
  **clear** empties it.
- **Offline**, tablet-optimized responsive layout.
- **Analytics events:** session start, word selected, message spoken, folder opened.

**Out of scope for Phase 1 (later phases):** leveling/hiding, customization/editing,
Word Finder, multi-language, logging UI, accessibility scanning, backup/restore.

**Definition of done:** A user can open the app, navigate folders, build a multi-word
message, and hear it spoken — fully offline — on a tablet, with crash reporting and
basic usage analytics live.

---

## 8. Testing Approach

- **Unit tests:** data model, repository, visibility-mask logic, message-bar logic.
- **Widget tests:** grid rendering at fixed positions, message-bar interactions.
- **Integration test:** the Phase 1 core loop (tap → build → speak), with `flutter_tts`
  behind an injectable interface so it can be faked in tests.
- TDD per feature (red → green → refactor).

---

## 9. Non-goals / YAGNI

- No cloud accounts, sync, or content upload.
- No Remote Config.
- No therapist web portal.
- No custom-drawn symbol set (use ARASAAC).
- No premium/cloud TTS voices in early phases (device-native only).

---

## 10. Open Questions

- Exact core-word set and grid dimensions for the bundled Phase 1 vocabulary
  (to be finalized during Phase 1 planning).
- Category color scheme (e.g. Fitzgerald-key-style coloring) — to confirm in Phase 1.
- Minimum supported OS versions for iOS/Android.
