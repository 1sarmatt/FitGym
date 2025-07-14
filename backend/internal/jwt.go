package internal

import (
	"errors"
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

var jwtSecret = []byte(os.Getenv("JWT_SECRET_KEY"))

type Claims struct {
	Email     string `json:"email"`
	TokenType string `json:"token_type"` // "access" or "refresh"
	jwt.RegisteredClaims
}

type TokenPair struct {
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
}

// GenerateTokenPair creates both access and refresh tokens for a user
func GenerateTokenPair(email string) (*TokenPair, error) {
	accessToken, err := generateToken(email, "access", 15*time.Minute) // 15 minutes
	if err != nil {
		return nil, err
	}

	refreshToken, err := generateToken(email, "refresh", 5*time.Hour) // 5 hours
	if err != nil {
		return nil, err
	}

	return &TokenPair{
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
	}, nil
}

// generateToken creates a JWT token with specified type and expiration
func generateToken(email, tokenType string, expiration time.Duration) (string, error) {
	claims := &Claims{
		Email:     email,
		TokenType: tokenType,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(expiration)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(jwtSecret)
}

// GenerateJWT creates a new JWT token for a user (kept for backward compatibility)
func GenerateJWT(email string) (string, error) {
	return generateToken(email, "access", 15*time.Minute) // 15 minutes
}

// ValidateJWT parses and validates a JWT token string
func ValidateJWT(tokenStr string) (*Claims, error) {
	token, err := jwt.ParseWithClaims(tokenStr, &Claims{}, func(token *jwt.Token) (interface{}, error) {
		return jwtSecret, nil
	})
	if err != nil {
		return nil, err
	}
	claims, ok := token.Claims.(*Claims)
	if !ok || !token.Valid {
		return nil, errors.New("invalid token")
	}
	return claims, nil
}

// ValidateAccessToken validates that the token is a valid access token
func ValidateAccessToken(tokenStr string) (*Claims, error) {
	claims, err := ValidateJWT(tokenStr)
	if err != nil {
		return nil, err
	}
	if claims.TokenType != "access" {
		return nil, errors.New("invalid token type")
	}
	return claims, nil
}

// ValidateRefreshToken validates that the token is a valid refresh token
func ValidateRefreshToken(tokenStr string) (*Claims, error) {
	claims, err := ValidateJWT(tokenStr)
	if err != nil {
		return nil, err
	}
	if claims.TokenType != "refresh" {
		return nil, errors.New("invalid token type")
	}
	return claims, nil
}

// RefreshAccessToken generates a new access token using a valid refresh token
func RefreshAccessToken(refreshTokenStr string) (string, error) {
	claims, err := ValidateRefreshToken(refreshTokenStr)
	if err != nil {
		return "", err
	}

	// Generate new access token
	return generateToken(claims.Email, "access", 15*time.Minute) // 15 minutes
}
