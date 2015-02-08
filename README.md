# Jackal Slack

Slack integration for sending notifications.

## Configuration

Requires configured webhook endpoint from Slack:

```json
{
  "jackal": {
    "config": {
      "slack": {
        "webhook": SLACK_WEBHOOK
      }
    }
  }
}
```

## Payload structure

Structure within the payload supported:

```json
{
  "data": {
    "slack": {
      "messages": [
        {
          "message": MESSAGE_TO_DISPLAY,
          "color": SLACK_COLOR,
          "description": SLACK_TITLE,
          "markdown": APPLY_MARKDOWN
        }
      ]
    }
  }
}
```

Markdown formatting is enabled by default.

# Info

* Repository: https://github.com/carnivore-rb/jackal-slack
* IRC: Freenode @ #carnivore
