package main

import (
	"net/http"

	"saga-service/internal/buildinfo"
	handlers2 "saga-service/internal/handlers"
)

func main() {

	handlers := handlers2.GetHandlers()

	http.HandleFunc("/health", handlers.Health)
	http.HandleFunc("/clients", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodGet {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
			return
		}
		w.WriteHeader(http.StatusOK)
		w.Write([]byte(buildinfo.OpenAPIClients))
	})

	port := ":8002"
	println("Server is running on port", port)
	if err := http.ListenAndServe(port, nil); err != nil {
		println("Error starting server:", err)
	}

}
