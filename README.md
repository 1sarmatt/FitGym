# FitGym 🏋️‍♂️

FitGym is a simple web-based fitness tracking application built with Python, Flask, and SQLite. It allows users to log and manage their workout routines including exercises, sets, reps, and weight.

## Features

* 📝 Create and manage workouts
* 🏋️ Add exercises with sets, reps, and weights
* 📊 Track workout history
* ✅ Simple and clean UI with Bootstrap
* 🔐 Secure login system using Flask-Login

## Screenshots

![Home Page](screenshots/home.png)
![Workout Page](screenshots/workout.png)

## Tech Stack

* **Backend:** Python, Flask
* **Frontend:** HTML, CSS (Bootstrap)
* **Database:** SQLite
* **Authentication:** Flask-Login

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/1sarmatt/FitGym.git
cd FitGym
```

### 2. Create and activate virtual environment

```bash
python -m venv venv
source venv/bin/activate  # On Windows use `venv\Scripts\activate`
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Initialize the database

```bash
python
>>> from app import db
>>> db.create_all()
>>> exit()
```

### 5. Run the app

```bash
python app.py
```

Visit `http://127.0.0.1:5000` in your browser.

## Project Structure

```
FitGym/
├── static/         # CSS and images
├── templates/      # HTML templates
├── app.py          # Main Flask application
├── models.py       # Database models
├── forms.py        # Flask-WTF forms
├── requirements.txt
└── README.md
```

## Contributing

Contributions are welcome! Feel free to fork this repository, make changes, and open a pull request.

### To Do:

* Add user profile features
* Add progress tracking (charts/graphs)
* Improve UI responsiveness

## License

MIT License. See [LICENSE](LICENSE) for more information.

---
