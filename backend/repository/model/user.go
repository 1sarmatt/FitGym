package model

import (
	"github.com/google/uuid"
)

type User struct {
	ID    uuid.UUID `gorm:"type:uuid;primary_key"`
	Name  string
	Age   int
	Goals []Goal
}
