package main

import (
	"net/http"
	handlers2 "saga-service/internal/handlers"
)

func main() {

	handlers := handlers2.GetHandlers()

	http.HandleFunc("/health", handlers.Health)

	port := ":8002"
	println("Server is running on port", port)
	if err := http.ListenAndServe(port, nil); err != nil {
		println("Error starting server:", err)
	}

}
