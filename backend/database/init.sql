CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- User table
CREATE TABLE User (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL
);

-- Goal table
CREATE TABLE Goal (
    user_id UUID PRIMARY KEY,
    weekly_sessions INT NOT NULL,
    current_progress INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Friend table (many-to-many self-referencing)
CREATE TABLE Friend (
    user_id UUID NOT NULL,
    friend_id UUID NOT NULL,
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (friend_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Workout table
CREATE TYPE workout_type AS ENUM ('cardio', 'strength', 'mobility', 'other');  -- example types

CREATE TABLE Workout (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    type workout_type NOT NULL,
    date DATE NOT NULL,
    duration INT NOT NULL,
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Exercise table
CREATE TABLE Exercise (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workout_id UUID NOT NULL,
    name VARCHAR(100) NOT NULL,
    sets INT NOT NULL,
    reps INT NOT NULL,
    weight FLOAT NOT NULL,
    FOREIGN KEY (workout_id) REFERENCES workouts(id) ON DELETE CASCADE
);
