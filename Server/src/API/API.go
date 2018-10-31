package API

import (
	"Entities"
	"Repository"
	"encoding/json"
	"github.com/gorilla/mux"
	"log"
	"net/http"
)

type API struct {
	url              string
	port             string
	levelsRepository Repository.IRepository
}

func APIBuilder(url string, port string, repo Repository.IRepository) API{
	obj := API{ url: url, port: port, levelsRepository: repo }

	return obj
}

func (this *API) StartServer() {
	router := mux.NewRouter()

	// Add Routes
	router.HandleFunc("/levels", this.GetAllLevels).Methods("GET")
	router.HandleFunc("/levels", this.AddLevel).Methods("POST")
	router.HandleFunc("/levels/{levelName}", this.GetLevelByName).Methods("GET")
	router.HandleFunc("/levels/{levelName}", this.UpdateLevelByName).Methods("PUT")
	router.HandleFunc("/levels/{levelName}", this.DeleteLevelByName).Methods("DELETE")

	// Start the router
	log.Fatal(http.ListenAndServe(this.port, router))
}

func (this *API) GetAllLevels(w http.ResponseWriter, r *http.Request) {
	// Get all the levels
	levels, err := this.levelsRepository.GetLevels()

	// Show the response
	if err != nil {
		w.WriteHeader(500)
		json.NewEncoder(w).Encode("Error")
		return
	}

	json.NewEncoder(w).Encode(levels)
}

func (this *API) GetLevelByName(w http.ResponseWriter, r *http.Request) {
	// Get the query parameter
	params := mux.Vars(r)
	levelName := params["levelName"]

	// Get the actual level
	level, err := this.levelsRepository.GetLevelByName(levelName)

	// Show the response
	if err != nil {
		w.WriteHeader(404)
		json.NewEncoder(w).Encode("Error, level not found")
		return
	}

	json.NewEncoder(w).Encode(level)
}

func (this *API) AddLevel(w http.ResponseWriter, r *http.Request) {
	decoder := json.NewDecoder(r.Body)
	var newLevel Entities.Level
	err := decoder.Decode(&newLevel)

	if err != nil {
		w.WriteHeader(400)
		json.NewEncoder(w).Encode("Level not formated correctly")
		return
	}

	// Update the level
	err = this.levelsRepository.AddLevel(newLevel)
	if err != nil {
		w.WriteHeader(400)
		json.NewEncoder(w).Encode(err)
		return
	}

	//json.NewEncoder(w).Encode("OK")
	json.NewEncoder(w).Encode(map[string]string{"msg": "OK", "code": "200"})
}

func (this *API) UpdateLevelByName(w http.ResponseWriter, r *http.Request) {
	// Get the query parameter
	params := mux.Vars(r)
	levelName := params["levelName"]

	decoder := json.NewDecoder(r.Body)
	var newLevel Entities.Level
	err := decoder.Decode(&newLevel)

	if err != nil {
		w.WriteHeader(400)
		json.NewEncoder(w).Encode(err)
		return
	}

	// Update the level
	err = this.levelsRepository.UpdateLevel(levelName, newLevel)
	if err != nil {
		w.WriteHeader(400)
		json.NewEncoder(w).Encode("Problems with the name of the level")
		return
	}

	json.NewEncoder(w).Encode("OK")
}

func (this *API) DeleteLevelByName(w http.ResponseWriter, r *http.Request) {
	// Get the query parameter
	params := mux.Vars(r)
	levelName := params["levelName"]

	// Get the actual level
	err := this.levelsRepository.DeleteLevel(levelName)

	// Show the response
	if err != nil {
		w.WriteHeader(404)
		json.NewEncoder(w).Encode("Error, level not found")
		return
	}

	json.NewEncoder(w).Encode("OK")
}


