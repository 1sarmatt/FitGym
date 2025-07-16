package handlers

import (
	"encoding/json"
	"fitgym/backend/repository/postgres"
	"log"
	"net/http"
)

// AddFriendRequest represents the request body for adding a friend
type AddFriendRequest struct {
	FriendEmail string `json:"friend_email"`
}

var FriendRepo *postgres.FriendRepository

// AddFriendHandler godoc
// @Summary Add friend
// @Description Adds a friend to the user's friend list
// @Tags friend
// @Accept  json
// @Produce  json
// @Param   friend  body  AddFriendRequest  true  "Friend info"
// @Success 200 {object} map[string]string
// @Failure 400 {string} string "Invalid request body"
// @Failure 401 {string} string "Unauthorized"
// @Router /addFriend [post]
// @Security BearerAuth
func AddFriendHandler(w http.ResponseWriter, r *http.Request) {

	userEmail, ok := r.Context().Value("Email").(string)
	if !ok {
		http.Error(w, "Unable to get user information", http.StatusUnauthorized)
		return
	}

	var req AddFriendRequest

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, errInvalidRequestBody, http.StatusBadRequest)
		return
	}

	friendID, err := UserRepo.GetUserIDByEmail(req.FriendEmail)
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

// GetFriendsHandler godoc
// @Summary Get friends
// @Description Retrieves the user's friend list
// @Tags friend
// @Produce  json
// @Success 200 {array} map[string]interface{}
// @Failure 401 {string} string "Unauthorized"
// @Failure 404 {string} string "User not found"
// @Router /getFriends [get]
// @Security BearerAuth
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
