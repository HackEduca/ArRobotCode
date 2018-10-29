package Repository

import "Entities"

type IRepository interface {
	GetLevels() ([]Entities.Level, error)
	GetLevelByName(LevelName string) (Entities.Level, error)

	AddLevel(Level Entities.Level) error
	AddBucket(bucketName string) error

	UpdateLevel(LevelName string, newLevel Entities.Level) error

	DeleteBucket(bucketName string) error
	DeleteLevel(LevelName string) error
}