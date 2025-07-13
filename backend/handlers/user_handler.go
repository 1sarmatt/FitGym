package handlers

import (
	"net/http"

	"fitgym/backend/serivces"
)

var userHandler *serivces.User_Service

// Handler for editing user profile
func EditProfileHandler(w http.ResponseWriter, r *http.Request) {
	// TODO: implement edit profile logic
}

// Handler for registration of user
func RegisterUserHandler(w http.ResponseWriter, r *http.Request) {
	type reqbody struct {
		UserID string `json:"user_id"`
		Name   string `json:"name"`
		Age    int    `json:"age"`
	}

}
