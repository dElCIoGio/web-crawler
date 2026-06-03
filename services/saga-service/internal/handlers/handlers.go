package handlers

import (
	"net/http"
)

type Handlers struct{}

func GetHandlers() *Handlers {
	return &Handlers{}
}

func (h *Handlers) Health(w http.ResponseWriter, r *http.Request) {

	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowes", http.StatusMethodNotAllowed)
		return
	}

	w.WriteHeader(http.StatusOK)
	w.Write([]byte("healthy"))
}
