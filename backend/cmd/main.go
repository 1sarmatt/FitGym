package main

import (
	"fitgym/backend/handlers"
	"fitgym/backend/internal"
	"fitgym/backend/repository/model"
	pg "fitgym/backend/repository/postgres"
	"fitgym/backend/serivces"
	"log"
	"net/http"
	"os"

	"github.com/go-chi/chi/v5"
	"github.com/joho/godotenv"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func main() {
	// Load environment variables
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found, using environment variables")
	}

	db, err := gorm.Open(postgres.Open(os.Getenv("DATABASE_URL")), &gorm.Config{})
	if err != nil {
		log.Fatal(err)
	}

	err = db.AutoMigrate(
		&model.User{},
		&model.Workout{},
		&model.Exercise{},
		&model.Friend{},
	)
	if err != nil {
		log.Fatal(err)
	}

	r := chi.NewRouter()

	workoutService := serivces.NewWorkoutService()
	userService := serivces.NewUserService()
	analyticsService := serivces.NewAnalyticsService(workoutService)
	handlers.WorkoutService = workoutService
	handlers.UserHandler = userService
	handlers.FriendRepo = pg.NewFriendRepository(db)
	handlers.UserRepo = pg.NewUserRepository(db)
	handlers.AnalyticsSrv = analyticsService

	r.With(internal.JWTAuthMiddleware).Post("/addWorkout", handlers.AddWorkoutHandler)
	r.With(internal.JWTAuthMiddleware).Post("/addExercise", handlers.AddExerciseHandler)
	r.With(internal.JWTAuthMiddleware).Get("/getWorkoutHistory", handlers.GetWorkoutHistoryHandler)
	r.With(internal.JWTAuthMiddleware).Post("/addFriend", handlers.AddFriendHandler)
	r.With(internal.JWTAuthMiddleware).Get("/getFriends", handlers.GetFriendsHandler)
	r.With(internal.JWTAuthMiddleware).Post("/editProfile", handlers.EditProfileHandler)
	r.With(internal.JWTAuthMiddleware).Get("/getWeeklySummary", handlers.GetWeeklySummaryHandler)
	r.With(internal.JWTAuthMiddleware).Get("/getWeeklyCharts", handlers.GetProgressChartsHandler)
	r.With(internal.JWTAuthMiddleware).Get("/getUserID", handlers.GetUserIDHandler)
	r.Post("/register", handlers.RegisterUserHandler)
	r.Post("/login", handlers.LoginUserHandler)
	r.Post("/refresh", handlers.RefreshTokenHandler)

	// Protected route
	r.With(internal.JWTAuthMiddleware).Get("/protected", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("You are authenticated!"))
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	log.Printf("Server running on :%s", port)
	log.Fatal(http.ListenAndServe(":"+port, r))
}
