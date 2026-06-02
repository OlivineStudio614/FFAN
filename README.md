# FFAN — Flutter Fast Access Navigator

FFAN is an offline-first **AAC** (Augmentative and Alternative Communication) app for
people who are non-speaking or have limited speech. It presents a symbol-based grid
where tapping words builds a spoken message via on-device text-to-speech.

Its core principle is **motor planning**: every word lives in a fixed location, so
users build muscle memory over time. Word positions never move as vocabulary grows —
growth happens by revealing previously hidden words, never by reshuffling. Built
tablet-first with Flutter, fully usable offline, with anonymized usage analytics and
crash reporting (**no communication content ever leaves the device**).

## Status

Early planning. See the design spec in
[`docs/superpowers/specs/`](docs/superpowers/specs/) for the full architecture and
phased roadmap.

## Tech stack

- **Flutter / Dart**
- **Riverpod** — state management
- **Drift (SQLite)** — local persistence
- **flutter_tts** — on-device text-to-speech
- **go_router** — navigation
- **ARASAAC** — openly-licensed pictogram symbols
- **Firebase Analytics + Crashlytics** — anonymized usage + crash reporting

## Roadmap (phases)

0. Scaffold + Firebase foundation
1. **MVP** — fixed core grid + message bar + TTS (offline)
2. Vocabulary leveling (visibility-mask growth)
3. Customization (edit/add buttons, images)
4. Word Finder (animated motor-plan path)
5. Multi-language (EN / FR / DE / ES)
6. Local data logging + usage analytics
7. Accessibility (switch-access / scanning) — stretch

## Privacy

Communication content stays on-device. Firebase receives only anonymized behavioral
metrics and crash reports.
