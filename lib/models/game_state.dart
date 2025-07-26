import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/game_constants.dart';

class GameState extends ChangeNotifier {
  String _wordToGuess = '';
  List<String> _guessedLetters = [];
  int _remainingAttempts = GameConstants.maxAttempts;
  bool _gameOver = false;
  bool _gameWon = false;
  int _score = 0;
  int _highScore = 0;
  String _selectedCategory = 'technology';
  String _selectedDifficulty = 'medium';
  List<String> _availableCategories = [];
  
  // Getters
  String get wordToGuess => _wordToGuess;
  List<String> get guessedLetters => List.unmodifiable(_guessedLetters);
  int get remainingAttempts => _remainingAttempts;
  bool get gameOver => _gameOver;
  bool get gameWon => _gameWon;
  int get score => _score;
  int get highScore => _highScore;
  String get selectedCategory => _selectedCategory;
  String get selectedDifficulty => _selectedDifficulty;
  List<String> get availableCategories => List.unmodifiable(_availableCategories);
  
  // Initialize the game with available categories
  GameState() {
    _availableCategories = GameConstants.wordCategories.keys.toList();
    _loadHighScore();
  }
  
  // Load high score from shared preferences
  Future<void> _loadHighScore() async {
    // Implementation for loading high score will be added later
    _highScore = 0; // Default value
    notifyListeners();
  }
  
  // Save high score to shared preferences
  Future<void> _saveHighScore() async {
    if (_score > _highScore) {
      _highScore = _score;
      // Implementation for saving high score will be added later
      notifyListeners();
    }
  }
  
  // Start a new game
  void startNewGame() {
    final random = Random();
    final categoryWords = GameConstants.wordCategories[_selectedCategory] ?? [];
    final difficulty = GameConstants.difficultyLevels[_selectedDifficulty] ?? 
                      GameConstants.difficultyLevels['medium']!;
    
    // Filter words by difficulty
    final filteredWords = categoryWords.where((word) {
      final length = word.length;
      return length >= difficulty['minLength'] && 
             length <= difficulty['maxLength'];
    }).toList();
    
    if (filteredWords.isEmpty) {
      _wordToGuess = categoryWords[random.nextInt(categoryWords.length)];
    } else {
      _wordToGuess = filteredWords[random.nextInt(filteredWords.length)];
    }
    
    _guessedLetters = [];
    _remainingAttempts = GameConstants.maxAttempts;
    _gameOver = false;
    _gameWon = false;
    _score = 0;
    
    notifyListeners();
  }
  
  // Guess a letter
  void guessLetter(String letter) {
    if (_gameOver || _guessedLetters.contains(letter)) return;
    
    _guessedLetters.add(letter);
    
    if (!_wordToGuess.contains(letter)) {
      _remainingAttempts--;
    } else {
      // Calculate points for correct guess
      final letterCount = _wordToGuess.split(letter).length - 1;
      _score += letterCount * GameConstants.basePointsPerLetter;
    }
    
    // Check win/lose conditions
    _gameWon = _wordToGuess.split('').every((char) => _guessedLetters.contains(char));
    _gameOver = _remainingAttempts <= 0 || _gameWon;
    
    if (_gameOver && _gameWon) {
      // Add bonus points for remaining attempts
      _score += _remainingAttempts * GameConstants.pointsPerRemainingAttempt;
      
      // Add perfect game bonus
      if (_remainingAttempts == GameConstants.maxAttempts) {
        _score += GameConstants.bonusPointsForPerfectGame;
      }
      
      _saveHighScore();
    }
    
    notifyListeners();
  }
  
  // Get the current display word with underscores for unguessed letters
  String getDisplayWord() {
    return _wordToGuess
        .split('')
        .map((letter) => _guessedLetters.contains(letter) ? letter : '_')
        .join(' ');
  }
  
  // Check if a letter has been guessed
  bool isLetterGuessed(String letter) {
    return _guessedLetters.contains(letter);
  }
  
  // Check if a letter is in the word
  bool isLetterInWord(String letter) {
    return _wordToGuess.contains(letter);
  }
  
  // Set the selected category
  void setCategory(String category) {
    if (_availableCategories.contains(category)) {
      _selectedCategory = category;
      notifyListeners();
    }
  }
  
  // Set the selected difficulty
  void setDifficulty(String difficulty) {
    if (GameConstants.difficultyLevels.containsKey(difficulty)) {
      _selectedDifficulty = difficulty;
      notifyListeners();
    }
  }
  
  // Get the current difficulty settings
  Map<String, dynamic> getDifficultySettings() {
    return Map<String, dynamic>.from(
      GameConstants.difficultyLevels[_selectedDifficulty] ?? 
      GameConstants.difficultyLevels['medium']!
    );
  }
  
  @override
  void dispose() {
    super.dispose();
  }
}
