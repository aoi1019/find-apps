# Find Apps
[![Image from Gyazo](https://i.gyazo.com/9682e86d8230279486a71ece8b520ad6.png)](https://gyazo.com/9682e86d8230279486a71ece8b520ad6)

### テスト用ログイン
- メールアドレス：recruit@sample.com
- パスワード：password

## 🧠 アプリケーションの概要
- 駆け出しエンジニアがオリジナルアプリをシェアするサービス。
- 全国の駆け出しエンジニアが必ず参考にするサービスにしたい。

## 💻 アプリケーションの機能
- ログイン / ログアウト
- オリジナルアプリ投稿
- オリジナルアプリ画像投稿
- フォロー機能
- お気に入り機能
- コメント機能
- 通知機能
- 検索機能
- 開発ログ機能（自分の投稿のみに作成・表示できる機能）

## 📚 制作背景
自分がオリジナルアプリを作る際に同じ駆け出しエンジニアの作ったアプリが見れるサイトがあればいいのにと感じたことがきっかけです。
最終的には、エンジニアを欲している企業様とエンジニアになりたい人がマッチングできるアプリを目指したいと考えています。

## 🖥 使用した技術（開発環境）
### フレームワーク
- Ruby on Rails 5.2.4.4
- Bootstrap4
- Sass

### データベース
- MYSQL

## 📕 今後解決したい課題
- よりモダンなデザインに仕上げたい。
- ユーザーの情報をより設定したい。
- 検索機能をより充実させたい。


## 📖 テーブル設計

###  users テーブル

| Column   | Type    | Options     |
| -------- | ------- | ----------- |
| name     | string  | null: false |
| email    | string  | null: false |
| profile  | text    | null: false |
| age      | integer | null: false |
| password | string  | null: false |

### Association

- has_many :apps
- has_many :following, through: active_relationships
- has_many :followers, through: passive_relationships
- has_many :favorites
- has_many :comments

### apps テーブル

| Column      | Type      | Options                        |
| ----------- | --------- | ------------------------------ |
| name        | string    | null: false                    |
| description | string    | null: false                    |
| point       | string    | null: false                    |
| period      | string    | null: false                    |
| reference   | string    | null: false, foreign_key: true |
| user        | reference | null: false                    |

### Association

- belongs_to       :user
- has_many         :favorites
- has_many         :comments

### comments テーブル

| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| user    | references | null: false, foreign_key: true |
| app     | references | null: false, foreign_key: true |
| content | text       | null: false, foreign_key: true |

### Association

- belongs_to :app
- belongs_to :user

### favorites テーブル

| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| user    | references | null: false, foreign_key: true |
| app     | references | null: false, foreign_key: true |

### Association

- belongs_to :app
- belongs_to :user

### relationships テーブル

| Column   | Type       | Options                        |
| -------- | ---------- | ------------------------------ |
| follower | integer    | null: false, foreign_key: true |
| followed | integer    | null: false, foreign_key: true |

### Association

- belongs_to :follower
- belongs_to :followed

### Notificationsテーブル

| Column   | Type   | Options     |
| -------- | ------ | ----------- |
| app_id  | integer | null: false |
| user_id | integer | null: false |
| variety | integer | null: false |
| content | text    | null: false |
| from_user_id | integer    | null: false |

### Logsテーブル

| Column  | Type    | Options     |
| ------- | ------- | ----------- |
| app_id  | integer | null: false |
| content | text    | null: false |
