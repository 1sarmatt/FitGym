package serivces

import (
	"fitgym/backend/repository/model"
	"fitgym/backend/repository/postgres"
	"sort"
	"time"

	"github.com/google/uuid"
)

var WorkoutRepo *postgres.WorkoutRepository
var ExerciseRepo *postgres.ExerciseRepository

type WorkoutService struct {
	workout model.Workout
}

type WorkoutWithExercises struct {
	Workout   model.Workout
	Exercises []model.Exercise
}

func NewWorkoutService() *WorkoutService {
	return &WorkoutService{
		workout: model.Workout{},
	}
}

func (ws *WorkoutService) AddWorkout(userID uuid.UUID, workoutName string, date time.Time, duration int, notes string) error {

	if workoutName == "" {
		return ErrorWorkoutTypeEmpty
	}

	if duration < 1 {
		return ErrorDuration
	}

	workout := model.Workout{
		UserID:      userID,
		WorkoutName: workoutName,
		Date:        date,
		Notes:       notes,
		Completed:   false,
	}
	WorkoutRepo.CreateWorkout(&workout)
	return nil
}

func (ws *WorkoutService) AddExercise(userEmail, workoutName string, excerciseName string, sets, reps int, weight float32) error {

	if workoutName == "" {
		return ErrorWorkoutNameEmpty
	}
	if sets < 1 || reps < 1 {
		return ErrorSetsReps
	}
	if weight < 0 {
		return ErrorWeight
	}

	workoutID, err := WorkoutRepo.GetWorkoutID(userEmail, workoutName)
	if err != nil {
		return err
	}
	exercise := model.Exercise{
		WorkoutID: workoutID,
		Name:      excerciseName,
		Reps:      reps,
		Weight:    int(weight),
	}
	ExerciseRepo.CreateExercise(&exercise)
	return nil
}

func (ws *WorkoutService) GetWorkoutHistory(userID uuid.UUID) ([]WorkoutWithExercises, error) {

	if userID == uuid.Nil {
		return nil, ErrorUserID
	}

	var history []WorkoutWithExercises
	var workouts []model.Workout
	workouts, err := WorkoutRepo.GetWorkoutsByUserID(userID)
	if err != nil {
		return nil, err
	}
	for _, workout := range workouts {
		exercises, err := ExerciseRepo.GetExercisesByWorkoutID(workout.ID)
		if err != nil {
			return nil, err
		}
		history = append(history, WorkoutWithExercises{
			Workout:   workout,
			Exercises: exercises,
		})
	}
	sort.Slice(history, func(i, j int) bool {
		return history[i].Workout.Date.After(history[j].Workout.Date)
	})

	return history, nil
}
