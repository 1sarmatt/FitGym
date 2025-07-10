package model

type Goal struct {
	ID        int    `json:"id"`
	TITLE     string `json:"title" validate:"required,min=3,max=100"`
	COMPLETED bool   `json:"completed"`
}
