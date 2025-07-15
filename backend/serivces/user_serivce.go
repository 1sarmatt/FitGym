package serivces

import (
	"fitgym/backend/internal"
	"fitgym/backend/repository/model"
	"fitgym/backend/repository/postgres"

	"golang.org/x/crypto/bcrypt"
)

type User_Service struct {
	user *model.User
}

func NewUserService() *User_Service {
	return &User_Service{
		user: &model.User{},
	}
}

func (service *User_Service) Register(email, password string, repo postgres.UserRepository) (*internal.TokenPair, error) {
	// Check if user already exists in the database
	existingUser, err := repo.GetUserByEmail(email)
	if err == nil && existingUser != nil {
		return nil, ErrorUserAlreadyExists
	}
	// Hash the password
	hash, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}
	newUser := &model.User{
		Email:        email,
		PasswordHash: string(hash),
	}
	if err := repo.CreateUser(newUser); err != nil {
		return nil, err
	}
	service.user = newUser

	// Generate JWT token pair
	tokenPair, err := internal.GenerateTokenPair(service.user.Email)
	if err != nil {
		return nil, err
	}
	return tokenPair, nil
}

func (service *User_Service) Login(email, password string, repo postgres.UserRepository) (*internal.TokenPair, error) {
	// Fetch user from repository
	user, err := repo.GetUserByEmail(email)
	if err != nil || user == nil {
		return nil, ErrorInvalidCredentials
	}
	// Compare password hash
	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(password)); err != nil {
		return nil, ErrorInvalidCredentials
	}
	service.user = user

	// Generate JWT token pair
	tokenPair, err := internal.GenerateTokenPair(service.user.Email)
	if err != nil {
		return nil, err
	}
	return tokenPair, nil
}

func (service *User_Service) EditProfile(name string, age int, repo postgres.UserRepository) (bool, error) {
	if name == "" {
		return false, ErrorUserNameEmpty
	}
	if age < 0 {
		return false, ErrorUserAge
	}
	user := service.user
	user.Name = name
	user.Age = age
	if err := repo.UpdateUser(user); err != nil {
		return false, err
	}
	service.user = user
	return true, nil
}
