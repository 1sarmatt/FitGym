package handlers

import (
  "encoding/json"
  "net/http"

  "fitgym/backend/repository/postgres"
  "fitgym/backend/serivces"
)

var userHandler *serivces.User_Service
var userRepo *postgres.UserRepository // Should be initialized in main.go

// Handler for editing user profile
func EditProfileHandler(w http.ResponseWriter, r *http.Request) {
  type reqBody struct {
    Name string `json:"name"`
    Age  int    `json:"age"`
  }
  var req reqBody
  if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
    http.Error(w, "Invalid request body", http.StatusBadRequest)
    return
  }
  ok, err := userHandler.EditProfile(req.Name, req.Age, *userRepo)
  if err != nil || !ok {
    http.Error(w, err.Error(), http.StatusBadRequest)
    return
  }
  w.WriteHeader(http.StatusOK)
  json.NewEncoder(w).Encode(map[string]string{"status": "profile updated"})
}

// Handler for registration of user
func RegisterUserHandler(w http.ResponseWriter, r *http.Request) {
  const errInvalidRequestBody = "Invalid request body"
  type reqBody struct {
    Email    string `json:"email"`
    Password string `json:"password"`
  }
  var req reqBody
  if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
    http.Error(w, errInvalidRequestBody, http.StatusBadRequest)
    return
  }
  token, err := userHandler.Register(req.Email, req.Password, *userRepo)
  if err != nil {
    http.Error(w, err.Error(), http.StatusBadRequest)
    return
  }
  json.NewEncoder(w).Encode(map[string]string{"token": token})
}

// Handler for login of user
func LoginUserHandler(w http.ResponseWriter, r *http.Request) {
  const errInvalidRequestBody = "Invalid request body"
  type reqBody struct {
    Email    string `json:"email"`
    Password string `json:"password"`
  }
  var req reqBody
  if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
    http.Error(w, errInvalidRequestBody, http.StatusBadRequest)
    return
  }
  token, err := userHandler.Login(req.Email, req.Password, *userRepo)
  if err != nil {
    http.Error(w, err.Error(), http.StatusUnauthorized)
    return
  }
  json.NewEncoder(w).Encode(map[string]string{"token": token})
}
