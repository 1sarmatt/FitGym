package model

import (
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Goal struct {
	gorm.Model
	ID        uuid.UUID `gorm:"type:uuid;primary_key"`
	Title     string
	Completed bool
	UserID    uuid.UUID `gorm:"type:uuid"`
}
