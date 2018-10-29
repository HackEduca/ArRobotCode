package Repository

import (
"Entities"
"fmt"
"github.com/couchbase/gocb"
)

type CouchBaseRepository struct {
	dbConnectionUrl   string
	dbUserName        string
	dbPassword        string
	cluster           *gocb.Cluster
	levelsBucket *gocb.Bucket
}

func CouchBaseRepositoryBuilder(levelsBucketName string) IRepository {
	// Create the repository object
	cbr := CouchBaseRepository{}

	// Fill it in with all the info
	cbr.dbConnectionUrl = "http://127.0.0.1:8091"
	cbr.dbUserName = "sorynsoo"
	cbr.dbPassword = "inventor15"


	// Make the database connection
	cbr.connectToDatabase(levelsBucketName)

	// Return build object
	return &cbr // ?
}

func (repo *CouchBaseRepository) connectToDatabase(levelsBucketName string) {
	repo.cluster, _ = gocb.Connect("http://127.0.0.1:8091")
	repo.cluster.Authenticate(gocb.PasswordAuthenticator{
		Username: "sorynsoo",
		Password: "inventor15",
	})

	repo.levelsBucket, _ = repo.cluster.OpenBucket(levelsBucketName, "")
}

func (repo *CouchBaseRepository) GetLevels() ([]Entities.Level, error) {
	var levels []Entities.Level

	// Make the query
	myQuery := gocb.NewN1qlQuery("SELECT * FROM levels")
	rows, err := repo.levelsBucket.ExecuteN1qlQuery(myQuery, nil)

	// Get through the rows and append them to the list
	var row map[string] Entities.Level
	for rows.Next(&row) {
		levels = append(levels, row["levels"])
	}

	// Error handling
	if err != nil {
		return []Entities.Level{}, fmt.Errorf("Couldn't get all the levels: %s\n", err)
	}

	return levels, nil
}

func (repo *CouchBaseRepository) GetLevelByName(levelName string) (Entities.Level, error) {
	var level Entities.Level
	cas, err := repo.levelsBucket.Get(levelName, &level)

	if err != nil {
		return Entities.Level{}, fmt.Errorf("Couldn't get the level by the name: %s - %s\n", cas, err)
	}

	return level, nil
}

func (repo *CouchBaseRepository) AddLevel(level Entities.Level) error {
	// Create Primary key if it doesn't exist
	repo.levelsBucket.Manager("sorynsoo", "inventor15").CreatePrimaryIndex("levelsByName", true, false)

	// Insert the level
	cas, err := repo.levelsBucket.Insert(level.Name, level, 0)

	if err != nil {
		return fmt.Errorf("Couldn't add the level: %s-%s\n", cas, err)
	}

	return nil
}

func (repo *CouchBaseRepository) AddBucket(bucketName string) error {
	bucketSettings := gocb.BucketSettings {
		FlushEnabled: true,
		IndexReplicas: true,
		Name: bucketName,
		Password: "",
		Quota: 100,
		Replicas: 0,
		Type: gocb.Couchbase,
	}

	manager := repo.cluster.Manager("sorynsoo", "inventor15")
	err := manager.UpdateBucket(&bucketSettings)

	if err != nil {
		return fmt.Errorf("Couldn't add a bucket: %s\n", err);
	}

	return nil
}

func (repo *CouchBaseRepository) UpdateLevel(levelName string, newlevel Entities.Level) error {
	// If level does not change its name, just replace the content
	if levelName == newlevel.Name {
		cas, err := repo.levelsBucket.Replace(levelName, newlevel, 0, 0)

		if err != nil {
			return fmt.Errorf("Couldn't update the level: %s - %s\n", cas, err);
		}
	} else { // Otherwise, perform a delete of the old level name and a new addition
		_, err1 := repo.GetLevelByName(levelName)
		_, err2 := repo.GetLevelByName(newlevel.Name)

		// Check if one of the levels already exist
		if err1 != nil || err2 == nil {
			return fmt.Errorf("Couldn't update the level: old level name does not exist or new level name exists")
		}

		err := repo.DeleteLevel(levelName)
		if err != nil {
			return fmt.Errorf("Couldn't update the level: %s\n", err);
		}

		err = repo.AddLevel(newlevel)
		if err != nil {
			return fmt.Errorf("Couldn't update the level: %s\n", err);
		}
	}

	return nil
}

func (repo *CouchBaseRepository) DeleteLevel(levelName string) error {
	cas, err := repo.levelsBucket.Remove(levelName, 0)
	if err != nil {
		return fmt.Errorf("Couldn't delete the level: %s - %s\n", cas, err);
	}

	return nil
}

func (repo *CouchBaseRepository) DeleteBucket(bucketName string) error {
	manager := repo.cluster.Manager("sorynsoo", "inventor15")
	err := manager.RemoveBucket(bucketName)

	if err != nil {
		return fmt.Errorf("Couldn't delete the bucket: %s\n", err);
	}

	return nil
}
