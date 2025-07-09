package main

import (
	"log"
	"net/http"
	"os"

	"github.com/go-chi/chi/v5"
	"github.com/joho/godotenv"

	"fitgym-backend/internal"
)

func main() {
	// Load environment variables
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found, using environment variables")
	}

	r := chi.NewRouter()

	// Public route
	r.Get("/login", func(w http.ResponseWriter, r *http.Request) {
		// Example: always returns a token for user id 123
		token, err := internal.GenerateJWT("123")
		if err != nil {
			http.Error(w, "Could not generate token", http.StatusInternalServerError)
			return
		}
		w.Write([]byte(token))
	})

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
