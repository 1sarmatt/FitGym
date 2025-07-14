-- User table
CREATE TABLE "User" (
    id INT PRIMARY KEY,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL
);

-- Goal table
CREATE TABLE Goal (
    user_id INT PRIMARY KEY,
    weekly_sessions INT NOT NULL,
    current_progress INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES "User"(id) ON DELETE CASCADE
);

-- Friend table (many-to-many self-referencing)
CREATE TABLE Friend (
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES "User"(id) ON DELETE CASCADE,
    FOREIGN KEY (friend_id) REFERENCES "User"(id) ON DELETE CASCADE
);

CREATE TABLE Workout (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    type VARCHAR(100) NOT NULL,
    date DATE NOT NULL,
    duration INT NOT NULL,
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES "User"(id) ON DELETE CASCADE
);

-- Exercise table
CREATE TABLE Exercise (
    id INT PRIMARY KEY,
    workout_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    sets INT NOT NULL,
    reps INT NOT NULL,
    weight FLOAT NOT NULL,
    FOREIGN KEY (workout_id) REFERENCES Workout(id) ON DELETE CASCADE
);
