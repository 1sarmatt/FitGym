package model


type User struct {
	ID    int
	Name  string
	Age   int
	Goals []Goal
}

func NewUser(name string, age int) *User {
	return &User{
		ID:    1, //should be changed
		Name:  name,
		Age:   age,
		Goals: make([]Goal, 0),
	}
}
