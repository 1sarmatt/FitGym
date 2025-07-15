package handlers

import (
	"encoding/json"
	"fitgym/backend/repository/postgres"
	"log"
	"net/http"
)

var FriendRepo *postgres.FriendRepository

func AddFriendHandler(w http.ResponseWriter, r *http.Request) {

	userEmail, ok := r.Context().Value("Email").(string)
	if !ok {
		http.Error(w, "Unable to get user information", http.StatusUnauthorized)
		return
	}

	type reqBody struct {
		Email string `json:"friend_email"`
	}
	var req reqBody

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, errInvalidRequestBody, http.StatusBadRequest)
		return
	}

	friendID, err := UserRepo.GetUserIDByEmail(req.Email)
	if err != nil {
		http.Error(w, "Friend user not found", http.StatusNotFound)
		return
	}

	userID, err := UserRepo.GetUserIDByEmail(userEmail)
	if err != nil {
		http.Error(w, "Current user not found", http.StatusNotFound)
		return
	}

	err = FriendRepo.AddFriend(userID, friendID)
	if err != nil {
		http.Error(w, "Failed to add friend", http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"status": "friend added"})
}

func GetFriendsHandler(w http.ResponseWriter, r *http.Request) {
	userEmail, ok := r.Context().Value("Email").(string)
	if !ok {
		http.Error(w, "Unable to get user information", http.StatusUnauthorized)
		return
	}
	userID, err := UserRepo.GetUserIDByEmail(userEmail)
	if err != nil {
		http.Error(w, "Current user not found", http.StatusNotFound)
		return
	}

	users, err := FriendRepo.GetFriends(userID)
	if err != nil {
		http.Error(w, "Failed to get friends", http.StatusInternalServerError)
		return
	}
	log.Println(users)

	var arr []string
	for _, user := range users {
		curr_user, err := UserRepo.GetUserByID(user.FriendID)
		if err != nil {
			continue // skip this friend if not found
		}

		log.Println(curr_user)
		arr = append(arr, curr_user.Email)
	}

	json.NewEncoder(w).Encode(arr)
}