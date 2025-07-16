// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'FitGym';

  @override
  String get welcome => 'Добро пожаловать в FitGym!';

  @override
  String get login => 'Войти';

  @override
  String get register => 'Регистрация';

  @override
  String get profile => 'Аккаунт';

  @override
  String get workoutLog => 'Журнал тренировок';
  String get add => 'Добавить';
  String get activeWorkouts => 'Активные тренировки';
  String get workoutHistory => 'История тренировок';
  String get noWorkoutsYet => 'Пока нет тренировок.';
  String get complete => 'Завершить';
  String get delete => 'Удалить';
  String get exercises => 'Упражнения';
  String get sets => 'Подходы';
  String get reps => 'Повторения';
  String get weightKg => 'Вес (кг)';
  String get name => 'Имя';
  String get age => 'Возраст';
  String get workoutType => 'Тип тренировки';
  String get dateFormat => 'Дата (ДД.ММ.ГГГГ)';
  String get notes => 'Заметки';
  String get addExercise => 'Добавить упражнение';
  String get editExercise => 'Редактировать упражнение';
  String get addWorkout => 'Добавить тренировку';
  String get editWorkout => 'Редактировать тренировку';
  String get cancel => 'Отмена';
  String get save => 'Сохранить';
  String get workoutCompleted => 'Тренировка завершена!';
  String get failedCompleteWorkout => 'Не удалось завершить тренировку';
  String get workoutDeleted => 'Тренировка удалена!';
  String get failedDeleteWorkout => 'Не удалось удалить тренировку';
  String get workoutIdNotFound => 'ID тренировки не найден.';
  String get userIdNotFound => 'ID пользователя не найден. Пожалуйста, войдите снова.';
  String get failedAddWorkout => 'Не удалось добавить тренировку';
  String get error => 'Ошибка';
  String get failedUpdateWorkout => 'Не удалось обновить тренировку';
  String get formatDateError => 'Формат: ДД.ММ.ГГГГ';
  String get enterDate => 'Введите дату';
  String get enterType => 'Введите тип';
  String get noExercises => 'Нет упражнений';
  String get deleteWorkout => 'Удалить тренировку';
  String get confirmDeleteWorkout => 'Вы уверены, что хотите удалить эту тренировку?';
  String get date => 'Дата (ДД.ММ.ГГГГ)';
  String get weight => 'Вес (кг)';
  String get userNotFound => 'ID пользователя не найден. Пожалуйста, войдите снова.';
  String get failedToAddWorkout => 'Не удалось добавить тренировку';
  String get failedToUpdateWorkout => 'Не удалось обновить тренировку';
  String get workoutMarkedAsCompleted => 'Тренировка завершена!';
  String get failedToCompleteWorkout => 'Не удалось завершить тренировку';
  String get failedToDeleteWorkout => 'Не удалось удалить тренировку';
  String get logout => 'Выйти';
  String get close => 'Закрыть';
  String get passwordMinLength => 'Пароль должен быть не менее 6 символов';
  String get noAccountRegister => 'Нет аккаунта? Зарегистрируйтесь';
  String get createAccount => 'Создать аккаунт';
  String get email => 'Email';
  String get enterEmail => 'Пожалуйста, введите email';
  String get enterValidEmail => 'Введите корректный email';
  String get password => 'Пароль';
  String get enterPassword => 'Пожалуйста, введите пароль';
  String get confirmPassword => 'Подтвердите пароль';
  String get confirmPasswordPrompt => 'Пожалуйста, подтвердите пароль';
  String get passwordsDoNotMatch => 'Пароли не совпадают';
  String get alreadyHaveAccountLogin => 'Уже есть аккаунт? Войти';
  String get loginWelcome => 'С возвращением!';

  @override
  String get progress => 'Прогресс';

  @override
  String get schedule => 'Расписание';

  @override
  String get social => 'Друзья';

  @override
  String get themeSwitch => 'Сменить тему';

  @override
  String get language => 'Язык';

  String get socialTitle => 'Друзья';
  String get addFriend => 'Добавить друга';
  String get enterFriendEmail => 'Введите email друга';
  String get failedToLoadFriends => 'Не удалось загрузить друзей.';
  String get failedToAddFriend => 'Не удалось добавить друга.';
  String get friendAdded => 'Друг добавлен!';
  String get friends => 'Друзья';
  String get noFriendsYet => 'Пока нет друзей. Добавьте кого-нибудь!';
  String get noCompletedWorkoutsYet => 'Пока нет завершённых тренировок.';
  String get totalWorkouts => 'Всего тренировок';
  String get mostFrequent => 'Чаще всего';
  String get recentWorkouts => 'Недавние тренировки';
  String get exercisesLabel => 'Упражнения:';
  String get failedToLoadFriendStats => 'Не удалось загрузить статистику друга.';
}
