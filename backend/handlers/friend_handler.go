package handlers

import (
	"encoding/json"
	"fitgym/backend/repository/postgres"

	"log"
	"net/http"

	"github.com/google/uuid"
)

var FriendRepo *postgres.FriendRepository

func AddFriendHandler(w http.ResponseWriter, r *http.Request) {
	type reqBody struct {
		UserID   uuid.UUID `json:"user_id"`
		FriendID uuid.UUID `json:"friend_id"`
	}
	var req reqBody

	err := FriendRepo.AddFriend(req.UserID, req.FriendID)
	if err != nil {
		log.Fatal(err)
	}
}

func GetFriendsHandler(w http.ResponseWriter, r *http.Request) {
	type reqBody struct {
		UserID uuid.UUID `json:"user_id"`
	}
	var req reqBody
	user, err := FriendRepo.GetFriends(req.UserID)
	if err != nil {
		log.Fatal(err)
	}
	json.NewEncoder(w).Encode(user)
}
