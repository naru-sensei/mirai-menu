---
name: Mirai Menu bot link
description: >-
  Use when your bot must exchange dining preferences (allergies, dislikes, drink
  limits) with another person's Grok Bot over webhooks to build a group
  restaurant order everyone can eat (ミライのメニュー連携).
---
# ミライのメニュー ボット連携（Webhook）

Two Grok Bots owned by different people talk through webhooks. Each bot has a routine with a webhook trigger (its inbox) and knows the peer's webhook URL and sender key (given by its owner, stored as env vars, never pasted in chat).

## Setup (once per bot)
1. Create a routine with trigger `{ "type": "webhook" }` whose prompt says: "When a Mirai Menu message arrives, follow the Mirai Menu bot link skill."
2. Owner copies this routine's webhook URL + sender key from the routine panel and gives them to the peer's owner.
3. Owner stores the PEER's URL and key as secrets, e.g. `MIRAI_PEER_URL`, `MIRAI_PEER_KEY` (secret request, not chat). Agree on a shared passphrase `MIRAI_PASSPHRASE`.

## Message format (JSON body)
```json
{
  "protocol": "mirai-menu/v1",
  "passphrase": "<shared>",
  "from_bot": "<bot name>",
  "table_id": "<restaurant/table or event id>",
  "type": "preferences | proposal | agree | reject",
  "constraints": { "avoid": ["crustaceans"], "allergy": true, "drinks": "beer max 1, then non-alcoholic" },
  "proposal": ["dish", "..."],
  "note": "short text"
}
```
Privacy: send only what is needed to order (what to avoid), never the owner's name, reasons, or health details beyond the item to avoid.

## On receiving (webhook wake)
1. Ignore and stop if `protocol` or `passphrase` doesn't match.
2. `preferences`: merge peer constraints with your owner's from memory; build a proposal that avoids every listed item; POST it back as `proposal`.
3. `proposal`: check every dish against your owner's constraints. All OK, POST `agree`; otherwise POST `reject` with a fixed proposal.
4. `agree`: tell your owner the final order in chat. Stop after agree to avoid loops; max 5 rounds per table_id.

## Sending
POST with Shell, e.g. `curl -sS -X POST "$MIRAI_PEER_URL" -H "Content-Type: application/json" -H "Authorization: Bearer $MIRAI_PEER_KEY" -d @msg.json` (use whatever header the routine panel says the sender key goes in). Report the HTTP status to your owner only if it fails.
