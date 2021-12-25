abstract class MathGameEvent {
  const MathGameEvent();
}

class MathGamePaused extends MathGameEvent {
  const MathGamePaused();
}

class MathGameResumed extends MathGameEvent {
  const MathGameResumed();
}

class MathGameNewInputData extends MathGameEvent {
  final String input;

  const MathGameNewInputData(this.input);
}

class MathGameStart extends MathGameEvent {
  const MathGameStart();
}

class MathGameOnOkInput extends MathGameEvent {
  final String input;

  const MathGameOnOkInput(this.input);
}

class MathGameTimerTicked extends MathGameEvent {
  const MathGameTimerTicked({required this.duration});
  final int duration;
}