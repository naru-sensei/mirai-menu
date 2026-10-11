# ミライのメニュー連携：りもさん側の設定（5分）

1. 自分のGrok Botに「webhookトリガーのルーティンを作って。プロンプトは『Mirai Menuのメッセージが届いたら mirai-menu-bot-link スキルに従う』」と頼む。
2. ルーティンを保存したら、ルーティンパネルから **webhook URL** と **送信キー（Bearer crsr_... の形）** をコピーし、成美さんにDMなど非公開で渡す（チャットやXの公開投稿には貼らない）。
3. 成美さんからこちらのURLとキーを受け取り、自分のBotにシークレットとして保存してもらう：
   - `MIRAI_PEER_URL` = 成美さん側のwebhook URL
   - `MIRAI_PEER_KEY` = 成美さん側のキー（"Bearer " を除いた crsr_... の部分、改行なし）
   - `MIRAI_PASSPHRASE` = 2人で決めた合言葉（両方同じ値）
4. スキル mirai-menu-bot-link を自分のBotにも入れる（成美さんから内容を共有）。
5. テスト：成美さん側から {"protocol":"mirai-menu/v1","type":"preferences",...} を送ってもらい、自分のBotが起動して proposal を返せばOK。
   - 400 → キーの末尾に改行が入っている可能性。401 → キーを再生成。
