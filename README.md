# Brazier 🔥

**Track the true monthly cost of your items and purchases.**

Brazier is a privacy-first, open-source Android application built with Flutter that helps you calculate and track the actual value and monthly cost of your physical belongings over time.

---

## ✨ Features

- **True Cost Calculation**: Compare your goal cost-per-month against your real usage rate.
- **Monthly Usage Review**: Swipe right if used, left if not used, with smooth cards, exit animations, and haptic feedback.
- **Usage Winstreaks**: Earn streak fire badges for consistent monthly item usage.
- **Overview & Statistics**: Analyze total spend, average monthly rates, category distributions, and goal reach milestones.
- **Custom Categories**: Create, edit, and organize items with custom icons, colors, and names.
- **100% Offline & Private**: Zero telemetry, zero ads, zero tracking, and no internet permission required. All data is stored locally using `SharedPreferences`.
- **Material 3 UI**: Full support for Dark Mode and Light Mode.

---

## 📱 Screenshots

| Items View | Monthly Review | Statistics Overview |
|:---:|:---:|:---:|
| *(Add screenshot)* | *(Add screenshot)* | *(Add screenshot)* |

---

## 🛠️ Building From Source

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.13+ or latest stable)
- Android SDK (API 34+)

### Build APK
```bash
git clone https://github.com/your-username/brazier.git
cd brazier
flutter pub get
flutter build apk --release
```
The compiled APK will be located at:
`build/app/outputs/flutter-apk/app-release.apk`

---

## 📦 F-Droid Submission

Brazier is built to comply strictly with [F-Droid Inclusion Policy](https://f-droid.org/docs/Inclusion_Policy/):
- **100% Free and Open Source Software (FOSS)**
- **No Proprietary Dependencies**: Free of Google Play Services, Firebase, or non-free SDKs.
- **No Anti-Features**: Zero ads, zero tracking, zero telemetry.

To submit Brazier to the official F-Droid repository:
1. Ensure your code is pushed to a public Git host (e.g. GitHub/GitLab).
2. Open a Merge Request against [fdroiddata](https://gitlab.com/fdroid/fdroiddata) with a build recipe referencing this repository.

---

## 📄 License

Brazier is released under the [GNU General Public License v3.0 (GPL-3.0)](LICENSE).
