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
Use `/workspace/mirai/send.sh msg.json` (reads MIRAI_PEER_URL / MIRAI_PEER_KEY from env, never prints them). Equivalent:
`curl -sS -X POST "$MIRAI_PEER_URL" -H "Authorization: Bearer <key without 'Bearer ', no trailing newline>" -H "Content-Type: application/json" -d '<msg + "context": JSON string of msg>'`
- Key from the routine panel may be shown as `Bearer crsr_...`; store only `crsr_...`.
- Duplicate the whole message as a JSON string in `context` (the field known to reach the receiving prompt). On receive, read fields from the webhook event top level, else parse `context`.
- Success: HTTP 200 with `success:true`. 400 → trailing newline in key/body; 401 → regenerate key. Report status to owner only on failure.
(Endpoint/header format is based on Cursor Automations webhooks; verify with a self-test.)
