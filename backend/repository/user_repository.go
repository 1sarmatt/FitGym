package repository

import (
	"database/sql"
	"fitgym/backend/model"
)

type UserRepository struct {
	db *sql.DB
}

func NewUserRepository(db *sql.DB) *UserRepository {
	return &UserRepository{db: db}
}

// Create a new user and return created user with ID
func (r *UserRepository) CreateUser(user *model.User) error {
	query := `INSERT INTO user (name, age) VALUES ($1, $2) RETURNING id`
	err := r.db.QueryRow(query, user.Name, user.Age).Scan(&user.ID)
	return err
}

// return model.User and error(if exist) after adding user information to database
func (r *UserRepository) GetUserByID(id int) (*model.User, error) {
	user := &model.User{}

	err := r.db.QueryRow(
		`SELECT id, name, age FROM users WHERE id = $1`,
		id,
	).Scan(&user.ID, &user.Name, &user.Age)

	if err != nil {
		return nil, err
	}

	rows, err := r.db.Query(
		`SELECT id, user_id, description, completed FROM goal WHERE user_id = $1`,
		id,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var goal model.Goal
		err := rows.Scan(&goal.ID, &goal.TITLE, &goal.COMPLETED)
		if err != nil {
			return nil, err
		}
		user.Goals = append(user.Goals, goal)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return user, nil

}

// Function to update User information in DB
func (r *UserRepository) UpdateUser(user *model.User) error {
	_, err := r.db.Exec(
		`UPDATE user SET name = $1, age = $2 WHERE id = $3`,
		user.Name,
		user.Age,
		user.ID,
	)

	return err
}

// Delete all user information by userID
func (r *UserRepository) DeleteUser(id int) error {
	_, err := r.db.Exec(`DELETE FROM user WHERE user_id = $1`, id)
	return err
}

// TO-DO: add way to connect user with they goals.
