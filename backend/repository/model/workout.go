package model

import (
	"time"

	"github.com/google/uuid"
)

type Workout struct {
	ID         uuid.UUID   `gorm:"type:uuid;primary_key" json:"id"`
	UserID     uuid.UUID   `gorm:"type:uuid" json:"user_id"`
	Notes      string      `json:"notes"`
	Date       time.Time   `gorm:"type:date" json:"date"`
	Exercises  []Exercise  `json:"exercises"`
	Completed  bool        `json:"completed"`
	WorkoutType string     `json:"type"`
}
