package model

import (
	"time"

	"github.com/google/uuid"
)

type Workout struct {
	ID          uuid.UUID `gorm:"type:uuid;primary_key"`
	UserID      uuid.UUID `gorm:"type:uuid"`
	WorkoutName string
	Notes       string
	Date        time.Time `gorm:"type:date"`
	Completed   bool
}
