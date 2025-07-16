# FitGym 🏋️‍♂️

FitGym is a simple web-based fitness tracking application built with Python, Flask, and SQLite. It allows users to log and manage their workout routines including exercises, sets, reps, and weight.

## Features

* 📝 Create and manage workouts
* 🏋️ Add exercises with sets, reps, and weights
* 📊 Track workout history
* ✅ Simple and clean UI with Bootstrap
* 🔐 Secure login system using Flask-Login

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

## Screenshots of the main features

![login page](ReadmeData/login%20page.png)
![login image](ReadmeData/login%20image.png)
![Register page](ReadmeData/register%20page.png)
![Profile filling](ReadmeData/Proflie%20filling.png)
![Light theme](ReadmeData/Light%20theme.png)
![Rus](ReadmeData/russian.png)
![workout log](ReadmeData/workout%20log.png)
![friends](ReadmeData/Frinds%20page.png)


## Team Roles

- Zavadskii Peter Team Lead / Backend
- Zaynulin Salavat Backend
- Lutfullin Sarmat Frontend
- Fominykh Aleksei DevOps

## Link to backlog

https://github.com/orgs/Fitgym-org/projects/1


## License

MIT License. See [LICENSE](LICENSE) for more information.

---
