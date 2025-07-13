package serivces

import (
	"fitgym/backend/repository/model"
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

func (as *AnalyticsService) GetWeeklySummary(userID uuid.UUID) []model.Workout {
	var weeklyWorkouts []model.Workout
	history, err := as.workoutService.GetWorkoutHistory(userID)
	if err != nil {
		return weeklyWorkouts
	}
	now := time.Now()
	year, week := now.ISOWeek()
	for _, workout := range history {
		wYear, wWeek := workout.Date.ISOWeek()
		if wYear == year && wWeek == week {
			weeklyWorkouts = append(weeklyWorkouts, workout)
		}
	}
	return weeklyWorkouts
}

func (as *AnalyticsService) GetProgressCharts(userID uuid.UUID) map[string]int {
	progress := make(map[string]int) // key: "year-week", value: total reps
	history, err := as.workoutService.GetWorkoutHistory(userID)
	if err != nil {
		return progress
	}
	for _, workout := range history {
		year, week := workout.Date.ISOWeek()
		key := fmt.Sprintf("%d-%02d", year, week)
		totalReps := 0
		for _, exercise := range workout.Exercises {
			totalReps += exercise.Reps
		}
		progress[key] += totalReps
	}
	return progress
}
