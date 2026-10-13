
import '../../domain/entities/help/faq_contac.dart';
import '../../domain/entities/home/contact.dart';

class HelpRemoteDataSource {
  Future<List<FaqItem>> getFaqs() async {
    return const [
      FaqItem(
        question: 'How to use FinWise?',
        answer:
        'Open the FinWise dashboard to view your financial summary and explore the available features.',
        category: 'General',
      ),
      FaqItem(
        question: 'How much does it cost to use FinWise?',
        answer:
        'Check the app’s current pricing information for available plans and any applicable charges.',
        category: 'General',
      ),
      FaqItem(
        question: 'How to contact support?',
        answer:
        'Open Help & FAQs, select Contact Us, and choose Customer Service.',
        category: 'General',
      ),
      FaqItem(
        question: 'How can I reset my password if I forget it?',
        answer:
        'Open the login screen, select Forgot Password, and follow the instructions to reset your password.',
        category: 'Account',
      ),
      FaqItem(
        question:
        'Are there any privacy or data security measures in place?',
        answer:
        'Review the FinWise privacy policy for details about how your account information is handled and protected.',
        category: 'Account',
      ),
      FaqItem(
        question: 'Can I customize settings within the application?',
        answer:
        'Open Settings to review the customization options available in FinWise.',
        category: 'Account',
      ),
      FaqItem(
        question: 'How do I delete my account?',
        answer:
        'Contact customer support to request account deletion and follow the required verification process.',
        category: 'Account',
      ),
      FaqItem(
        question: 'How do I access my expense history?',
        answer:
        'Open the expense or transaction history section to review your saved financial records.',
        category: 'Services',
      ),
      FaqItem(
        question: 'Can I use the app offline?',
        answer:
        'Some FinWise features may require an internet connection to retrieve or synchronize data.',
        category: 'Services',
      ),
    ];
  }

  Future<List<ContactOption>> getContactOptions() async {
    return const [
      ContactOption(
        title: 'Customer Service',
        subtitle: 'Chat with our support assistant',
        type: 'customer_service',
      ),
      ContactOption(
        title: 'Website',
        subtitle: 'Visit the official FinWise website',
        type: 'website',
      ),
      ContactOption(
        title: 'Facebook',
        subtitle: 'Follow us on Facebook',
        type: 'facebook',
      ),
      ContactOption(
        title: 'Whatsapp',
        subtitle: 'Contact us on WhatsApp',
        type: 'whatsapp',
      ),
      ContactOption(
        title: 'Instagram',
        subtitle: 'Follow us on Instagram',
        type: 'instagram',
      ),
    ];
  }
}
