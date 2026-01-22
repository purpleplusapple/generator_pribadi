/// Simple prompt filter for content safety
class SafePromptFilter {
  final String mode;

  SafePromptFilter({this.mode = 'strict'});

  /// List of blocked terms for home exterior context
  static const List<String> _blockedTerms = [
    'nude',
    'naked',
    'explicit',
    'adult',
    'nsfw',
    'violence',
    'blood',
    'gore',
    'weapon',
    'drug',
    'illegal',
  ];

  /// Checks if prompt is safe and returns sanitized version
  PromptCheckResult check(String prompt) {
    final lowerPrompt = prompt.toLowerCase();

    for (final term in _blockedTerms) {
      if (lowerPrompt.contains(term)) {
        return PromptCheckResult(
          allowed: false,
          reason: 'Contains inappropriate content',
          sanitized: prompt,
        );
      }
    }

    // Basic sanitization - remove excessive whitespace
    final sanitized = prompt.trim().replaceAll(RegExp(r'\s+'), ' ');

    return PromptCheckResult(
      allowed: true,
      reason: null,
      sanitized: sanitized,
    );
  }
}

class PromptCheckResult {
  final bool allowed;
  final String? reason;
  final String sanitized;

  PromptCheckResult({
    required this.allowed,
    this.reason,
    required this.sanitized,
  });
}
