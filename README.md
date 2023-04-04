<p align="center">
<img width="257" alt="Veam logo2" src="https://user-images.githubusercontent.com/127921533/227145922-4fd7c72a-9e10-499e-aef1-12d34a96df7c.png">
</p>
<br>
<p align="center">
Veam-It はアプリをノーコードで生成するアプリです
<br>
ユーチューバーたちのアプリを数多く生成し、月額課金の実績があります
<br>
ソースコードを用いて以下に記載した手順を実行すれば、ノーコードでアプリを生成するアプリが開発できます
<br>
<Br>
Veam-It is an app that generates apps with no code
<br>
We have generated many apps for YouTubers and have a proven track record of monthly subscription
<br>
You can develop a no-code app-generating app by following the steps described below
</p>
<br>
<br>

# 構成
Veam It! のソースコードは以下のディレクトリに格納されています。
* Android - Androidアプリのソースコード
* Console - Webサーバのソースコード
* iOS - iOSアプリのソースコード
<br>
<br>

# 状態
公開しているソースコードは古いフレームワークおよび環境で開発されたもののため、最新のバージョンや開発環境では動作させることはできません。
動作させるためには、新しいフレームワーク用に修正したり、最新の開発環境でビルドしたりする必要があります。
<br>
<br>

# Android
Androidアプリをビルドするためには以下の手順が必要になります。
* Android Studio を使用して最新のアプリ開発環境で空のプロジェクトを作成します
* 以下のSDKの最新バージョンをインストールします

dropbox-android-sdk

twitter4j-core

YouTubeAndroidPlayerApi

KiipSDK

json_simple
* ソースコードをプロジェクトに追加します
* パッケージ名を適切なものに修正します
* 開発環境のバージョンアップ、SDKの最新化、deprecatedコード等によりエラーが出ている箇所を修正します
* エラー修正のために必要なライブラリ、オープンソースコード等を追加します
* APIやSDKを使用するために必要なIDおよびKEYを取得してソースコード中の必要な箇所に記載します
* ドメイン名やメールアドレス等は起動するWEBサーバのものに合わせて修正します
<br>
<br>

# Console
* WEBサーバは Symfony 1.4 というフレームワークで作成されており、現在 Symfony 1.4 はメンテナンス期間が終了しているため使用できません。また、PHPのバージョンもメンテナンス期間が終了しているものになるためメンテナンス期間中のものを使用する必要があります。従って、Symfony 1.4のソースコードを解析し、Laravel等の最新のフレームワークに移植する必要があります。
* APIやSDKを使用するために必要なIDおよびKEYを取得してソースコード中の必要な箇所に記載します
* ドメイン名やメールアドレス等は起動するWEBサーバのものに合わせて修正します
<br>
<br>

# iOS
iOSアプリをビルドするためには以下の手順が必要になります。
* XCodeを使用して最新のアプリ開発環境で空のプロジェクトを作成します
* ソースコードをプロジェクトに追加します
* バンドル名を適切なものに修正します
* 開発環境のバージョンアップ、SDKの最新化、deprecatedコード等によりエラーが出ている箇所を修正します
* エラー修正のために必要なframework、オープンソースコード等を追加します
* APIやSDKを使用するために必要なIDおよびKEYを取得してソースコード中の必要な箇所に記載します
* ドメイン名やメールアドレス等は起動するWEBサーバのものに合わせて修正します
<br>
<br>
