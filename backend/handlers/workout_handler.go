package handlers

import (
	"encoding/json"
	"net/http"
	"time"

	"fitgym/backend/serivces"

	"github.com/google/uuid"
)

var WorkoutService *serivces.WorkoutService

func AddWorkoutHandler(w http.ResponseWriter, r *http.Request) {
	type reqBody struct {
		UserID      string `json:"user_id"`
		WorkoutType string `json:"workout_type"`
		Date        string `json:"date"`
		Duration    int    `json:"duration"`
		Notes       string `json:"notes"`
	}
	var req reqBody
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}
	userID, err := uuid.Parse(req.UserID)
	if err != nil {
		http.Error(w, "Invalid user_id", http.StatusBadRequest)
		return
	}
	date, err := time.Parse("2006-01-02", req.Date)
	if err != nil {
		http.Error(w, "Invalid date format", http.StatusBadRequest)
		return
	}
	id, err := WorkoutService.AddWorkout(userID, req.WorkoutType, date, req.Duration, req.Notes)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	json.NewEncoder(w).Encode(map[string]string{"workout_id": id.String()})
}

func AddExerciseHandler(w http.ResponseWriter, r *http.Request) {
	type reqBody struct {
		WorkoutID string  `json:"workout_id"`
		Name      string  `json:"name"`
		Sets      int     `json:"sets"`
		Reps      int     `json:"reps"`
		Weight    float32 `json:"weight"`
	}
	var req reqBody
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}
	workoutID, err := uuid.Parse(req.WorkoutID)
	if err != nil {
		http.Error(w, "Invalid workout_id", http.StatusBadRequest)
		return
	}
	id, err := WorkoutService.AddExercise(workoutID, req.Name, req.Sets, req.Reps, req.Weight)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	json.NewEncoder(w).Encode(map[string]string{"exercise_id": id.String()})
}

func GetWorkoutHistoryHandler(w http.ResponseWriter, r *http.Request) {
	userIDStr := r.URL.Query().Get("user_id")
	userID, err := uuid.Parse(userIDStr)
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
