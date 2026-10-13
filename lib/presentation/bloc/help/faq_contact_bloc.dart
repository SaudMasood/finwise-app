
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/help/faq_contac.dart';
import '../../../domain/entities/home/contact.dart';
import '../../../domain/usecases/help/faq_usecase.dart';

import 'faq_contact_event.dart.dart';
import 'faq_contact_state.dart';

class FaqBloc extends Bloc<FaqEvent, FaqState> {
  final GetHelpContentUseCase getHelpContentUseCase;

  FaqBloc(this.getHelpContentUseCase)
      : super(const FaqState()) {
    on<LoadHelpContent>(_loadHelpContent);
    on<ChangeHelpTab>(_changeTab);
    on<ChangeHelpCategory>(_changeCategory);
    on<SearchHelpContent>(_searchContent);
    on<ToggleFaq>(_toggleFaq);
  }

  Future<void> _loadHelpContent(
      LoadHelpContent event,
      Emitter<FaqState> emit,
      ) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearError: true,
      ),
    );

    try {
      final List<FaqItem> faqs =
      await getHelpContentUseCase.getFaqs();

      final List<ContactOption> contacts =
      await getHelpContentUseCase.getContactOptions();

      emit(
        state.copyWith(
          faqs: faqs,
          contacts: contacts,
          isLoading: false,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage:
          'Unable to load help content. Please try again.',
        ),
      );
    }
  }

  void _changeTab(
      ChangeHelpTab event,
      Emitter<FaqState> emit,
      ) {
    emit(
      state.copyWith(
        isContact: event.isContact,
        clearOpenedQuestion: true,
      ),
    );
  }

  void _changeCategory(
      ChangeHelpCategory event,
      Emitter<FaqState> emit,
      ) {
    emit(
      state.copyWith(
        selectedCategory: event.category,
        clearOpenedQuestion: true,
      ),
    );
  }

  void _searchContent(
      SearchHelpContent event,
      Emitter<FaqState> emit,
      ) {
    emit(
      state.copyWith(
        searchQuery: event.query,
        clearOpenedQuestion: true,
      ),
    );
  }

  void _toggleFaq(
      ToggleFaq event,
      Emitter<FaqState> emit,
      ) {
    final bool isAlreadyOpen =
        state.openedQuestion == event.question;

    emit(
      state.copyWith(
        openedQuestion:
        isAlreadyOpen ? null : event.question,
        clearOpenedQuestion: isAlreadyOpen,
      ),
    );
  }
}
