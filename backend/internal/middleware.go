package internal

import (
	"net/http"
	"strings"
)

// JWTAuthMiddleware is a middleware for protecting routes
func JWTAuthMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		authHeader := r.Header.Get("Authorization")
		if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
			http.Error(w, "Missing or invalid Authorization header", http.StatusUnauthorized)
			return
		}
		tokenStr := strings.TrimPrefix(authHeader, "Bearer ")
		_, err := ValidateAccessToken(tokenStr)
		if err != nil {
			http.Error(w, "Invalid or expired access token", http.StatusUnauthorized)
			return
		}
		// Optionally, set claims in context for use in handlers
		next.ServeHTTP(w, r.WithContext(r.Context()))
	})
}
