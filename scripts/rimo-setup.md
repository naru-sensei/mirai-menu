# ミライのメニュー連携：りもさん側の設定（5分）

1. 自分のGrok Botに「webhookトリガーのルーティンを作って。プロンプトは『Mirai Menuのメッセージが届いたら mirai-menu-bot-link スキルに従う』」と頼む。
2. ルーティンを保存したら、ルーティンパネルから **webhook URL** と **送信キー（Bearer crsr_... の形）** をコピーし、ナル先生にDMなど非公開で渡す（チャットやXの公開投稿には貼らない）。
3. ナル先生からこちらのURLとキーを受け取り、自分のBotにシークレットとして保存してもらう：
   - `MIRAI_PEER_URL` = ナル先生側のwebhook URL
   - `MIRAI_PEER_KEY` = ナル先生側のキー（"Bearer " を除いた crsr_... の部分、改行なし）
   - `MIRAI_PASSPHRASE` = 2人で決めた合言葉（両方同じ値）
4. スキル mirai-menu-bot-link を自分のBotにも入れる（ナル先生から内容を共有）。
5. テスト：ナル先生側から {"protocol":"mirai-menu/v1","type":"preferences",...} を送ってもらい、自分のBotが起動して proposal を返せばOK。
   - 400 → キーの末尾に改行が入っている可能性。401 → キーを再生成。
