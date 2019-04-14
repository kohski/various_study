# 基本
- psql -l データベースの一覧
- create database [blogapp]
- psql [blogapp]
- psqlプロンプトにて
  - create table posts (title varchar(255), body text);
  - alter table posts renameto myposts;
  - drop table myposts
  - \dt テーブル表示
  - \d [table name ] => column-name表示
- コメント
  - --1行コメント
  - /\*複行コメント\*/

# データ型
- 数値
  - Integer ---普通の整数型
  - real ---少数も含む場合
  - serial --- 連番
- 文字列
  - char(5) ---5文字の固定長
  - varchar(255) ---255文字の可変長
  - text ---上限なし
- 真偽値
  - boolean ---TRUE/FALSE , t/f
- 日付
  - date, time, timestamp
# 制約
- not null
- unique
- check
- default
- primary key(unique and not null) ---only one declare in one table

# select文
- select field1,filed2,... from table-name
- select * from where field-name 条件
  - < > <= >= = <> !=
  - where name like 'wild card'
    - % 任意の文字
    - \_任意の1文字 
# oreder by文
- select * from users order by field-name asc/desc
- select * from users order by field-name1, field-name2
# limit/offset
- select * from users limit 3 offset 2 二つ飛ばして3つ分。3位から5位まで。
# 集計
- select sum(score) from users
  - sum
  - min/max
  - count
  - avg
- group byでまとめる
  - select team,sum(score) from users group by team
  - select team,sum(score) from users group by team having sum(score) > 10.0; 合計が10点以上のチームで合計点とチーム名を抽出
# psqlの数式
- length
  - select name, length(name) from users;
- concat
  - select concat(name,'(',team,')') from users;
- as
  - select concat(name,'(',team,')') as namelabelfrom users;
- substring
  - mid関数のイメージ
- random
  - select * from users order by random() limit 1;

# 更新削除
- update テーブル名 set フィールド=値 where 検索条件;
  - update users set score = 5.8 where name = 'taguchi';
  - update users set score = score +1 where team = 'red';
- delete from テーブル where 条件;
# テーブル構造の変更
  - alter table users add fullname データ型
  - alter table users drop fullname
  - aleter table users rename name to myname
  - alter table users alter フィールド type タイプ
  - インデックスの追加削除
    - create index インデックス名 on テーブル名(フィールド名)
    - drop index  インデックス名
# 複数テーブルの関連付け
  - テーブル名.カラム名で指定
  - whereで関連付けを指定
    - select users.name ,posts.title from users, posts where users.id = posts.user\_id;
  - 略称を使う。from句で定義してあげる。
  - あとは、andでwhere句を繋げることが可能
    - select users.name ,posts.title from users, posts where users.id = posts.user_id;
# viewの設定削除
長いSQLについては別名で登録しておける
  - create view ビュー名 as SQL
    - create view taguchi_posts as select u.name,p.title from users u,posts p where u.id = p.user_id and u.id = 1;
  - 削除は drop view ビュー名
# transactionの設定
一連の処理を割り込みされないことが保証された状態でやりたい
- bigin;
- SQL文1;
- SQL文2;
- commit;  
で完了  
- begin;
- SQL文
- ...あかん。とちゅうでやめたい...
- rollback;
で中断。
