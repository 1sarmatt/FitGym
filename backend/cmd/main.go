// @title FitGym API
// @version 1.0
// @description API for FitGym fitness tracking app.
// @host localhost:8080
// @BasePath /

// @securityDefinitions.apikey BearerAuth
// @in header
// @name Authorization
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
	"github.com/go-chi/cors"

	"github.com/joho/godotenv"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"

	_ "fitgym/backend/cmd/docs" // swag generated docs

	httpSwagger "github.com/swaggo/http-swagger"
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
	r.Use(cors.Handler(cors.Options{
		AllowedOrigins: []string{
			"https://fitgym-org.github.io", // GitHub Pages
			"http://localhost:80",          // Local dev (optional)
			"http://localhost:8080",        // Optional if testing backend directly
		},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type"},
		ExposedHeaders:   []string{"Link"},
		AllowCredentials: true,
		MaxAge:           300, // cache preflight response for 5 minutes
	}))

	r.Use(func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			log.Printf("➡️ %s %s | Origin: %s", r.Method, r.URL.Path, r.Header.Get("Origin"))
			next.ServeHTTP(w, r)
		})
	})

	// Swagger docs endpoint
	r.Get("/swagger/*", httpSwagger.WrapHandler)

	workoutService := serivces.NewWorkoutService()
	userService := serivces.NewUserService()
	handlers.WorkoutService = workoutService
	handlers.UserHandler = userService
	handlers.FriendRepo = pg.NewFriendRepository(db)
	handlers.UserRepo = pg.NewUserRepository(db)
	handlers.WorkoutRepo = pg.NewWorkoutRepository(db)
	handlers.ExerciseRepo = pg.NewExerciseRepository(db)

	r.Post("/addWorkout", handlers.AddWorkoutHandler)
	r.Post("/addExercise", handlers.AddExerciseHandler)
	r.Get("/getWorkoutHistory", handlers.GetWorkoutHistoryHandler)
	r.With(internal.JWTAuthMiddleware).Post("/addFriend", handlers.AddFriendHandler)
	r.With(internal.JWTAuthMiddleware).Get("/getFriends", handlers.GetFriendsHandler)
	r.With(internal.JWTAuthMiddleware).Put("/editProfile", handlers.EditProfileHandler)
	r.With(internal.JWTAuthMiddleware).Get("/profile", handlers.GetProfileHandler)
	r.Post("/register", handlers.RegisterUserHandler)
	r.Post("/login", handlers.LoginUserHandler)
	r.Post("/refresh", handlers.RefreshTokenHandler)
	r.Post("/completeWorkout", handlers.CompleteWorkoutHandler)
	r.With(internal.JWTAuthMiddleware).Get("/getWorkouts", handlers.GetWorkoutsHandler)
	r.With(internal.JWTAuthMiddleware).Put("/editWorkout", handlers.EditWorkoutHandler)
	r.With(internal.JWTAuthMiddleware).Delete("/deleteWorkout", handlers.DeleteWorkoutHandler)
	r.With(internal.JWTAuthMiddleware).Get("/getFriendWorkoutsByEmail", handlers.GetFriendWorkoutsByEmailHandler)

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
