# lex-affordance

Gibson's ecological affordance perception for LegionIO — detecting action possibilities in the environment.

## What It Does

Models J.J. Gibson's ecological theory of affordances: the agent perceives its environment in terms of what actions are possible, blocked, risky, or threatening given its current capabilities. The extension maintains an affordance field that tracks opportunities, threats, and action feasibility. Affordances decay over time as the environment changes.

## Core Concept: The Affordance Field

An affordance describes an action-environment relationship from the agent's perspective:

```ruby
# Register what the agent can do
client.register_capability(name: :make_api_call, domain: :http, level: 0.9)

# Detect what the environment affords
client.detect_affordance(
  action: :deploy_service,
  domain: :infrastructure,
  affordance_type: :action_possible,
  requires: [:make_api_call],
  relevance: 0.8
)

# Check if an action is feasible
result = client.evaluate_action(action: :deploy_service, domain: :infrastructure)
# => { feasible: true, reason: :capable, risks: [], relevance: 0.8 }
```

## Usage

```ruby
client = Legion::Extensions::Affordance::Client.new

# Set environmental conditions
client.set_environment(property: :network_available, value: true, domain: :infrastructure)

# List what's immediately actionable (relevance >= 0.5)
client.actionable_affordances
# => { affordances: [...], count: 2 }

# Check for threats
client.current_threats
# => { threats: [...], count: 1 }

# Maintenance (also runs automatically every 30s via Scan actor)
client.update_affordances
```

## Integration

The `Scan` actor decays affordances every 30 seconds automatically. Wire into lex-tick's `action_selection` phase to filter candidate actions by feasibility before execution.

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
