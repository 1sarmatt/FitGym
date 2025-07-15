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

// AddFriend создает двустороннюю запись о дружбе
func (r *FriendRepository) AddFriend(userID, friendID uuid.UUID) error {
	friendship1 := &model.Friend{
		ID:       uuid.New(),
		UserID:   userID,
		FriendID: friendID,
	}
	friendship2 := &model.Friend{
		ID:       uuid.New(),
		UserID:   friendID,
		FriendID: userID,
	}
	// Используем транзакцию для атомарности
	return r.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(friendship1).Error; err != nil {
			return err
		}
		if err := tx.Create(friendship2).Error; err != nil {
			return err
		}
		return nil
	})
}

// RemoveFriend удаляет запись о дружбе
func (r *FriendRepository) RemoveFriend(userID, friendID uuid.UUID) error {
	return r.db.Where("user_id = ? AND friend_id = ?", userID, friendID).Delete(&model.Friend{}).Error
}

// GetFriends возвращает список друзей пользователя
func (r *FriendRepository) GetFriends(userID uuid.UUID) ([]model.Friend, error) {
	var friends []model.Friend
	if err := r.db.Table("friends").Where("user_id = ?", userID).Find(&friends).Error; err != nil {
		return nil, err
	}
	return friends, nil
}
