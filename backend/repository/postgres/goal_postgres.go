package postgres

import (
	"fitgym/backend/repository/model"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type GoalRepository struct {
	db *gorm.DB
}

func NewGoalRepository(db *gorm.DB) *GoalRepository {
	return &GoalRepository{db: db}
}

func (r *GoalRepository) CreateGoal(goal *model.Goal) error {
	goal.ID = uuid.New()
	return r.db.Create(goal).Error
}

func (r *GoalRepository) GetByID(id uuid.UUID) (*model.Goal, error) {
	var goal model.Goal
	if err := r.db.Where("id = ?", id).First(&goal).Error; err != nil {
		return nil, err
	}
	return &goal, nil
}

func (r *GoalRepository) GetAll() ([]model.Goal, error) {
	var goals []model.Goal
	if err := r.db.Find(&goals).Error; err != nil {
		return nil, err
	}
	return goals, nil
}

func (r *GoalRepository) DeleteGoal(goal *model.Goal) error {
	return r.db.Delete(goal).Error
}
