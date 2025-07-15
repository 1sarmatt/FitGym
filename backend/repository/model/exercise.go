package model

import (
	"github.com/google/uuid"
)

type Exercise struct {
	ID        uuid.UUID `gorm:"type:uuid;primary_key" json:"id"`
	Name      string    `json:"name"`
	Sets      int       `json:"sets"`
	Reps      int       `json:"reps"`
	Weight    int       `json:"weight"`
	WorkoutID uuid.UUID `gorm:"type:uuid" json:"workout_id"`
}
