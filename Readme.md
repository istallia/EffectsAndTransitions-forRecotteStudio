# Effects & Transitions for Recotte Studio

これらはRecotte Studioのために作成したエフェクトやトランジションたちです。  
[うぷはし氏の作品](https://github.com/wallstudio/RecotteShader)から`util.hlsl`を使用しています。(おかげさまで簡単にシェーダ書けました)

## 導入

1. [Releases](https://github.com/istallia/EffectsAndTransitions-forRecotteStudio/releases)から最新のものをダウンロード
2. ダウンロードしたzipを展開する
3. Recotte Studioのインストールフォルダを探し、`～\RecotteStudio\effects`を開いておく
4. 拡張子が`.cso`のファイルをそのフォルダにコピー
5. そのフォルダに`effects`フォルダがあるので、それを開く
6. 拡張子が`.lua`と`.png`のファイルをそのフォルダにコピー

作業後、Recotte Studioを起動すればエフェクトが追加されています。

Recotte Studioは何も設定を変えていないなら`C:\Program Files\RecotteStudio`に入ってるはずです。  
アイコンが雑で気になる場合は自分で描いてください(丸投げ)

## 機能

+ 円形ワイプイン・アウト
+ すりガラス エフェクト
+ 新聞風エフェクト

## ビルド

私はSublime Text 3のBuild Systemに以下のような`HLSL(PS).sublime-build`を追加して使ってます。  
"cmd"の部分が割とそのままコマンドです。  
fxc.exeはSDK入れろと書いているサイトもありますが、最近のVisual Studioなら「C++によるゲーム開発」を入れれば`C:\Program Files (x86)\Windows Kits\10\bin\～`あたりに入ってます。  
それをフルパスで入れるか、環境変数からPathを通してお使いください。

```json
{
	"cmd"           : ["fxc", "$file_name", "/T", "ps_4_0", "/Fo", "${file_path}\\\\${file_base_name}.cso"],
	"file_patterns" : ["*.hlsl"]
}
```

## メモ

+ アニメーションさせたいオブジェクトが実際に何pxのサイズになるかはLuaでしか取れないっぽい。取り方は`param.bounds`。必要ならLuaからシェーダに渡す
+ フラグメントシェーダはピクセルシェーダの別名
+ シェーダのmain関数の引数はそれぞれ以下のような意味を持つ
	+ float4 POS : 画面幅や高さと渡されてる最中のxy位置……かな？ うぷはし氏いわく「正規化されていない」ので、FullHDなら幅は1920、高さは1080
	+ float2 UV : 画面全体のUV座標。POSと同じ原点で、xもyも0～1の範囲。`tex(uv)`で色を取るときは必ずこちらを用いる
	+ float2 UVP : エフェクトを設定したオブジェクトのUV座標。xもyも0～1の範囲。オブジェクトの中心を処理に使いたい場合は使用する
+ シェーダの`color.a`は不透明度なので、0が透明、1が不透明
