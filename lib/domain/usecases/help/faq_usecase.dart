
import '../../entities/help/faq_contac.dart';
import '../../entities/home/contact.dart';
import '../../repositories/help/help_repository.dart';

class GetHelpContentUseCase {
  final HelpRepository repository;

  GetHelpContentUseCase(this.repository);

  Future<List<FaqItem>> getFaqs() {
    return repository.getFaqs();
  }

  Future<List<ContactOption>> getContactOptions() {
    return repository.getContactOptions();
  }
}
