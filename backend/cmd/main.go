package main

import (
	"fitgym/backend/handlers"
	"fitgym/backend/internal"
	"fitgym/backend/repository/model"
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
	db.AutoMigrate(&model.User{})

	r := chi.NewRouter()

	workoutService := serivces.NewWorkoutService()
	handlers.WorkoutService = workoutService

	r.Get("/login", func(w http.ResponseWriter, r *http.Request) {
		token, err := internal.GenerateJWT("123")
		if err != nil {
			http.Error(w, "Could not generate token", http.StatusInternalServerError)
			return
		}
		w.Write([]byte(token))
	})

	r.Post("/addWorkout", handlers.AddWorkoutHandler)
	r.Post("/addExercise", handlers.AddExerciseHandler)
	r.Get("/GetWorkoutHistory", handlers.GetWorkoutHistoryHandler)
	r.Post("/AddFriend", handlers.AddFriendHandler)
	r.Get("/GetFriends", handlers.GetFriendsHandler)

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
