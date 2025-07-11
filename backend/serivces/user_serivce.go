package serivces

import (
	"errors"
	"fitgym/backend/repository/model"
)

var (
	ErrorUserNameEmpty = errors.New("Username cannot be empty")
	ErrorUserAge       = errors.New("User age does not meet the requirements")
)

type User_Service struct {
	users map[int]model.User
}

func New_User_Service() *User_Service {
	return &User_Service{
		users: make(map[int]model.User),
	}
}

func (service *User_Service) Register() {

}

func (service *User_Service) Login() {

}

func (service *User_Service) Edit_Profile(index int, name string, age int) (bool, error) {
	if name == "" {
		return false, ErrorUserNameEmpty
	}
	if age > 100 || age < 5 {
		return false, ErrorUserAge
	}

	user := service.users[index]

	user.Name = name
	user.Age = age

	service.users[index] = user
	return true, nil
}

func (service *User_Service) Set_Goals() {

}
