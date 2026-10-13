

import '../../entities/help/faq_contac.dart';
import '../../entities/home/contact.dart';

abstract class HelpRepository {
  Future<List<FaqItem>> getFaqs();

  Future<List<ContactOption>> getContactOptions();
}
