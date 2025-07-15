package handlers

import (
	"encoding/json"
	"fitgym/backend/serivces"
	"net/http"
	"strings"

	"github.com/google/uuid"
)

var AnalyticsSrv *serivces.AnalyticsService

func GetWeeklySummaryHandler(w http.ResponseWriter, r *http.Request) {
	userIDStr := r.URL.Query().Get("user_id")
	if userIDStr == "" {
		http.Error(w, "user_id is required", http.StatusBadRequest)
		return
	}
	userID, err := uuid.Parse(strings.TrimSpace(userIDStr))
	if err != nil {
		http.Error(w, "invalid user_id", http.StatusBadRequest)
		return
	}
	summary := AnalyticsSrv.GetWeeklySummary(userID)
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(summary)
}

func GetProgressChartsHandler(w http.ResponseWriter, r *http.Request) {
	userIDStr := r.URL.Query().Get("user_id")
	if userIDStr == "" {
		http.Error(w, "user_id is required", http.StatusBadRequest)
		return
	}
	userID, err := uuid.Parse(strings.TrimSpace(userIDStr))
	if err != nil {
		http.Error(w, "invalid user_id", http.StatusBadRequest)
		return
	}
	progress := AnalyticsSrv.GetProgressCharts(userID)
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(progress)
}
