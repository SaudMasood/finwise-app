
class SupportKeywordResponder {
  String getReply(String message) {
    final text = message.toLowerCase().trim();

    if (_containsAny(text, [
      'hello',
      'hi',
      'hey',
      'good morning',
      'good evening',
    ])) {
      return 'Hello! Welcome to FinWise Support. How can I help you today?';
    }

    if (_containsAny(text, [
      'expense',
      'expenses',
      'spending',
      'purchase',
    ])) {
      return 'You can review your expenses in the Expenses or Transactions section. To record an expense, open the relevant section and enter the amount, category, and date.';
    }

    if (_containsAny(text, [
      'budget',
      'saving',
      'savings',
    ])) {
      return 'You can plan your spending by setting a budget, reviewing your expenses, and comparing your spending against your budget regularly.';
    }

    if (_containsAny(text, [
      'password',
      'forgot password',
      'reset password',
    ])) {
      return 'To reset your password, open the login screen, select Forgot Password, and follow the instructions. If you cannot reset it, contact support.';
    }

    if (_containsAny(text, [
      'login',
      'log in',
      'sign in',
      'signin',
    ])) {
      return 'Please check your email and password. If you still cannot sign in, try resetting your password or check your internet connection.';
    }

    if (_containsAny(text, [
      'account',
      'profile',
      'personal information',
    ])) {
      return 'Open your Profile or Settings section to review your account information and available account options.';
    }

    if (_containsAny(text, [
      'transaction',
      'transactions',
      'history',
      'record',
    ])) {
      return 'Open the Transactions or History section to review your financial records. Check the transaction date and amount to find a specific entry.';
    }

    if (_containsAny(text, [
      'notification',
      'notifications',
      'alert',
    ])) {
      return 'Check the Notifications section for recent updates. You can also review your app settings for available notification preferences.';
    }

    if (_containsAny(text, [
      'security',
      'privacy',
      'safe',
    ])) {
      return 'Keep your password private and use a secure device. Review the FinWise privacy policy for information about how your data is handled.';
    }

    if (_containsAny(text, [
      'contact',
      'human',
      'agent',
      'support person',
    ])) {
      return 'I am the FinWise automated support assistant. This chat currently provides keyword-based replies and does not connect to a live support agent.';
    }

    if (_containsAny(text, [
      'thank',
      'thanks',
      'thank you',
    ])) {
      return 'You are welcome! I am happy to help. Is there anything else you would like to know?';
    }

    if (_containsAny(text, [
      'help',
      'problem',
      'issue',
      'error',
    ])) {
      return 'I can help with expenses, budgets, passwords, login issues, transactions, and account settings. Please describe your issue in a few words.';
    }

    if (_containsAny(text, [
      'bye',
      'goodbye',
      'see you',
    ])) {
      return 'Thank you for contacting FinWise Support. Have a great day!';
    }

    return 'Sorry, I did not fully understand your question. Try asking about expenses, budgets, transactions, passwords, login, or account settings.';
  }

  bool _containsAny(String text, List<String> keywords) {
    return keywords.any(text.contains);
  }
}
