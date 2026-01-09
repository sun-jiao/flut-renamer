# Pull Request - Add Logging and Enhanced Metadata Features

## Summary

Adds logging system and enhances metadata processing for Flut Renamer.

## Key Changes

1. **New Logging System** (`lib/tools/logger.dart`)
   - Singleton logger with real-time log streaming
   - Timestamped log entries with stream support

2. **Enhanced Metadata Handling** (`lib/tools/file_metadata.dart`)
   - Added OS:UUID and OS:RandomString metadata fields
   - Improved error handling and tag detection regex

3. **Updated Replace Rule** (`lib/rules/rule_replace.dart`)
   - Added {RandomString} tag support (8-digit random string)
   - Enhanced tag detection and parsing

4. **Dependency Update** (`pubspec.yaml`)
   - Added uuid: ^4.4.0 package for UUID generation

## Benefits

- Real-time operation feedback via logs
- More robust metadata extraction with error handling
- New powerful metadata fields for flexible renaming
- Auto-generate random strings for unique filenames

## Compatibility

All existing functionality remains intact. New features tested across platforms.
