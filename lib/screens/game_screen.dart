import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../models/game_state.dart';
import '../constants/game_constants.dart';
import '../utils/animation_utils.dart';
import '../services/audio_manager.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  final AudioManager _audioManager = AudioManager();
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    await _audioManager.initialize();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    _audioManager.dispose();
    super.dispose();
  }

  void _playButtonSound() {
    if (!_isMuted) {
      _audioManager.playSound('button');
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _audioManager.toggleMute();
    });
    _playButtonSound();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(),
      child: Consumer<GameState>(
        builder: (context, gameState, _) {
          // Handle game over state
          if (gameState.gameOver && gameState.gameWon) {
            _confettiController.play();
            _audioManager.playSound('win');
          } else if (gameState.gameOver) {
            _audioManager.playSound('lose');
          }

          return Scaffold(
            appBar: _buildAppBar(context, gameState),
            body: Stack(
              children: [
                _buildGameContent(context, gameState),
                // Confetti effect for win
                if (gameState.gameWon)
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      shouldLoop: true,
                      colors: const [
                        Colors.green,
                        Colors.blue,
                        Colors.purple,
                        Colors.orange,
                        Colors.pink,
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, GameState gameState) {
    return AppBar(
      title: const Text('Hangman Game').animate().fadeIn(duration: 500.ms),
      centerTitle: true,
      actions: [
        // Sound toggle button
        IconButton(
          icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
          onPressed: _toggleMute,
          tooltip: _isMuted ? 'Unmute' : 'Mute',
        ),
        // New game button
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            _playButtonSound();
            _confettiController.stop();
            gameState.startNewGame();
          },
          tooltip: 'New Game',
        ),
      ],
    );
  }

  Widget _buildGameContent(BuildContext context, GameState gameState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Game stats
          _buildGameStats(gameState),
          
          const SizedBox(height: 24),
          
          // Hangman figure
          _buildHangmanFigure(gameState),
          
          const SizedBox(height: 32),
          
          // Word display
          _buildWordDisplay(gameState),
          
          const SizedBox(height: 32),
          
          // Game status message
          if (gameState.gameOver) _buildGameOverMessage(gameState),
          
          const SizedBox(height: 24),
          
          // Keyboard
          _buildKeyboard(gameState),
          
          const SizedBox(height: 16),
          
          // New game button (shown when game is over)
          if (gameState.gameOver) _buildNewGameButton(gameState),
        ],
      ),
    );
  }

  Widget _buildGameStats(GameState gameState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Score
        _buildStatCard(
          icon: Icons.star,
          label: 'Score',
          value: gameState.score.toString(),
        ),
        
        // High score
        _buildStatCard(
          icon: Icons.emoji_events,
          label: 'High Score',
          value: gameState.highScore.toString(),
        ),
        
        // Remaining attempts
        _buildStatCard(
          icon: Icons.favorite,
          label: 'Lives',
          value: '${gameState.remainingAttempts}/${GameConstants.maxAttempts}',
          color: gameState.remainingAttempts <= 2 ? Colors.red : null,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color ?? Theme.of(context).colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color ?? Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHangmanFigure(GameState gameState) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SizedBox(
          height: 200,
          width: 300,
          child: Stack(
            children: [
              // Gallows (always visible)
              Positioned(
                top: 20,
                left: 100,
                child: Container(width: 100, height: 10, color: Colors.brown),
              ),
              Positioned(
                top: 20,
                left: 100,
                child: Container(width: 10, height: 200, color: Colors.brown),
              ),
              Positioned(
                top: 220,
                left: 80,
                child: Container(width: 150, height: 10, color: Colors.brown),
              ),
              Positioned(
                top: 30,
                left: 190,
                child: Container(width: 10, height: 30, color: Colors.brown),
              ),
              
              // Hangman parts (appear based on remaining attempts)
              if (gameState.remainingAttempts < 6) // Head
                Positioned(
                  top: 60,
                  left: 175,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              
              if (gameState.remainingAttempts < 5) // Body
                Positioned(
                  top: 100,
                  left: 194,
                  child: Container(
                    width: 2,
                    height: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ).animate(effects: AnimationUtils.hangmanPartReveal()),
              
              if (gameState.remainingAttempts < 4) // Left arm
                Positioned(
                  top: 110,
                  left: 180,
                  child: Transform.rotate(
                    angle: -0.5,
                    child: Container(
                      width: 40,
                      height: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ).animate(effects: AnimationUtils.hangmanPartReveal()),
              
              if (gameState.remainingAttempts < 3) // Right arm
                Positioned(
                  top: 110,
                  left: 190,
                  child: Transform.rotate(
                    angle: 0.5,
                    child: Container(
                      width: 40,
                      height: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ).animate(effects: AnimationUtils.hangmanPartReveal()),
              
              if (gameState.remainingAttempts < 2) // Left leg
                Positioned(
                  top: 160,
                  left: 184,
                  child: Transform.rotate(
                    angle: 0.5,
                    child: Container(
                      width: 2,
                      height: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ).animate(effects: AnimationUtils.hangmanPartReveal()),
              
              if (gameState.remainingAttempts < 1) // Right leg
                Positioned(
                  top: 160,
                  left: 204,
                  child: Transform.rotate(
                    angle: -0.5,
                    child: Container(
                      width: 2,
                      height: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ).animate(effects: AnimationUtils.hangmanPartReveal()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWordDisplay(GameState gameState) {
    return Column(
      children: [
        // Category
        Text(
          'Category: ${gameState.selectedCategory.toUpperCase()}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        // Word display
        Text(
          gameState.getDisplayWord(),
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGameOverMessage(GameState gameState) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        color: gameState.gameWon
            ? Colors.green.withOpacity(0.2)
            : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: gameState.gameWon ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: Text(
        gameState.gameWon
            ? '🎉 Congratulations! You won! 🎉'
            : 'Game Over! The word was: ${gameState.wordToGuess}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: gameState.gameWon ? Colors.green : Colors.red,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildKeyboard(GameState gameState) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 8,
      children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((letter) {
        final isGuessed = gameState.isLetterGuessed(letter);
        final isInWord = gameState.isLetterInWord(letter);
        final isGameOver = gameState.gameOver;
        
        return _buildKeyButton(
          letter: letter,
          isGuessed: isGuessed,
          isInWord: isInWord,
          isGameOver: isGameOver,
          onPressed: () {
            _playButtonSound();
            if (!isGuessed && !isGameOver) {
              gameState.guessLetter(letter);
              if (isInWord) {
                _audioManager.playSound('correct');
              } else {
                _audioManager.playSound('wrong');
              }
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildKeyButton({
    required String letter,
    required bool isGuessed,
    required bool isInWord,
    required bool isGameOver,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    Color backgroundColor = colorScheme.surfaceVariant;
    Color textColor = colorScheme.onSurfaceVariant;
    
    if (isGuessed) {
      backgroundColor = isInWord ? Colors.green : Colors.red;
      textColor = Colors.white;
    }
    
    return GestureDetector(
      onTap: isGuessed ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            if (!isGuessed && !isGameOver)
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ).animate(
        onPlay: (controller) => controller.repeat(reverse: true),
      ).shimmer(
        duration: 2000.ms,
        delay: 1000.ms,
        size: 0.5,
        angle: 0.1,
      ),
    );
  }

  Widget _buildNewGameButton(GameState gameState) {
    return ElevatedButton.icon(
      onPressed: () {
        _playButtonSound();
        _confettiController.stop();
        gameState.startNewGame();
      },
      icon: const Icon(Icons.refresh),
      label: const Text('Play Again'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
