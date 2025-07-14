package serivces

import (
	"fmt"
	"time"

	"github.com/google/uuid"
)

type AnalyticsService struct {
	workoutService *WorkoutService
}

func NewAnalyticsService(ws *WorkoutService) *AnalyticsService {
	return &AnalyticsService{
		workoutService: ws,
	}
}

func (as *AnalyticsService) GetWeeklySummary(userID uuid.UUID) []WorkoutWithExercises {
	summary := make([]WorkoutWithExercises, 0)
	history, err := as.workoutService.GetWorkoutHistory(userID)
	if err != nil {
		return summary
	}
	for _, workout := range history {
		if time.Since(workout.Workout.Date).Hours() > 7*24 {
			continue
		}
		summary = append(summary, workout)
	}
	return summary
}

func (as *AnalyticsService) GetProgressCharts(userID uuid.UUID) map[string]int {
	progress := make(map[string]int) // key: "year-week", value: total reps
	history, err := as.workoutService.GetWorkoutHistory(userID)
	if err != nil {
		return progress
	}
	for _, workout := range history {
		year, week := workout.Workout.Date.ISOWeek()
		key := fmt.Sprintf("%d-%02d", year, week)
		totalReps := 0
		for _, exercise := range workout.Exercises {
			totalReps += exercise.Reps
		}
		progress[key] += totalReps
	}
	return progress
}
