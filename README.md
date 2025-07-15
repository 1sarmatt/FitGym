# FitGym

## Project Overview
FitGym is a fitness tracking application with a Go backend and a Flutter frontend.

---

## Prerequisites

### Backend (Go)
- Go 1.19 or newer
- PostgreSQL (for database)
- Docker & Docker Compose (optional, for containerized setup)

### Frontend (Flutter)
- Flutter SDK (3.x recommended)
- Dart SDK (comes with Flutter)
- Android Studio/Xcode (for mobile builds)
- Node.js (for some web builds, optional)

---

## Backend: Build & Run

### 1. Local Development
```bash
cd backend
# Copy and edit your environment variables if needed
cp .env.example .env
# Run the backend
go run ./cmd/main.go
```

### 2. Docker Compose (Recommended)
```bash
docker-compose up --build
```
This will start both the backend and the database.

---

## Frontend: Build & Run

### 1. Install Dependencies
```bash
cd frontend/fitgym
flutter pub get
```

### 2. Run on Web
```bash
flutter run -d chrome
```

### 3. Run on Android/iOS
- For Android:
  ```bash
  flutter run -d android
  ```
- For iOS (on macOS):
  ```bash
  flutter run -d ios
  ```

### 4. Build for Production
- Web:
  ```bash
  flutter build web
  ```
- Android:
  ```bash
  flutter build apk
  ```
- iOS:
  ```bash
  flutter build ios
  ```

---

## Environment Variables
- Backend: configure `.env` in the `backend/` directory.
- Frontend: update API endpoints in `frontend/fitgym/lib/src/common/api.dart` if needed.

---

## Useful Commands
- **Format Dart code:**
  ```bash
  flutter format .
  ```
- **Run tests:**
  ```bash
  flutter test
  ```
- **Check Go code:**
  ```bash
  go fmt ./...
  go test ./...
  ```

---


