# lex-affordance

**Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Gibson's ecological affordance perception for LegionIO — detecting action possibilities in the environment. Models the agent's ability to perceive what actions are possible, blocked, risky, or threatening given its current capabilities and environmental conditions.

## Gem Info

- **Gem name**: `lex-affordance`
- **Version**: `0.1.0`
- **Module**: `Legion::Extensions::Affordance`
- **Ruby**: `>= 3.4`
- **License**: MIT

## File Structure

```
lib/legion/extensions/affordance/
  affordance.rb              # Main extension module
  version.rb                 # VERSION = '0.1.0'
  client.rb                  # Client wrapper
  actors/
    scan.rb                  # Every 30s decay actor
  helpers/
    constants.rb             # Limits, thresholds, affordance types, labels
    affordance_item.rb       # AffordanceItem value object
    affordance_field.rb      # AffordanceField — manages all affordances, capabilities, environment
  runners/
    affordance.rb            # Runner module with 8 public methods
spec/
  (spec files)
```

## Key Constants

```ruby
MAX_AFFORDANCES            = 200
MAX_CAPABILITIES           = 50
MAX_ENVIRONMENT_PROPS      = 100
RELEVANCE_FLOOR            = 0.05
RELEVANCE_DECAY            = 0.01  # per decay tick
DEFAULT_RELEVANCE          = 0.5
URGENCY_BOOST              = 0.2
CAPABILITY_MATCH_THRESHOLD = 0.3
ACTIONABLE_THRESHOLD       = 0.5   # relevance >= this to be actionable
AFFORDANCE_TYPES = %i[action_possible action_blocked action_risky
                      resource_available resource_depleted opportunity threat neutral]
RELEVANCE_LABELS = { (0.8..) => :critical, ... (..0.2) => :negligible }
```

## Runners

### `Runners::Affordance`

All methods delegate to a private `@field` (`Helpers::AffordanceField` instance).

- `register_capability(name:, domain: :general, level: 1.0)` — register an agent capability by name
- `set_environment(property:, value:, domain: :general)` — set an environmental property
- `detect_affordance(action:, domain:, affordance_type:, requires: [], relevance: nil)` — detect and record an action affordance
- `evaluate_action(action:, domain:)` — evaluate feasibility of an action given known affordances and capabilities
- `actionable_affordances` — return affordances above the actionable threshold, sorted by relevance descending
- `current_threats` — return all threat-type affordances
- `affordances_in_domain(domain:)` — list all affordances in a domain
- `update_affordances` — decay all affordances (removes faded ones below RELEVANCE_FLOOR)
- `affordance_stats` — stats hash from AffordanceField

## Helpers

### `Helpers::AffordanceField`
The central store. Manages `@affordances`, `@capabilities`, and `@environment` hashes. `evaluate_action` checks for blockers first, then checks required capabilities against registered ones. `decay_all` reduces relevance and removes faded items.

### `Helpers::AffordanceItem`
Value object. Predicates: `actionable?`, `blocked?`, `risky?`, `threatening?`, `faded?`. `decay` reduces `@relevance` by `RELEVANCE_DECAY` each call.

## Actors

### `Actors::Scan`
`Every` actor with `INTERVAL = 30` seconds. Calls `update_affordances` to decay all affordances automatically.

## Integration Points

The `Scan` actor runs every 30 seconds to maintain the affordance field. In lex-cortex, this extension can be wired into the `action_selection` phase to filter candidate actions by feasibility before execution. The `evaluate_action` result (`feasible:`, `reason:`, `risks:`) is directly usable by action planning logic.

## Development Notes

- Affordances are identified by an auto-incremented `aff_N` symbol key, not UUIDs
- `evaluate_action` returns `:blocked` if any blocker exists for that action/domain pair, regardless of other affordances
- Capabilities are stored as `{ domain:, level: }` hashes; `check_requirements` only tests key presence, not level
- History ring buffer truncates at `MAX_HISTORY = 200` oldest-first
