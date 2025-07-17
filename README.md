# FitGym 🏋️‍♂️

FitGym is a simple web-based fitness tracking application built with Go, Dart Flutter and PostgreSQL. It allows users to log and manage their workout routines including exercises, sets, reps, and weight.

## Features

* 📝 Create and manage workouts
* 🏋️ Add exercises with sets, reps, and weights
* 📊 Track workout history
* ✅ Simple and clean UI
* 🔐 Secure login system

## Tech Stack

* **Backend:** Go
* **Frontend:** Dart, Flutter
* **Database:** PostgresSQL

## Swagger documentation

http://193.148.58.102:8080/swagger/index.html

## Installation

Before running copy .env.example to frontend/fitgym and backend directoryes and rename it to .env.

### using Docker compose 

```
docker compose up --build -d
```

### Manually
- **For running backend part**

```
cd backend
go mod tidy
go run cmd/main.go
```
- **For running frontend part**

```
cd frontend/fitgym
flutter pub get
flutter run
```

## Contributing

Contributions are welcome! Feel free to fork this repository, make changes, and open a pull request.

## Screenshots of the main features

![login page](ReadmeData/login%20page.png)
![login image](ReadmeData/login%20image.png)
![Register page](ReadmeData/register%20page.png)
![Profile filling](ReadmeData/Proflie%20filling.png)
![Light theme](ReadmeData/Light%20theme.png)
![Rus](ReadmeData/russian.png)
![workout log](ReadmeData/workout%20log.png)
![friends](ReadmeData/Frinds%20page.png)


## Team Roles

- Zavadskii Peter Team Lead / Backend
- Zaynulin Salavat Backend
- Lutfullin Sarmat Frontend
- Fominykh Aleksei DevOps

## Link to backlog

https://github.com/orgs/Fitgym-org/projects/1


## License

MIT License. See [LICENSE](LICENSE) for more information.

---

## Implementation checklist

### Technical requirements (20 points)
#### Backend development (8 points)
- [X] Go-based microservices architecture (minimum 3 services) (3 points)
- [X] RESTful API with Swagger documentation (1 point)
- [ ] gRPC implementation for communication between microservices (1 point)
- [X] PostgreSQL database with proper schema design (1 point)
- [X] JWT-based authentication and authorization (1 point)
- [X] Comprehensive unit and integration tests (1 point)

#### Frontend development (8 points)
- [X] Flutter-based cross-platform application (mobile + web) (3 points)
- [X] Responsive UI design with custom widgets (1 point)
- [X] State management implementation (1 point)
- [X] Offline data persistence (1 point)
- [X] Unit and widget tests (1 point)
- [X] Support light and dark mode (1 point)

#### DevOps & deployment (4 points)
- [X] Docker compose for all services (1 point)
- [X] CI/CD pipeline implementation (1 point)
- [X] Environment configuration management using config files (1 point)
- [X] GitHub pages for the project (1 point)

### Non-Technical Requirements (10 points)
#### Project management (4 points)
- [X] GitHub organization with well-maintained repository (1 point)
- [X] Regular commits and meaningful pull requests from all team members (1 point)
- [X] Project board (GitHub Projects) with task tracking (1 point)
- [X] Team member roles and responsibilities documentation (1 point)

#### Documentation (4 points)
- [X] Project overview and setup instructions (1 point)
- [X] Screenshots and GIFs of key features (1 point)
- [X] API documentation (1 point)
- [ ] Architecture diagrams and explanations (1 point)

#### Code quality (2 points)
- [X] Consistent code style and formatting during CI/CD pipeline (1 point)
- [X] Code review participation and resolution (1 point)

### Bonus Features (up to 10 points)
- [X] Localization for Russian (RU) and English (ENG) languages (2 points)
- [X] Good UI/UX design (up to 3 points)
- [ ] Integration with external APIs (fitness trackers, health devices) (up to 5 points)
- [X] Comprehensive error handling and user feedback (up to 2 points)
- [X] Advanced animations and transitions (up to 3 points)
- [X] Widget implementation for native mobile elements (up to 2 points)
