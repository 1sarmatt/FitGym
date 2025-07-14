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
		log.Fatal(err)
	}

	userID, err := UserRepo.GetUserIDByEmail(userEmail)
	if err != nil {
		log.Fatal(err)
	}

	FriendRepo.AddFriend(userID, friendID)
	if err != nil {
		log.Fatal(err)
	}
}

func GetFriendsHandler(w http.ResponseWriter, r *http.Request) {
	userEmail, ok := r.Context().Value("Email").(string)
	if !ok {
		http.Error(w, "Unable to get user information", http.StatusUnauthorized)
		return
	}
	userID, err := UserRepo.GetUserIDByEmail(userEmail)
	if err != nil {
		log.Fatal(err)
	}

	users, err := FriendRepo.GetFriends(userID)
	log.Println(users)

	var arr []string
	for _, user := range users {
		curr_user, err := UserRepo.GetUserByID(user.FriendID)
		if err != nil {
			log.Fatal(err)
		}

		log.Println(curr_user)
		arr = append(arr, curr_user.Email)
	}

	if err != nil {
		log.Fatal(err)
	}
	json.NewEncoder(w).Encode(arr)
}
