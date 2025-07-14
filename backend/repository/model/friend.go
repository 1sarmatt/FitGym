package model

import (
	"github.com/google/uuid"
)

type Friend struct {
	ID       uuid.UUID `gorm:"type:uuid;primary_key"`
	UserID   uuid.UUID `gorm:"type:uuid"`
	FriendID uuid.UUID `gorm:"type:uuid"`
}
