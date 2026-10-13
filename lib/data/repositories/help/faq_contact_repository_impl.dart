
import '../../../domain/entities/help/faq_contac.dart';
import '../../../domain/entities/home/contact.dart';
import '../../../domain/repositories/help/help_repository.dart';
import '../../datasources/faq_contact_hlp.dart';

class HelpRepositoryImpl implements HelpRepository {
  final HelpRemoteDataSource dataSource;

  HelpRepositoryImpl(this.dataSource);

  @override
  Future<List<FaqItem>> getFaqs() {
    return dataSource.getFaqs();
  }

  @override
  Future<List<ContactOption>> getContactOptions() {
    return dataSource.getContactOptions();
  }
}
