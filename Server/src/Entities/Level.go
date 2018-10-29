package Entities

type Level struct {
	Name 		string 	`json:"Name"`
	Width  		int 	`json:"Width"`
	Height		int		`json:"Height"`
	Tiles		[]Tile  `json:"Tiles"`
}
