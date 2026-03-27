// lib/core/utils/validators.dart

import '../constants/app_constants.dart';

abstract class Validators {
  static String? validateQuestion(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Question cannot be empty';
    }
    if (value.length > AppConstants.questionMaxLength) {
      return 'Question must be less than ${AppConstants.questionMaxLength} characters';
    }
    return null;
  }

  static String? validateAnswer(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Answer cannot be empty';
    }
    if (value.length > AppConstants.answerMaxLength) {
      return 'Answer must be less than ${AppConstants.answerMaxLength} characters';
    }
    return null;
  }
}
