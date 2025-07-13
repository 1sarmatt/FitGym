package handlers

import (
	"encoding/json"
	"net/http"
	"fitgym/backend/serivces"
	"fitgym/backend/internal"
)

var UserService *serivces.User_Service

// RegisterHandler handles user registration
func RegisterHandler(w http.ResponseWriter, r *http.Request) {
	type reqBody struct {
		Name     string `json:"name"`
		Age      int    `json:"age"`
		Password string `json:"password"`
	}
	var req reqBody
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}
	if req.Name == "" || req.Password == "" {
		http.Error(w, "Name and password required", http.StatusBadRequest)
		return
	}
	if req.Age < 5 || req.Age > 100 {
		http.Error(w, "Invalid age", http.StatusBadRequest)
		return
	}
	// Simulate user creation and return a user id (index)
	index := len(UserService.Users)
	UserService.Users[index] = serivces.User{
		Name: req.Name,
		Age: req.Age,
		PasswordHash: req.Password, // Hash in real app
	}
	json.NewEncoder(w).Encode(map[string]int{"user_id": index})
}

// LoginHandler handles user login and returns JWT
func LoginHandler(w http.ResponseWriter, r *http.Request) {
	type reqBody struct {
		Name     string `json:"name"`
		Password string `json:"password"`
	}
	var req reqBody
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}
	for id, user := range UserService.Users {
		if user.Name == req.Name && user.PasswordHash == req.Password {
			token, err := internal.GenerateJWT(string(id))
			if err != nil {
				http.Error(w, "Could not generate token", http.StatusInternalServerError)
				return
			}
			json.NewEncoder(w).Encode(map[string]string{"token": token})
			return
		}
	}
	http.Error(w, "Invalid credentials", http.StatusUnauthorized)
}

func EditProfileHandler(w http.ResponseWriter, r *http.Request) {
	// TODO: implement edit profile logic
}
