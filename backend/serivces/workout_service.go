package serivces

import (
	"fitgym/backend/repository/model"
	"time"

	"github.com/google/uuid"
)

type WorkoutService struct {
	workouts  map[uuid.UUID]model.Workout
	exercises map[uuid.UUID]model.Exercise
}

func NewWorkoutService() *WorkoutService {
	return &WorkoutService{
		workouts:  make(map[uuid.UUID]model.Workout),
		exercises: make(map[uuid.UUID]model.Exercise),
	}
}

func (ws *WorkoutService) AddWorkout(userID uuid.UUID, workoutType string, date time.Time, duration int, notes string) (uuid.UUID, error) {
	id := uuid.New()

	if userID == uuid.Nil {
		return uuid.Nil, ErrorUserID
	}

	if workoutType == "" {
		return uuid.Nil, ErrorWorkoutTypeEmpty
	}

	if duration < 1 {
		return uuid.Nil, ErrorDuration
	}

	workout := model.Workout{
		ID:        id,
		UserID:    userID,
		Date:      date,
		Notes:     notes,
		Completed: false,
		Exercises: []model.Exercise{},
	}
	ws.workouts[id] = workout
	return id, nil
}

func (ws *WorkoutService) AddExercise(workoutID uuid.UUID, name string, sets, reps int, weight float32) (uuid.UUID, error) {
	id := uuid.New()

	if workoutID == uuid.Nil {
		return uuid.Nil, ErrorWorkoutID
	}

	if name == "" {
		return uuid.Nil, ErrorWorkoutNameEmpty
	}

	if sets < 1 || reps < 1 {
		return uuid.Nil, ErrorSetsReps
	}

	if weight < 0 {
		return uuid.Nil, ErrorWeight
	}

	exercise := model.Exercise{
		ID:        id,
		WorkoutID: workoutID,
		Name:      name,
		Reps:      reps,
		Weight:    int(weight),
	}
	ws.exercises[id] = exercise
	if workout, ok := ws.workouts[workoutID]; ok {
		workout.Exercises = append(workout.Exercises, exercise)
		ws.workouts[workoutID] = workout
	}
	return id, nil
}

func (ws *WorkoutService) GetWorkoutHistory(userID uuid.UUID) ([]model.Workout, error) {

	if userID == uuid.Nil {
		return nil, ErrorUserID
	}

	var history []model.Workout
	for _, workout := range ws.workouts {
		if workout.UserID == userID {
			history = append(history, workout)
		}
	}
	return history, nil
}