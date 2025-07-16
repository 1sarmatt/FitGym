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

// UserCredentials represents user login/registration request
type UserCredentials struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

// EditProfileRequest represents profile update request
type EditProfileRequest struct {
	Name string `json:"name"`
	Age  int    `json:"age"`
}

// RefreshTokenRequest represents refresh token request
type RefreshTokenRequest struct {
	RefreshToken string `json:"refresh_token"`
}

var UserHandler *serivces.User_Service
var UserRepo *postgres.UserRepository // Should be initialized in main.go

// EditProfileHandler godoc
// @Summary Edit user profile
// @Description Updates the profile of the authenticated user
// @Tags user
// @Accept  json
// @Produce  json
// @Param   profile  body  EditProfileRequest  true  "Profile info"
// @Success 200 {object} map[string]string
// @Failure 400 {string} string "Invalid request body"
// @Failure 401 {string} string "Unauthorized"
// @Router /editProfile [put]
// @Security BearerAuth
func EditProfileHandler(w http.ResponseWriter, r *http.Request) {
	_, ok := r.Context().Value("Email").(string)
	if !ok {
		http.Error(w, "Unable to get user information", http.StatusUnauthorized)
		return
	}
	var req EditProfileRequest

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

// RegisterUserHandler godoc
// @Summary Register a new user
// @Description Registers a new user with email and password
// @Tags auth
// @Accept  json
// @Produce  json
// @Param   user  body  UserCredentials  true  "User info"
// @Success 200 {object} internal.TokenPair
// @Failure 400 {string} string "Invalid request body"
// @Router /register [post]
func RegisterUserHandler(w http.ResponseWriter, r *http.Request) {
	var req UserCredentials
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
	json.NewEncoder(w).Encode(*tokenPair)
}

// LoginUserHandler godoc
// @Summary Login user
// @Description Authenticates user and returns tokens
// @Tags auth
// @Accept  json
// @Produce  json
// @Param   user  body  UserCredentials  true  "User info"
// @Success 200 {object} internal.TokenPair
// @Failure 400 {string} string "Invalid request body"
// @Router /login [post]
func LoginUserHandler(w http.ResponseWriter, r *http.Request) {
	var req UserCredentials
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

// RefreshTokenHandler godoc
// @Summary Refresh token
// @Description Refreshes JWT token
// @Tags auth
// @Accept  json
// @Produce  json
// @Param   refresh_token  body  RefreshTokenRequest  true  "Refresh token"
// @Success 200 {object} internal.TokenPair
// @Failure 400 {string} string "Invalid request body"
// @Router /refresh [post]
func RefreshTokenHandler(w http.ResponseWriter, r *http.Request) {
	var req RefreshTokenRequest
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

// GetProfileHandler godoc
// @Summary Get user profile
// @Description Returns the profile of the authenticated user
// @Tags user
// @Produce  json
// @Success 200 {object} map[string]interface{}
// @Failure 401 {string} string "Unauthorized"
// @Failure 404 {string} string "User not found"
// @Router /profile [get]
// @Security BearerAuth
func GetProfileHandler(w http.ResponseWriter, r *http.Request) {
	email, ok := r.Context().Value("Email").(string)
	if !ok {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}
	user, err := UserRepo.GetUserByEmail(email)
	if err != nil {
		http.Error(w, "User not found", http.StatusNotFound)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"id":    user.ID.String(),
		"name":  user.Name,
		"email": user.Email,
		"age":   user.Age,
	})
}
