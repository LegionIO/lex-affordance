# Changelog

## [0.1.1] - 2026-03-17

### Fixed
- Rename `module Actors` to `module Actor` (singular) in scan actor to match LegionIO builder convention

## [0.1.0] - Initial release

### Added
- Initial implementation of affordance perception extension
- `AffordanceItem` helper with relevance, type, and decay logic
- `AffordanceField` helper with detection, evaluation, and capability registration
- `Affordance` runner with full affordance lifecycle management
- Scan actor for periodic affordance decay
