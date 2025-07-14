package postgres

import (
	"fitgym/backend/repository/model"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type FriendRepository struct {
	db *gorm.DB
}

func NewFriendRepository(db *gorm.DB) *FriendRepository {
	return &FriendRepository{db: db}
}

// AddFriend создает новую запись о дружбе
func (r *FriendRepository) AddFriend(userID, friendID uuid.UUID) error {
	friendship := &model.Friend{
		ID:       uuid.New(),
		UserID:   userID,
		FriendID: friendID,
	}
	return r.db.Create(friendship).Error
}

// RemoveFriend удаляет запись о дружбе
func (r *FriendRepository) RemoveFriend(userID, friendID uuid.UUID) error {
	return r.db.Where("user_id = ? AND friend_id = ?", userID, friendID).Delete(&model.Friend{}).Error
}

// GetFriends возвращает список друзей пользователя
func (r *FriendRepository) GetFriends(userID uuid.UUID) ([]model.User, error) {
	var friends []model.User
	err := r.db.Model(&model.Friend{}).
		Joins("JOIN users ON users.id = friends.friend_id").
		Where("friends.user_id = ?", userID).
		Find(&friends).Error
	return friends, err
}
