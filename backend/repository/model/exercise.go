package model

import (
	"github.com/google/uuid"
)

type Exercise struct {
	ID        uuid.UUID `gorm:"type:uuid;primary_key"`
	Name      string
	Reps      int
	Weight    int
	WorkoutID uuid.UUID `gorm:"type:uuid"`
}
