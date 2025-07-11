package serivces

import (
	"errors"
)

var (
	ErrorWorkoutTypeEmpty = errors.New("Workut type cannot be empty")
	ErrorUserNameEmpty    = errors.New("Username cannot be empty")
	ErrorUserAge          = errors.New("User age does not meet the requirements")
	ErrorUserID           = errors.New("User id does not meet the requirements")
	ErrorWorkoutID        = errors.New("Workout id does not meet the requirements")
	ErrorDuration         = errors.New("Duration does not meet the requirements")
	ErrorWorkoutNameEmpty = errors.New("Workout name cannot be empty")
	ErrorSetsReps         = errors.New("Sets/Reps does not meet the requirements")
	ErrorWeight           = errors.New("Weight does not meet the requirements")
)
