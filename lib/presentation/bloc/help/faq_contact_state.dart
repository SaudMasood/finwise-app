
import '../../../domain/entities/help/faq_contac.dart';
import '../../../domain/entities/home/contact.dart';

class FaqState {
  final List<FaqItem> faqs;
  final List<ContactOption> contacts;
  final bool isLoading;
  final String? errorMessage;
  final bool isContact;
  final String selectedCategory;
  final String searchQuery;
  final String? openedQuestion;

  const FaqState({
    this.faqs = const [],
    this.contacts = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isContact = false,
    this.selectedCategory = 'General',
    this.searchQuery = '',
    this.openedQuestion,
  });

  List<FaqItem> get filteredFaqs {
    final query = searchQuery.trim().toLowerCase();

    return faqs.where((faq) {
      final matchesCategory =
          faq.category == selectedCategory;

      final matchesSearch =
          query.isEmpty ||
              faq.question.toLowerCase().contains(query) ||
              faq.answer.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<ContactOption> get filteredContacts {
    final query = searchQuery.trim().toLowerCase();

    return contacts.where((contact) {
      return query.isEmpty ||
          contact.title.toLowerCase().contains(query) ||
          contact.subtitle.toLowerCase().contains(query);
    }).toList();
  }

  FaqState copyWith({
    List<FaqItem>? faqs,
    List<ContactOption>? contacts,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? isContact,
    String? selectedCategory,
    String? searchQuery,
    String? openedQuestion,
    bool clearOpenedQuestion = false,
  }) {
    return FaqState(
      faqs: faqs ?? this.faqs,
      contacts: contacts ?? this.contacts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
      clearError ? null : errorMessage ?? this.errorMessage,
      isContact: isContact ?? this.isContact,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      openedQuestion: clearOpenedQuestion
          ? null
          : openedQuestion ?? this.openedQuestion,
    );
  }
}
