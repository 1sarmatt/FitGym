package postgres

import (
	"fitgym/backend/repository/model"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type ExerciseRepository struct {
	db *gorm.DB
}

func NewExerciseRepository(db *gorm.DB) *ExerciseRepository {
	return &ExerciseRepository{db: db}
}

func (r *ExerciseRepository) CreateExercise(exercise *model.Exercise) error {
	exercise.ID = uuid.New()
	return r.db.Create(exercise).Error
}

func (r *ExerciseRepository) GetExercisesByWorkoutID(workoutID uuid.UUID) ([]model.Exercise, error) {
	var exercises []model.Exercise
	if err := r.db.Where("workout_id = ?", workoutID).Find(&exercises).Error; err != nil {
		return nil, err
	}
	return exercises, nil
}

func (r *ExerciseRepository) DeleteExercise(exercise *model.Exercise) error {
	return r.db.Delete(exercise).Error
}

func (r *ExerciseRepository) UpdateExercise(exercise *model.Exercise) error {
	return r.db.Save(exercise).Error
}
