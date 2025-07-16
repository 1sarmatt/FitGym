package handlers

import (
	"net/http"
)

// GetWeeklySummaryHandler godoc
// @Summary Get weekly summary
// @Description Gets weekly workout summary for the user
// @Tags analytics
// @Produce  json
// @Success 200 {object} map[string]interface{}
// @Failure 401 {string} string "Unauthorized"
// @Router /getWeeklySummary [get]
// @Security BearerAuth
func GetWeeklySummaryHandler(w http.ResponseWriter, r *http.Request) {
	// TODO: implement get weekly summary logic
}

// GetProgressChartsHandler godoc
// @Summary Get progress charts
// @Description Gets progress charts data for the user
// @Tags analytics
// @Produce  json
// @Success 200 {object} map[string]interface{}
// @Failure 401 {string} string "Unauthorized"
// @Router /getProgressCharts [get]
// @Security BearerAuth
func GetProgressChartsHandler(w http.ResponseWriter, r *http.Request) {
	// TODO: implement get progress charts logic
}
