
abstract class FaqEvent {}

class LoadHelpContent extends FaqEvent {}

class ChangeHelpTab extends FaqEvent {
  final bool isContact;

  ChangeHelpTab(this.isContact);
}

class ChangeHelpCategory extends FaqEvent {
  final String category;

  ChangeHelpCategory(this.category);
}

class SearchHelpContent extends FaqEvent {
  final String query;

  SearchHelpContent(this.query);
}

class ToggleFaq extends FaqEvent {
  final String question;

  ToggleFaq(this.question);
}
