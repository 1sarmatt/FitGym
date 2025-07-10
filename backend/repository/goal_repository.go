package repository

import (
	"database/sql"
	"errors"

	"fitgym/backend/model"
)

type GoalRepository struct {
	db *sql.DB
}

func NewGoalRepository(db *sql.DB) *GoalRepository {
	return &GoalRepository{db: db}
}

// add new goal into database
func (r *GoalRepository) CreateGoal(goal *model.Goal) error {
	query := `INSERT INTO goal (title, completed) VALUES ($1, $2) RETURNING id`
	err := r.db.QueryRow(query, goal.TITLE, goal.COMPLETED).Scan(&goal.ID)
	return err
}

// get goal from database by ID
func (r *GoalRepository) GetByID(id int) (*model.Goal, error) {
	goal := &model.Goal{}

	err := r.db.QueryRow(
		`SELECT id, title, completed FROM goal WHERE id = $1`,
		id,
	).Scan(&goal.ID, &goal.TITLE, &goal.COMPLETED)

	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, errors.New("goal not found")
		}
		return nil, err
	}

	return goal, nil
}

// Get all goals
func (r *GoalRepository) GetAll() ([]model.Goal, error) {
	rows, err := r.db.Query(`SELECT id, title, completed FROM goal`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var goals []model.Goal

	for rows.Next() {
		var goal model.Goal
		err := rows.Scan(&goal.ID, &goal.TITLE, &goal.COMPLETED)
		if err != nil {
			return nil, err
		}
		goals = append(goals, goal)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return goals, nil
}

// function to update goal
func (r *GoalRepository) Update(goal *model.Goal) error {
	result, err := r.db.Exec(
		`UPDATE goal SET title = $1, completed = $2 WHERE id = $3`,
		goal.TITLE, goal.COMPLETED, goal.ID,
	)
	if err != nil {
		return err
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return err
	}

	if rowsAffected == 0 {
		return errors.New("no rows affected - goal not found")
	}

	return nil
}

// Delete a goal
func (r *GoalRepository) Delete(id int) error {
	result, err := r.db.Exec(`DELETE FROM goal WHERE id = $1`, id)
	if err != nil {
		return err
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return err
	}

	if rowsAffected == 0 {
		return errors.New("no rows affected - goal not found")
	}

	return nil
}

// Toggle goal completion status
func (r *GoalRepository) ToggleComplete(id int) error {
	_, err := r.db.Exec(
		`UPDATE goals SET completed = NOT completed WHERE id = $1`,
		id,
	)
	return err
}
