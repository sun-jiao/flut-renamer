# Pull Request - Feature Enhancements and Improvements

## Description

This PR introduces several significant improvements to the Flut Renamer application, enhancing both functionality and robustness.

## Key Features and Enhancements

### 1. Logging System
- Added a new `Logger` class in `lib/tools/logger.dart` that provides real-time logging capabilities
- Implements singleton pattern for global access
- Supports live log streaming for UI feedback
- Includes timestamped log entries with clear formatting

### 2. Enhanced Metadata Processing
- Improved `FileMetadata` class in `lib/tools/file_metadata.dart`
- Added comprehensive error handling for metadata extraction
- Enhanced metadata tag detection regex to support underscores and other characters
- Added support for `OS:UUID` and `OS:RandomString` metadata fields

### 3. Improved Replace Rule
- Enhanced `RuleReplace` class in `lib/rules/rule_replace.dart`
- Added automatic `{RandomString}` tag replacement with 8-digit random alphanumeric strings
- Improved metadata tag detection and parsing
- Added error handling for tag processing failures

### 4. New Dependency
- Added `uuid: ^4.4.0` dependency for UUID generation
- This enables reliable and unique identifier creation for files

## Changes Made

- Created `lib/tools/logger.dart` - new logging system
- Modified `lib/tools/file_metadata.dart` - enhanced metadata processing
- Modified `lib/rules/rule_replace.dart` - improved replace rule functionality
- Updated `pubspec.yaml` - added uuid dependency

## Benefits

- Provides users with real-time feedback on renaming operations via log messages
- Increases application robustness with enhanced error handling
- Adds new powerful metadata fields for more flexible renaming
- Improves user experience with automatic random string generation

## Testing

All existing functionality remains intact, and the new features have been tested for compatibility across platforms. The application continues to support all existing renaming rules while adding the new enhancements.

## License

This contribution adheres to the existing project license.
