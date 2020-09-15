# Effects & Transitions for Recotte Studio

これらはRecotte Studioのために作成したエフェクトやトランジションたちです。  
[うぷはし氏の作品](https://github.com/wallstudio/RecotteShader)から`util.hlsl`を使用しています。(おかげさまで簡単にシェーダ書けました)

## 導入

1. [Releases](https://github.com/istallia/EffectsAndTransitions-forRecotteStudio/releases)から最新のものをダウンロード
2. ダウンロードしたzipを展開する
3. install.batを起動(管理者権限を要求されます)
4. (なければ)うぷはし氏のエフェクトもインストールするよう案内されるので、それに従ってインストールする

作業後、Recotte Studioを起動すればエフェクトが追加されています。

Recotte Studioは何も設定を変えていないなら`C:\Program Files\RecotteStudio`に入ってるはずです。その想定でインストーラを作ってます。  
インストールフォルダを変更している場合は、Recotte Studioのファイルパスを変えてから実行してみてください。  
アイコンが雑で気になる場合は自分で描いてください(丸投げ)

## 機能

+ 円形ワイプイン・アウト
+ すりガラス エフェクト
+ 新聞風エフェクト
+ ID隠し(すりガラス/モザイク) (ズーム機能付き)

## 使用上の注意

映像にエフェクトを適用するには、うぷはし氏のuh_dummyトランジション(エディタ上では「シェーダー適用」)が必要です。  
あちらもMITライセンスなのでこちらに含めることもできますが、今はそちらのエフェクトやトランジションを導入してから使うことを推奨します。

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
	+ float4 POS : 描画中の座標と深度(?)。正規化されていないため、FullHDならxは0～1919、yは0～1079となる。深度については不明
	+ float2 UV : 画面全体におけるUV座標。POSと同じ原点で、xもyも0～1の範囲。`tex(uv)`で色を取るときは必ずこちらを用いる
	+ float2 UVP : エフェクトを設定したオブジェクトにおけるUV座標。xもyも0～1の範囲。オブジェクトの中心を処理に使いたい場合は使用する
+ util.hlslを利用する場合、Luaから`SetShaderFloat()`や`SetShaderColor()`でシェーダに送った値は`Float0`～`Float5`、`Color0`～`Color3`で取得できる
+ シェーダの`color.a`は不透明度なので、0が透明、1が不透明
