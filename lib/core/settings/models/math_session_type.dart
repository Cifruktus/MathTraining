

  const easyQuestionGeneratorName = "Easy";
  const normalQuestionGeneratorName = "Normal";
  const hardQuestionGeneratorName = "Hard";
  const hexReadQuestionGeneratorName = "Hex decode";

  const String sessionDefaultDifficulty = easyQuestionGeneratorName;

  const sessionDifficultyNames = [
    easyQuestionGeneratorName,
    normalQuestionGeneratorName,
    hardQuestionGeneratorName,
    hexReadQuestionGeneratorName,
  ];

 // QuestionGenerator getQuestionGenerator(String type) {
 //   switch (type) {
 //     case easyQuestionGeneratorName:
 //       return EasyQuestionGenerator();
 //     case normalQuestionGeneratorName:
 //       return NormalQuestionGenerator();
 //     case hardQuestionGeneratorName:
 //       return HardQuestionGenerator();
 //     case hexReadQuestionGeneratorName:
 //       return HexQuestionGenerator();
 //   }
 //   return NormalQuestionGenerator();
 // }

  const defaultDuration = Duration(minutes: 1);

  const List<Duration> durationOptions = [
    Duration(minutes: 1),
    Duration(minutes: 2),
    Duration(minutes: 3),
    Duration(minutes: 5),
    Duration(minutes: 7),
  ];
