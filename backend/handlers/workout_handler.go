package handlers

import (
	"encoding/json"
	"log"
	"net/http"
	"time"

	"fitgym/backend/serivces"
)

var WorkoutService *serivces.WorkoutService

func AddWorkoutHandler(w http.ResponseWriter, r *http.Request) {

	userEmail, ok := r.Context().Value("Email").(string)
	if !ok {
		http.Error(w, "Unable to get user information", http.StatusUnauthorized)
		return
	}
	type reqBody struct {
		WorkoutName string `json:"workout_type"`
		Date        string `json:"date"`
		Duration    int    `json:"duration"`
		Notes       string `json:"notes"`
	}
	var req reqBody
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	userID, err := UserRepo.GetUserIDByEmail(userEmail)
	if err != nil {
		log.Fatal(err)
	}
	if err != nil {
		http.Error(w, "Invalid user_id", http.StatusBadRequest)
		return
	}
	date, err := time.Parse("2006-01-02", req.Date)
	if err != nil {
		http.Error(w, "Invalid date format", http.StatusBadRequest)
		return
	}
	WorkoutService.AddWorkout(userID, req.WorkoutName, date, req.Duration, req.Notes)
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"status": "workout added"})
}

func AddExerciseHandler(w http.ResponseWriter, r *http.Request) {

	userEmail, ok := r.Context().Value("Email").(string)
	if !ok {
		http.Error(w, "Unable to get user information", http.StatusUnauthorized)
		return
	}
	type reqBody struct {
		WorkoutName   string  `json:"workout_name"`
		ExcerciseName string  `json:"excercise_name"`
		Sets          int     `json:"sets"`
		Reps          int     `json:"reps"`
		Weight        float32 `json:"weight"`
	}
	var req reqBody
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	WorkoutService.AddExercise(userEmail, req.WorkoutName, req.ExcerciseName, req.Sets, req.Reps, req.Weight)
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"status": "exercise added"})
}

func GetWorkoutHistoryHandler(w http.ResponseWriter, r *http.Request) {

	userEmail, ok := r.Context().Value("Email").(string)
	if !ok {
		http.Error(w, "Unable to get user information", http.StatusUnauthorized)
		return
	}
	userID, err := UserRepo.GetUserIDByEmail(userEmail)
	if err != nil {
		http.Error(w, "Invalid user_id", http.StatusBadRequest)
		return
	}
	history, err := WorkoutService.GetWorkoutHistory(userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	json.NewEncoder(w).Encode(history)
}
