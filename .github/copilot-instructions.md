# FinWise Flutter Project Rules

## Project

This is the FinWise Finance Management mobile application.

Use:
- Flutter
- Dart
- Clean Architecture
- BLoC
- Firebase where backend functionality is required
- Figma MCP for Figma-to-Flutter UI implementation

## Main Architecture

Follow this architecture:

UI
→ BLoC
→ UseCase
→ Repository
→ DataSource
→ Firebase/API

Never put Firebase, API, or business logic directly inside UI pages.

## Folder Structure

lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── routes/
│   ├── utils/
│   └── widgets/
├── data/
│   ├── datasources/
│   │   ├── remote/
│   │   └── local/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/

## Figma UI Rules

When a Figma link is provided:

1. Inspect the selected Figma screen using Figma MCP.
2. Use the Figma design as the primary source for UI.
3. Match:
   - screen layout
   - spacing
   - padding
   - margins
   - colors
   - font family
   - font size
   - font weight
   - line height
   - border radius
   - shadows
   - icons
   - images
   - button sizes
   - text alignment
   - component positions
4. Do not redesign the screen.
5. Do not invent UI elements that are not in Figma.
6. Do not remove elements that exist in Figma.
7. Keep the same visual hierarchy.
8. Use responsive Flutter code so the design works on different screen sizes.
9. Use MediaQuery when appropriate.
10. Prefer simple Flutter code that is easy for a beginner to understand.

## Assets

When Figma contains images, icons, illustrations, logos, or other assets:

- Use the actual Figma asset whenever it is available.
- Save project assets inside:
  assets/images/
  assets/icons/
  assets/fonts/
- Use SVG assets as SVG when Figma provides SVG.
- Use PNG/JPG when appropriate.
- Do not replace a Figma icon with a random Material icon if the actual Figma asset is available.
- Do not create fake placeholder images when the real Figma asset is available.
- Update pubspec.yaml when adding assets.

Example:

assets:
  - assets/images/
  - assets/icons/
  - assets/fonts/

Use assets with:

Image.asset('assets/images/example.png')

or:

SvgPicture.asset('assets/icons/example.svg')

## Reusable Widgets

Use core/widgets/ for application-wide reusable widgets.

Examples:

- AppButton
- AppTextField
- AppAppBar
- AppCard
- AppLoader

Use presentation/widgets/<feature>/ only for widgets specific to one feature.

Do not create unnecessary custom widgets.

## Beginner Coding Style

Write simple and readable Dart code.

Avoid unnecessary:
- advanced patterns
- complicated generics
- unnecessary abstractions
- unnecessary helper methods
- unnecessary packages

Keep code easy for a beginner to understand.

When the user specifically asks for direct code inside build(), do not create custom widget methods.

## BLoC

Use BLoC for business logic and state management.

UI should:
- display state
- send events
- react to states

BLoC should:
- receive events
- call use cases
- emit states

Do not put business logic directly inside widgets.

## Firebase

Firebase code belongs in:

data/datasources/remote/

Repository implementation belongs in:

data/repositories/

Use cases belong in:

domain/usecases/

Never call Firebase directly from a Page.

## Navigation

Keep navigation organized through the project route structure when the application becomes large.

Do not put unnecessary navigation logic inside business/data layers.

## UI Implementation Process

Always work one screen at a time.

For every Figma screen:

1. Inspect Figma.
2. Identify all visible UI elements.
3. Identify required assets.
4. Add assets to the correct assets folder.
5. Implement the screen.
6. Run the application.
7. Compare the Flutter screen with Figma.
8. Fix spacing, sizing, typography, colors and alignment.
9. Only after the current screen is visually close, move to the next screen.

Do not implement multiple screens at once unless explicitly requested.

## Important

Do not change existing project architecture without asking.

Do not rename existing files unnecessarily.

Do not add packages unless required.

Do not modify unrelated screens.

When implementing a Figma screen, first explain which files will be created or changed, then implement them.

The goal is high visual fidelity to the provided Figma design while keeping the Flutter code simple, responsive and maintainable.


For every Figma asset used by this screen:

1. Identify whether it is an image, SVG, icon, logo or illustration.
2. Use the actual Figma asset when available.
3. Store images in:
   assets/images/

4. Store icons and SVG files in:
   assets/icons/

5. Add the required asset folders to pubspec.yaml.

6. Use the asset path in Flutter.

Do not replace the Figma asset with a random Material icon.