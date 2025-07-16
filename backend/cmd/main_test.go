package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
)

// Note: For these tests to pass, the server must be running.
const (
	BASE_URL          = "http://localhost:8080"
	ContentTypeJSON   = "application/json"
	ContentTypeHeader = "Content-Type"
	AuthHeader        = "Authorization"
	BearerPrefix      = "Bearer "
)

func registerUser(t *testing.T, email, password string) {
	body := fmt.Sprintf(`{"email": "%s", "password": "%s"}`, email, password)
	req, _ := http.NewRequest("POST", fmt.Sprintf("%s/register", BASE_URL), bytes.NewBufferString(body))
	req.Header.Set(ContentTypeHeader, ContentTypeJSON)

	client := &http.Client{}
	resp, err := client.Do(req)
	require.NoError(t, err)
	require.Equal(t, http.StatusOK, resp.StatusCode)
	resp.Body.Close()
}

func TestAPIEndpoints(t *testing.T) {
	// --- User Endpoints ---
	var accessToken string
	var refreshToken string
	var userID string

	uniqueEmail := fmt.Sprintf("test-%d@example.com", time.Now().UnixNano())
	userPassword := "password123"

	friendEmail := fmt.Sprintf("friend-%d@example.com", time.Now().UnixNano())
	friendPassword := "password123"

	// Register a "friend" user for friend-related tests
	registerUser(t, friendEmail, friendPassword)

	t.Run("Register User", func(t *testing.T) {
		body := fmt.Sprintf(`{"email": "%s", "password": "%s"}`, uniqueEmail, userPassword)
		req, _ := http.NewRequest("POST", fmt.Sprintf("%s/register", BASE_URL), bytes.NewBufferString(body))
		req.Header.Set(ContentTypeHeader, ContentTypeJSON)

		client := &http.Client{}
		resp, err := client.Do(req)
		require.NoError(t, err)
		require.Equal(t, http.StatusOK, resp.StatusCode)
	})

	t.Run("Login User", func(t *testing.T) {
		body := fmt.Sprintf(`{"email": "%s", "password": "%s"}`, uniqueEmail, userPassword)
		req, _ := http.NewRequest("POST", fmt.Sprintf("%s/login", BASE_URL), bytes.NewBufferString(body))
		req.Header.Set(ContentTypeHeader, ContentTypeJSON)

		client := &http.Client{}
		resp, err := client.Do(req)
		require.NoError(t, err)
		require.Equal(t, http.StatusOK, resp.StatusCode)

		var tokens map[string]string
		err = json.NewDecoder(resp.Body).Decode(&tokens)
		require.NoError(t, err)
		accessToken = tokens["access_token"]
		refreshToken = tokens["refresh_token"]
		require.NotEmpty(t, accessToken)
		require.NotEmpty(t, refreshToken)
	})

	t.Run("Refresh Token", func(t *testing.T) {
		body := fmt.Sprintf(`{"refresh_token": "%s"}`, refreshToken)
		req, _ := http.NewRequest("POST", fmt.Sprintf("%s/refresh", BASE_URL), bytes.NewBufferString(body))
		req.Header.Set(ContentTypeHeader, ContentTypeJSON)

		client := &http.Client{}
		resp, err := client.Do(req)
		require.NoError(t, err)
		require.Equal(t, http.StatusOK, resp.StatusCode)

		var result map[string]string
		err = json.NewDecoder(resp.Body).Decode(&result)
		require.NoError(t, err)
		require.NotEmpty(t, result["access_token"])
		accessToken = result["access_token"] // Update with new access token
	})

	t.Run("Get User Profile", func(t *testing.T) {
		req, _ := http.NewRequest("GET", fmt.Sprintf("%s/profile", BASE_URL), nil)
		req.Header.Set(AuthHeader, BearerPrefix+accessToken)

		client := &http.Client{}
		resp, err := client.Do(req)
		require.NoError(t, err)
		require.Equal(t, http.StatusOK, resp.StatusCode)

		var profile map[string]interface{}
		err = json.NewDecoder(resp.Body).Decode(&profile)
		require.NoError(t, err)
		require.Equal(t, uniqueEmail, profile["email"])

		id, ok := profile["id"].(string)
		require.True(t, ok, "profile['id'] should be a string")
		require.NotEmpty(t, id)
		userID = id
	})

	t.Run("Edit User Profile", func(t *testing.T) {
		body := `{"name": "Test User", "age": 30}`
		req, _ := http.NewRequest("PUT", fmt.Sprintf("%s/editProfile", BASE_URL), bytes.NewBufferString(body))
		req.Header.Set(AuthHeader, BearerPrefix+accessToken)
		req.Header.Set(ContentTypeHeader, ContentTypeJSON)

		client := &http.Client{}
		resp, err := client.Do(req)
		require.NoError(t, err)
		require.Equal(t, http.StatusOK, resp.StatusCode)
	})

	// --- Workout Endpoints ---
	var workoutID string

	t.Run("Add Workout", func(t *testing.T) {
		date := time.Now().Format("2006-01-02")
		body := fmt.Sprintf(`{
			"user_id": "%s",
			"workout_type": "strength",
			"date": "%s",
			"notes": "Morning workout session",
			"exercises": [
				{"name": "Push-ups", "sets": 3, "reps": 15, "weight": 0},
				{"name": "Squats", "sets": 3, "reps": 12, "weight": 50}
			]
		}`, userID, date)
		req, _ := http.NewRequest("POST", fmt.Sprintf("%s/addWorkout", BASE_URL), bytes.NewBufferString(body))
		req.Header.Set(AuthHeader, BearerPrefix+accessToken)
		req.Header.Set(ContentTypeHeader, ContentTypeJSON)

		client := &http.Client{}
		resp, err := client.Do(req)
		require.NoError(t, err)
		require.Equal(t, http.StatusOK, resp.StatusCode)

		var result map[string]string
		err = json.NewDecoder(resp.Body).Decode(&result)
		require.NoError(t, err)
		workoutID = result["workout_id"]
		require.NotEmpty(t, workoutID)
	})

	t.Run("Add Exercise", func(t *testing.T) {
		body := fmt.Sprintf(`{"workout_id": "%s", "name": "Push-ups", "sets": 3, "reps": 15, "weight": 0}`, workoutID)
		req, _ := http.NewRequest("POST", fmt.Sprintf("%s/addExercise", BASE_URL), bytes.NewBufferString(body))
		req.Header.Set(AuthHeader, BearerPrefix+accessToken)
		req.Header.Set(ContentTypeHeader, ContentTypeJSON)

		client := &http.Client{}
		resp, err := client.Do(req)
		require.NoError(t, err)
		require.Equal(t, http.StatusOK, resp.StatusCode)
	})

	t.Run("Get Workouts", func(t *testing.T) {
		req, _ := http.NewRequest("GET", fmt.Sprintf("%s/getWorkouts?user_id=%s", BASE_URL, userID), nil)
		req.Header.Set(AuthHeader, BearerPrefix+accessToken)

		client := &http.Client{}
		resp, err := client.Do(req)
		require.NoError(t, err)
		require.Equal(t, http.StatusOK, resp.StatusCode)
	})

	t.Run("Get Workout History", func(t *testing.T) {
		req, _ := http.NewRequest("GET", fmt.Sprintf("%s/getWorkoutHistory?user_id=%s", BASE_URL, userID), nil)
		req.Header.Set(AuthHeader, BearerPrefix+accessToken)

		client := &http.Client{}
		resp, err := client.Do(req)
		require.NoError(t, err)
		require.Equal(t, http.StatusOK, resp.StatusCode)
	})

	// t.Run("Edit Workout", func(t *testing.T) {
	// 	body := fmt.Sprintf(`{"workout_id": "%s", "name": "Intense Morning Workout"}`, workoutID)
	// 	req, _ := http.NewRequest("PUT", fmt.Sprintf("%s/editWorkout", BASE_URL), bytes.NewBufferString(body))
	// 	req.Header.Set(AuthHeader, BearerPrefix+accessToken)
	// 	req.Header.Set(ContentTypeHeader, ContentTypeJSON)

	// 	client := &http.Client{}
	// 	resp, err := client.Do(req)
	// 	require.NoError(t, err)
	// 	require.Equal(t, http.StatusOK, resp.StatusCode)
	// })

	t.Run("Complete Workout", func(t *testing.T) {
		body := fmt.Sprintf(`{"workout_id": "%s"}`, workoutID)
		req, _ := http.NewRequest("POST", fmt.Sprintf("%s/completeWorkout", BASE_URL), bytes.NewBufferString(body))
		req.Header.Set(AuthHeader, BearerPrefix+accessToken)
		req.Header.Set(ContentTypeHeader, ContentTypeJSON)

		client := &http.Client{}
		resp, err := client.Do(req)
		require.NoError(t, err)
		require.Equal(t, http.StatusOK, resp.StatusCode)
	})

	// t.Run("Delete Workout", func(t *testing.T) {
	// 	body := fmt.Sprintf(`{"workout_id": "%s"}`, workoutID)
	// 	req, _ := http.NewRequest("DELETE", fmt.Sprintf("%s/deleteWorkout", BASE_URL), bytes.NewBufferString(body))
	// 	req.Header.Set(AuthHeader, BearerPrefix+accessToken)
	// 	req.Header.Set(ContentTypeHeader, ContentTypeJSON)

	// 	client := &http.Client{}
	// 	resp, err := client.Do(req)
	// 	require.NoError(t, err)
	// 	require.Equal(t, http.StatusOK, resp.StatusCode)
	// })

	// --- Friend Endpoints ---
	t.Run("Add Friend", func(t *testing.T) {
		body := fmt.Sprintf(`{"friend_email": "%s"}`, friendEmail)
		req, _ := http.NewRequest("POST", fmt.Sprintf("%s/addFriend", BASE_URL), bytes.NewBufferString(body))
		req.Header.Set(AuthHeader, BearerPrefix+accessToken)
		req.Header.Set(ContentTypeHeader, ContentTypeJSON)

		client := &http.Client{}
		resp, err := client.Do(req)
		require.NoError(t, err)
		require.Equal(t, http.StatusOK, resp.StatusCode)
	})

	t.Run("Get Friends", func(t *testing.T) {
		req, _ := http.NewRequest("GET", fmt.Sprintf("%s/getFriends", BASE_URL), nil)
		req.Header.Set(AuthHeader, BearerPrefix+accessToken)

		client := &http.Client{}
		resp, err := client.Do(req)
		require.NoError(t, err)
		require.Equal(t, http.StatusOK, resp.StatusCode)
	})

	// t.Run("Get Friend Workouts by Email", func(t *testing.T) {
	// 	req, _ := http.NewRequest("GET", fmt.Sprintf("%s/getFriendWorkoutsByEmail?email=%s", BASE_URL, friendEmail), nil)
	// 	req.Header.Set(AuthHeader, BearerPrefix+accessToken)

	// 	client := &http.Client{}
	// 	resp, err := client.Do(req)
	// 	require.NoError(t, err)
	// 	require.Equal(t, http.StatusOK, resp.StatusCode)
	// })

	// --- Protected Test Endpoint ---
	t.Run("Protected Route", func(t *testing.T) {
		req, _ := http.NewRequest("GET", fmt.Sprintf("%s/protected", BASE_URL), nil)
		req.Header.Set(AuthHeader, BearerPrefix+accessToken)

		client := &http.Client{}
		resp, err := client.Do(req)
		require.NoError(t, err)
		require.Equal(t, http.StatusOK, resp.StatusCode)
	})
}
