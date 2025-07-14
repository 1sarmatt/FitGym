package handlers

import (
	"encoding/json"
	"net/http"

	"fitgym/backend/internal"
	"fitgym/backend/repository/postgres"
	"fitgym/backend/serivces"
)

const (
	errInvalidRequestBody = "Invalid request body"
	contentTypeJSON       = "application/json"
	contentTypeHeader     = "Content-Type"
)

var UserHandler *serivces.User_Service
var UserRepo *postgres.UserRepository // Should be initialized in main.go

// Handler for editing user profile
func EditProfileHandler(w http.ResponseWriter, r *http.Request) {
	_, ok := r.Context().Value("userEmail").(string)
	if !ok {
		http.Error(w, "Unable to get user information", http.StatusUnauthorized)
		return
	}
	type reqBody struct {
		Name string `json:"name"`
		Age  int    `json:"age"`
	}
	var req reqBody

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, errInvalidRequestBody, http.StatusBadRequest)
		return
	}
	ok, err := UserHandler.EditProfile(req.Name, req.Age, *UserRepo)
	if err != nil || !ok {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"status": "profile updated"})
}

// Handler for registration of user
func RegisterUserHandler(w http.ResponseWriter, r *http.Request) {
	type reqBody struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}
	var req reqBody
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, errInvalidRequestBody, http.StatusBadRequest)
		return
	}
	tokenPair, err := UserHandler.Register(req.Email, req.Password, *UserRepo)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	w.Header().Set(contentTypeHeader, contentTypeJSON)
	json.NewEncoder(w).Encode(tokenPair)
}

// Handler for login of user
func LoginUserHandler(w http.ResponseWriter, r *http.Request) {
	type reqBody struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}
	var req reqBody
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, errInvalidRequestBody, http.StatusBadRequest)
		return
	}
	tokenPair, err := UserHandler.Login(req.Email, req.Password, *UserRepo)
	if err != nil {
		http.Error(w, err.Error(), http.StatusUnauthorized)
		return
	}
	w.Header().Set(contentTypeHeader, contentTypeJSON)
	json.NewEncoder(w).Encode(tokenPair)
}

// Handler for refreshing access token
func RefreshTokenHandler(w http.ResponseWriter, r *http.Request) {
	type reqBody struct {
		RefreshToken string `json:"refresh_token"`
	}
	var req reqBody
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, errInvalidRequestBody, http.StatusBadRequest)
		return
	}

	newAccessToken, err := internal.RefreshAccessToken(req.RefreshToken)
	if err != nil {
		http.Error(w, "Invalid or expired refresh token", http.StatusUnauthorized)
		return
	}

	w.Header().Set(contentTypeHeader, contentTypeJSON)
	json.NewEncoder(w).Encode(map[string]string{"access_token": newAccessToken})
}
