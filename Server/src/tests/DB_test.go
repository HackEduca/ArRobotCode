package main

import (
	"Entities"
	"Repository"
	"testing"
)

var DB_NAME="testLevels"

func TestAddDeleteLevel(t *testing.T) {
	var cbr Repository.IRepository
	cbr = Repository.CouchBaseRepositoryBuilder(DB_NAME)
	tiles := []Entities.Tile{ Entities.Tile{Type:0}, Entities.Tile{Type:0}, Entities.Tile{Type:1}, Entities.Tile{Type:2}}
	Level := Entities.Level{ Name: "Introductory", Width: 5, Height: 5, Tiles: tiles}

	var err error
	err = cbr.AddLevel(Level)
	if err != nil {
		t.Error("Error at adding a Level")
	}

	err = cbr.AddLevel(Level)
	if err == nil {
		t.Error("Error at adding a Level. Duplicate key not found")
	}

	err = cbr.DeleteLevel(Level.Name)
	if err != nil {
		t.Error("Error at deleting a Level")
	}

	err = cbr.DeleteLevel(Level.Name)
	if err == nil {
		t.Error("Error at deleting a Level. Duplicate key not found")
	}
}


func TestUpdateLevel(t *testing.T) {
	var cbr Repository.IRepository
	cbr = Repository.CouchBaseRepositoryBuilder(DB_NAME)

	tiles := []Entities.Tile{ Entities.Tile{Type:0}, Entities.Tile{Type:0}, Entities.Tile{Type:1}, Entities.Tile{Type:2}}
	Level := Entities.Level{ Name: "Introductory", Width: 5, Height: 5, Tiles: tiles}
	newLevel := Entities.Level{ Name: "Introductory2", Width: 6, Height: 6, Tiles: tiles}
	newLevel2 := Entities.Level{ Name: "Introductory2", Width: 7, Height: 7, Tiles: tiles}
	cbr.AddLevel(Level)

	// Update also the name
	var err error
	err = cbr.UpdateLevel(Level.Name, newLevel)
	if err != nil {
		t.Error("Error at updating the Level (1)")
	}

	var updatedLevel Entities.Level
	updatedLevel, err = cbr.GetLevelByName(newLevel.Name)
	if err != nil || updatedLevel.Name != newLevel.Name || updatedLevel.Width!= newLevel.Width {
		t.Error("Error at updating the Level (2)")
	}

	// Do not update
	err = cbr.UpdateLevel(newLevel.Name, newLevel2)
	if err != nil {
		t.Error("Error at updating the Level (3)")
	}
	updatedLevel, err = cbr.GetLevelByName(newLevel.Name)
	if err != nil || updatedLevel.Name != newLevel2.Name || updatedLevel.Width != newLevel2.Width {
		t.Error("Error at updating the Level (2)")
	}

	// Delete residual document
	cbr.DeleteLevel(newLevel2.Name)
}

