package handlers

import (
	"encoding/json"
	"fitgym/backend/repository/postgres"

	"log"
	"net/http"

	"github.com/google/uuid"
)

func AddFriendHandler(w http.ResponseWriter, r *http.Request) {
	type reqBody struct {
		UserID   uuid.UUID `json:"user_id"`
		FriendID uuid.UUID `json:"friend_id"`
	}
	var req reqBody

	err := postgres.AddFriend(req.UserID, req.FriendID)
	log.Logger(err)
}

func GetFriendsHandler(w http.ResponseWriter, r *http.Request) {
	type reqBody struct {
		UserID uuid.UUID `json:"user_id"`
	}
	var req reqBody
	user, err := postgres.GetFriends(req.UserID)
	log.Logger(err)
	json.NewEncoder(w).Encode(user)
}
