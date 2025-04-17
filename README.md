
# How to add strings with translation:


## Short edition:

Two steps:

1. In code: instead of `'string text'`, use `'some_chosen_name'.tr()`
2. Add `"some_chosen_name": "string text",` to translation json files in `assets/translations`.




## Long edition:

Let's say you have a button and you want it to say `'Click me'`

Somewhere in your button code, you normally have something like this:

```dart
Text('Click Me')
```

First, decide a **descriptive and distinct** key (name) for this string.

`click_me_button` seems like a good fit for this example.

Now go to `assets/translations`, in there you will find two files called `en.json` and `sv.json`.

One is for english and the other is for swedish.

Add the key (name) of the string and the value to both files in the correct language.

```json
  "click_me_button": "Click Me",
```

```json
  "click_me_button": "Klicka på mig",
```

Now, go back to your button code and change `Text('Click Me')` to instead say:

```dart
Text('click_me_button'.tr())
```

You are done!




# Prepster




    prepster/
    ├── android/                     # Android-specific configs
    ├── assets/                      # Images, icons and other assets
    ├── lib/
    │   ├── main.dart                # Entry point
    │   ├── ui/                      # UI Layer
    │   │   ├── pages/               # Pages (screens) of the app
    │   │   ├── viewmodels/          # ViewModels for each page
    │   │   └── widgets/             # Reusable UI components
    │   ├── model/                   # Model Layer
    │   │   ├── entities/            # Data entities/models
    │   │   ├── repositories/        # Repositories
    │   │   └── services/            # Services
    │   └── utils/                   # Utilities
    │       ├── constants/           # Constants for reuse
    │       └── helpers/             # Helper functions
    ├── test/                        # Tests
    │   ├── ui/
    │   │   ├── pages/
    │   │   ├── viewmodels/
    │   │   └── widgets/
    │   ├── model/
    │   │   ├── entities/
    │   │   ├── repositories/
    │   │   └── services/
    │   └── utils/
    └── pubspec.yaml                # Dependencies


