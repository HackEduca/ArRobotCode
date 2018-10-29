package main

import (
	"fmt"
	"github.com/couchbase/gocb"
)

func main() {
	fmt.Println("Hello darkness my old friend")
	a, _ := gocb.Connect("http://127.0.0.1:8091")
	fmt.Println(a)
}
