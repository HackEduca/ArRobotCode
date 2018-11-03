package main

import (
	"API"
	"Entities"
	"Repository"
)

func main() {
	var cbr Repository.IRepository
	cbr = Repository.CouchBaseRepositoryBuilder("levels")

	tiles := []Entities.Tile{ }
	for i := 0; i < 100; i++ {
		tiles = append(tiles, Entities.Tile{Type:0})
	}
	tiles[2] = Entities.Tile{Type: 1}
	tiles[3] = Entities.Tile{Type: 1}
	tiles[4] = Entities.Tile{Type: 1}
	tiles[5] = Entities.Tile{Type: 1}
	tiles[6] = Entities.Tile{Type: 1}


	tiles1 := []Entities.Tile{ }
	for i := 0; i < 100; i++ {
		tiles1 = append(tiles1, Entities.Tile{Type:0})
	}
	tiles1[10] = Entities.Tile{Type: 1}
	tiles1[20] = Entities.Tile{Type: 1}
	tiles1[40] = Entities.Tile{Type: 1}
	tiles1[60] = Entities.Tile{Type: 1}
	tiles1[80] = Entities.Tile{Type: 1}
	

	level := Entities.Level{ Name: "HardLevel", Width: 10, Height: 10, Tiles: tiles}
	cbr.AddLevel(level)
	level = Entities.Level{ Name: "UltraHardLevel", Width: 10, Height: 10, Tiles: tiles1}
	cbr.AddLevel(level)

	// Start the API
	api := API.APIBuilder("", ":8000", cbr)
	api.StartServer()
}

