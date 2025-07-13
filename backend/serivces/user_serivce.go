package serivces

import (
	"fitgym/backend/repository/model"
)

type User_Service struct {
	user *model.User
}

func NewUserService() *User_Service {
	return &User_Service{
		user: &model.User{},
	}
}

func (service *User_Service) Register() {

}

func (service *User_Service) Login() {

}

func (service *User_Service) EditProfile(index int, name string, age int) (bool, error) {
	if name == "" {
		return false, ErrorUserNameEmpty
	}
	if age > 100 || age < 5 {
		return false, ErrorUserAge
	}

	user := service.user

	user.Name = name
	user.Age = age

	service.user = user
	return true, nil
}

func (service *User_Service) SetGoals() {

}
