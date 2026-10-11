# ミライのメニュー

Grok Bot Tokyo Hackathon — Team Null.

## 概要
各自のGrok Botがその人の苦手な食べ物・アレルギーを覚えておき、ボット同士が相談して「全員が食べられる注文」を作ります。

## 仕組み
- 各メンバーのGrok Botが、持ち主のNG食材を記憶
- 幹事Botがメンバーのボットと相談（NG食材の共有 → 提案 → 同意）して注文を決定
- 別アカウントのボットとはWebhookで連携（共通ルール: `skill/SKILL.md`）
- 幹事Botと飲み会メンバーA/B/Cで実証済み

## ファイル
- `skill/SKILL.md` — ボット間連携の共通ルール（mirai-menu-bot-link）
- `scripts/send.sh` — Webhook送信スクリプト（相手のURL・キーは環境変数 `MIRAI_PEER_URL` / `MIRAI_PEER_KEY` から読む）
- `scripts/rimo-setup.md` — 相手側ボットの設定手順

※ URL・キーなどの秘密情報や個人のアレルギー情報は含みません。

## チーム Team Null.
- @GOROman
- @_I__l__l__l__I_
- りも (@vibe_walking)
