// Package postgres provides repository implementations for PostgreSQL using GORM.
package postgres

import (
  "fitgym/backend/repository/model"

  "github.com/google/uuid"
  "gorm.io/gorm"
)

// UserRepository handles CRUD operations for User model in PostgreSQL.
type UserRepository struct {
  db *gorm.DB // GORM database connection
}

// NewUserRepository creates a new UserRepository with the given GORM DB.
func NewUserRepository(db *gorm.DB) *UserRepository {
  return &UserRepository{db: db}
}

// CreateUser inserts a new user into the database and assigns a new UUID.
func (r *UserRepository) CreateUser(user *model.User) error {
  user.ID = uuid.New()
  return r.db.Create(user).Error
}

// GetUserByID retrieves a user by their UUID.
func (r *UserRepository) GetUserByID(id uuid.UUID) (*model.User, error) {
  var user model.User
  if err := r.db.Where("id = ?", id).First(&user).Error; err != nil {
    return nil, err
  }
  return &user, nil
}

// GetUserByName retrieves a user by their name.
func (r *UserRepository) GetUserByName(name string) (*model.User, error) {
  var user model.User
  if err := r.db.Where("name = ?", name).First(&user).Error; err != nil {
    return nil, err
  }
  return &user, nil
}

// GetUserByEmail retrieves a user by their email.
func (r *UserRepository) GetUserByEmail(email string) (*model.User, error) {
  var user model.User
  if err := r.db.Where("email = ?", email).First(&user).Error; err != nil {
    return nil, err
  }
  return &user, nil
}

// UpdateUser updates the given user in the database.
func (r *UserRepository) UpdateUser(user *model.User) error {
  return r.db.Save(user).Error
}

// DeleteUser removes the given user from the database.
func (r *UserRepository) DeleteUser(user *model.User) error {
  return r.db.Delete(user).Error
}
