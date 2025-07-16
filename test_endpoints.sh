#!/bin/bash

# Server base URL
BASE_URL="http://localhost:8080"

# Store tokens here. You need to manually copy them from the login response.
ACCESS_TOKEN=""
REFRESH_TOKEN=""
USER_ID="" # You might need to get this from the profile endpoint response
WORKOUT_ID="" # You might need to get this from the addWorkout response

echo "--- User Endpoints ---"

# 1. Register User
echo "Testing: POST /register"
curl -X POST $BASE_URL/register \
-H "Content-Type: application/json" \
-d '{"email": "test@example.com", "password": "password123"}'
echo -e "\n"

# 2. Login User
echo "Testing: POST /login"
echo "Please copy the access_token and refresh_token from the response below."
curl -X POST $BASE_URL/login \
-H "Content-Type: application/json" \
-d '{"email": "test@example.com", "password": "password123"}'
echo -e "\n"

# After running the above, manually set the ACCESS_TOKEN and REFRESH_TOKEN variables
# For example:
# ACCESS_TOKEN="your_access_token_here"
# REFRESH_TOKEN="your_refresh_token_here"

# 3. Refresh Token
echo "Testing: POST /refresh"
curl -X POST $BASE_URL/refresh \
-H "Content-Type: application/json" \
-d "{\"refresh_token\": \"$REFRESH_TOKEN\"}"
echo -e "\n"

# 4. Get User Profile
echo "Testing: GET /profile"
curl -X GET $BASE_URL/profile \
-H "Authorization: Bearer $ACCESS_TOKEN"
echo -e "\n"

# 5. Edit User Profile
echo "Testing: PUT /editProfile"
curl -X PUT $BASE_URL/editProfile \
-H "Authorization: Bearer $ACCESS_TOKEN" \
-H "Content-Type: application/json" \
-d '{"name": "Test User", "age": 30}'
echo -e "\n"

echo "--- Workout Endpoints ---"

# 6. Add Workout
echo "Testing: POST /addWorkout"
curl -X POST $BASE_URL/addWorkout \
-H "Authorization: Bearer $ACCESS_TOKEN" \
-H "Content-Type: application/json" \
-d "{\"user_id\": \"$USER_ID\", \"name\": \"Morning Workout\"}"
echo -e "\n"

# 7. Add Exercise
echo "Testing: POST /addExercise"
curl -X POST $BASE_URL/addExercise \
-H "Authorization: Bearer $ACCESS_TOKEN" \
-H "Content-Type: application/json" \
-d "{\"workout_id\": \"$WORKOUT_ID\", \"name\": \"Push-ups\", \"sets\": 3, \"reps\": 15, \"weight\": 0}"
echo -e "\n"

# 8. Get Workouts
echo "Testing: GET /getWorkouts"
curl -X GET $BASE_URL/getWorkouts \
-H "Authorization: Bearer $ACCESS_TOKEN"
echo -e "\n"

# 9. Get Workout History
echo "Testing: GET /getWorkoutHistory"
curl -X GET "$BASE_URL/getWorkoutHistory?user_id=$USER_ID" \
-H "Authorization: Bearer $ACCESS_TOKEN"
echo -e "\n"

# 10. Edit Workout
echo "Testing: PUT /editWorkout"
curl -X PUT $BASE_URL/editWorkout \
-H "Authorization: Bearer $ACCESS_TOKEN" \
-H "Content-Type: application/json" \
-d "{\"workout_id\": \"$WORKOUT_ID\", \"name\": \"Intense Morning Workout\"}"
echo -e "\n"

# 11. Complete Workout
echo "Testing: POST /completeWorkout"
curl -X POST $BASE_URL/completeWorkout \
-H "Authorization: Bearer $ACCESS_TOKEN" \
-H "Content-Type: application/json" \
-d "{\"workout_id\": \"$WORKOUT_ID\"}"
echo -e "\n"

# 12. Delete Workout
echo "Testing: DELETE /deleteWorkout"
curl -X DELETE $BASE_URL/deleteWorkout \
-H "Authorization: Bearer $ACCESS_TOKEN" \
-H "Content-Type: application/json" \
-d "{\"workout_id\": \"$WORKOUT_ID\"}"
echo -e "\n"

echo "--- Friend Endpoints ---"

# 13. Add Friend
echo "Testing: POST /addFriend"
curl -X POST $BASE_URL/addFriend \
-H "Authorization: Bearer $ACCESS_TOKEN" \
-H "Content-Type: application/json" \
-d '{"friend_email": "friend@example.com"}'
echo -e "\n"

# 14. Get Friends
echo "Testing: GET /getFriends"
curl -X GET $BASE_URL/getFriends \
-H "Authorization: Bearer $ACCESS_TOKEN"
echo -e "\n"

# 15. Get Friend Workouts by Email
echo "Testing: GET /getFriendWorkoutsByEmail"
curl -X GET "$BASE_URL/getFriendWorkoutsByEmail?email=friend@example.com" \
-H "Authorization: Bearer $ACCESS_TOKEN"
echo -e "\n"

echo "--- Protected Test Endpoint ---"

# 16. Protected Route
echo "Testing: GET /protected"
curl -X GET $BASE_URL/protected \
-H "Authorization: Bearer $ACCESS_TOKEN"
echo -e "\n"

echo "All tests executed."
echo "Note: You need to manually set the ACCESS_TOKEN, REFRESH_TOKEN, USER_ID, and WORKOUT_ID variables in the script for the tests to work correctly."
