# Find Apps
■アプリURL<br>
https://find-apps.herokuapp.com/

# アプリケーションの概要
- 駆け出しエンジニアがオリジナルアプリをシェアするサービス。
- 全国の駆け出しエンジニアが必ず参考にするサービスにしたい。

# アプリケーションの機能
- ログイン
- オリジナルアプリ投稿
- オリジナルアプリ画像投稿
- フォロー
- お気に入り
- コメント

# 制作背景
自分がオリジナルアプリを作る際に同じ駆け出しエンジニアの作ったアプリが見れるサイトがあればいいのにと感じたことがきっかけです。

<!-- プログラミング言語や年齢・スクールなどのカテゴリーなどで検索して自分の環境に近い人が作ったオリジナルアプリを見ることができるので、かなり参考になるかと思います！ -->

# 使用した技術（開発環境）
## フレームワーク
- Ruby on Rails 6.0.3.4
- Bootstrap
- Sass

## データベース
- Mysql

# 今後解決したい課題（まだ途中）
- デザインが地味なので、よりモダンなデザインに仕上げたい。
- ユーザーが使いやすいように検索機能を 


# テーブル設計

## users テーブル

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

## apps テーブル

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

## comments テーブル

| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| user    | references | null: false, foreign_key: true |
| app     | references | null: false, foreign_key: true |
| content | text       | null: false, foreign_key: true |

### Association

- belongs_to :app
- belongs_to :user

## favorites テーブル

| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| user    | references | null: false, foreign_key: true |
| app     | references | null: false, foreign_key: true |

### Association

- belongs_to :app
- belongs_to :user

## relationships テーブル

| Column   | Type       | Options                        |
| -------- | ---------- | ------------------------------ |
| follower | integer    | null: false, foreign_key: true |
| followed | integer    | null: false, foreign_key: true |

### Association

- belongs_to :follower
- belongs_to :followed
