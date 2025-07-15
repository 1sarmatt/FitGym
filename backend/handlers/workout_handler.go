package handlers

import (
	"encoding/json"
	"net/http"
	"time"

	"fitgym/backend/serivces"
	"fitgym/backend/repository/model"
	"fitgym/backend/repository/postgres"

	"github.com/google/uuid"
)

var WorkoutService *serivces.WorkoutService
var WorkoutRepo *postgres.WorkoutRepository
var ExerciseRepo *postgres.ExerciseRepository

func AddWorkoutHandler(w http.ResponseWriter, r *http.Request) {
	type exerciseReq struct {
		Name   string  `json:"name"`
		Sets   int     `json:"sets"`
		Reps   int     `json:"reps"`
		Weight float32 `json:"weight"`
	}
	type reqBody struct {
		UserID      string        `json:"user_id"`
		WorkoutType string        `json:"workout_type"`
		Date        string        `json:"date"`
		Duration    int           `json:"duration"`
		Notes       string        `json:"notes"`
		Exercises   []exerciseReq `json:"exercises"`
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
	// Save to database
	workout := &model.Workout{
		UserID:    userID,
		Notes:     req.Notes,
		Date:      date,
		Completed: false,
		WorkoutType: req.WorkoutType,
	}
	err = WorkoutRepo.CreateWorkout(workout)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	// Save exercises
	for _, ex := range req.Exercises {
		exercise := &model.Exercise{
			Name:      ex.Name,
			Sets:      ex.Sets,
			Reps:      ex.Reps,
			Weight:    int(ex.Weight),
			WorkoutID: workout.ID,
		}
		err := ExerciseRepo.CreateExercise(exercise)
		if err != nil {
			http.Error(w, "Failed to save exercise", http.StatusInternalServerError)
			return
		}
	}
	json.NewEncoder(w).Encode(map[string]string{"workout_id": workout.ID.String()})
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
    var userID uuid.UUID
    var err error
    if userIDStr == "" {
        // Try to get user email from JWT context
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
        userID = user.ID
    } else {
        userID, err = uuid.Parse(userIDStr)
        if err != nil {
            http.Error(w, "Invalid user_id", http.StatusBadRequest)
            return
        }
    }
    workouts, err := WorkoutRepo.GetWorkoutsByUserID(userID)
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }
    var history []model.Workout
    for _, w := range workouts {
        if w.Completed {
            history = append(history, w)
        }
    }
    json.NewEncoder(w).Encode(history)
}

// Handler to mark a workout as completed
func CompleteWorkoutHandler(w http.ResponseWriter, r *http.Request) {
    type reqBody struct {
        WorkoutID string `json:"workout_id"`
    }
    var req reqBody
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        http.Error(w, "Invalid request body", http.StatusBadRequest)
        return
    }
    id, err := uuid.Parse(req.WorkoutID)
    if err != nil {
        http.Error(w, "Invalid workout_id", http.StatusBadRequest)
        return
    }
    workout, err := WorkoutRepo.GetWorkoutByID(id)
    if err != nil {
        http.Error(w, "Workout not found", http.StatusNotFound)
        return
    }
    workout.Completed = true
    if err := WorkoutRepo.UpdateWorkout(workout); err != nil {
        http.Error(w, "Failed to update workout", http.StatusInternalServerError)
        return
    }
    w.WriteHeader(http.StatusOK)
    json.NewEncoder(w).Encode(map[string]string{"status": "completed"})
}
// Register this handler in main.go: r.Post("/completeWorkout", handlers.CompleteWorkoutHandler)

// Handler to get all workouts (active and completed) for a user
func GetWorkoutsHandler(w http.ResponseWriter, r *http.Request) {
    userIDStr := r.URL.Query().Get("user_id")
    var userID uuid.UUID
    var err error
    if userIDStr == "" {
        // Try to get user email from JWT context
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
        userID = user.ID
    } else {
        userID, err = uuid.Parse(userIDStr)
        if err != nil {
            http.Error(w, "Invalid user_id", http.StatusBadRequest)
            return
        }
    }
    workouts, err := WorkoutRepo.GetWorkoutsByUserID(userID)
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }
    json.NewEncoder(w).Encode(workouts)
}
// Register this handler in main.go: r.With(internal.JWTAuthMiddleware).Get("/getWorkouts", handlers.GetWorkoutsHandler)

// Handler to get all workouts (active and completed) for a friend, with friendship check
func GetFriendWorkoutsHandler(w http.ResponseWriter, r *http.Request) {
    // Get current user from JWT context
    userEmail, ok := r.Context().Value("Email").(string)
    if !ok {
        http.Error(w, "Unauthorized", http.StatusUnauthorized)
        return
    }
    userID, err := UserRepo.GetUserIDByEmail(userEmail)
    if err != nil {
        http.Error(w, "Current user not found", http.StatusNotFound)
        return
    }
    // Get friend_id from query
    friendIDStr := r.URL.Query().Get("friend_id")
    if friendIDStr == "" {
        http.Error(w, "Missing friend_id", http.StatusBadRequest)
        return
    }
    friendID, err := uuid.Parse(friendIDStr)
    if err != nil {
        http.Error(w, "Invalid friend_id", http.StatusBadRequest)
        return
    }
    // Check if they are friends (mutual)
    friends, err := FriendRepo.GetFriends(userID)
    if err != nil {
        http.Error(w, "Failed to check friendship", http.StatusInternalServerError)
        return
    }
    isFriend := false
    for _, f := range friends {
        if f.FriendID == friendID {
            isFriend = true
            break
        }
    }
    if !isFriend {
        http.Error(w, "You are not friends with this user", http.StatusForbidden)
        return
    }
    // Fetch friend's workouts
    workouts, err := WorkoutRepo.GetWorkoutsByUserID(friendID)
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }
    json.NewEncoder(w).Encode(workouts)
}
// Register this handler in main.go: r.With(internal.JWTAuthMiddleware).Get("/getFriendWorkouts", handlers.GetFriendWorkoutsHandler)

// Handler to get all workouts (active and completed) for a friend by email, with friendship check
func GetFriendWorkoutsByEmailHandler(w http.ResponseWriter, r *http.Request) {
    // Get current user from JWT context
    userEmail, ok := r.Context().Value("Email").(string)
    if !ok {
        http.Error(w, "Unauthorized", http.StatusUnauthorized)
        return
    }
    userID, err := UserRepo.GetUserIDByEmail(userEmail)
    if err != nil {
        http.Error(w, "Current user not found", http.StatusNotFound)
        return
    }
    // Get friend_email from query
    friendEmail := r.URL.Query().Get("friend_email")
    if friendEmail == "" {
        http.Error(w, "Missing friend_email", http.StatusBadRequest)
        return
    }
    friendID, err := UserRepo.GetUserIDByEmail(friendEmail)
    if err != nil {
        http.Error(w, "Friend user not found", http.StatusNotFound)
        return
    }
    // Check if they are friends (mutual)
    friends, err := FriendRepo.GetFriends(userID)
    if err != nil {
        http.Error(w, "Failed to check friendship", http.StatusInternalServerError)
        return
    }
    isFriend := false
    for _, f := range friends {
        if f.FriendID == friendID {
            isFriend = true
            break
        }
    }
    if !isFriend {
        http.Error(w, "You are not friends with this user", http.StatusForbidden)
        return
    }
    // Fetch friend's workouts
    workouts, err := WorkoutRepo.GetWorkoutsByUserID(friendID)
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }
    json.NewEncoder(w).Encode(workouts)
}
// Register this handler in main.go: r.With(internal.JWTAuthMiddleware).Get("/getFriendWorkoutsByEmail", handlers.GetFriendWorkoutsByEmailHandler)

// Handler to edit a workout
func EditWorkoutHandler(w http.ResponseWriter, r *http.Request) {
    type exerciseReq struct {
        Name   string  `json:"name"`
        Sets   int     `json:"sets"`
        Reps   int     `json:"reps"`
        Weight float32 `json:"weight"`
    }
    type reqBody struct {
        ID        string        `json:"id"`
        Notes     string        `json:"notes"`
        Date      string        `json:"date"`
        Type      string        `json:"type"`
        Exercises []exerciseReq `json:"exercises"`
    }
    var req reqBody
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        http.Error(w, "Invalid request body", http.StatusBadRequest)
        return
    }
    id, err := uuid.Parse(req.ID)
    if err != nil {
        http.Error(w, "Invalid id", http.StatusBadRequest)
        return
    }
    workout, err := WorkoutRepo.GetWorkoutByID(id)
    if err != nil {
        http.Error(w, "Workout not found", http.StatusNotFound)
        return
    }
    workout.Notes = req.Notes
    workout.Date, _ = time.Parse("2006-01-02", req.Date)
    workout.WorkoutType = req.Type
    if err := WorkoutRepo.UpdateWorkout(workout); err != nil {
        http.Error(w, "Failed to update workout", http.StatusInternalServerError)
        return
    }
    // Update exercises: delete old, add new
    if err := ExerciseRepo.DeleteExercisesByWorkoutID(workout.ID); err != nil {
        http.Error(w, "Failed to delete old exercises", http.StatusInternalServerError)
        return
    }
    for _, ex := range req.Exercises {
        exercise := &model.Exercise{
            Name:      ex.Name,
            Sets:      ex.Sets,
            Reps:      ex.Reps,
            Weight:    int(ex.Weight),
            WorkoutID: workout.ID,
        }
        err := ExerciseRepo.CreateExercise(exercise)
        if err != nil {
            http.Error(w, "Failed to save exercise", http.StatusInternalServerError)
            return
        }
    }
    w.WriteHeader(http.StatusOK)
    json.NewEncoder(w).Encode(map[string]string{"status": "updated"})
}
// Register this handler in main.go: r.With(internal.JWTAuthMiddleware).Put("/editWorkout", handlers.EditWorkoutHandler)

// Handler to delete a workout
func DeleteWorkoutHandler(w http.ResponseWriter, r *http.Request) {
    type reqBody struct {
        ID string `json:"id"`
    }
    var req reqBody
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        http.Error(w, "Invalid request body", http.StatusBadRequest)
        return
    }
    id, err := uuid.Parse(req.ID)
    if err != nil {
        http.Error(w, "Invalid id", http.StatusBadRequest)
        return
    }
    // Delete exercises first
    if err := ExerciseRepo.DeleteExercisesByWorkoutID(id); err != nil {
        http.Error(w, "Failed to delete exercises", http.StatusInternalServerError)
        return
    }
    workout, err := WorkoutRepo.GetWorkoutByID(id)
    if err != nil {
        http.Error(w, "Workout not found", http.StatusNotFound)
        return
    }
    if err := WorkoutRepo.DeleteWorkout(workout); err != nil {
        http.Error(w, "Failed to delete workout", http.StatusInternalServerError)
        return
    }
    w.WriteHeader(http.StatusOK)
    json.NewEncoder(w).Encode(map[string]string{"status": "deleted"})
}
// Register this handler in main.go: r.With(internal.JWTAuthMiddleware).Delete("/deleteWorkout", handlers.DeleteWorkoutHandler)
