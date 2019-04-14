# sqlite3について

## 基本コマンド
- sqlite3 myapp.db
  なければ作成
- 外部ファイルの読み込み
  - sqlite3 myapp.db < 外部ファイル
  - sqlite3 myapp.db
    >> .read 外部ファイル

## table作成と確認
- create table テーブル名 (id, name, body);
  - 大文字小文字は区別なし
  - ;忘れに注意
- 確認コマンド
  - .tables
  - .schema
  - .schema table名
## データ型の作成
- integer --整数
- real --浮動小数
- text --文字列
- brob --binary real object 型 
- null 

## table操作
- table削除
  - drop table if exists テーブル名
- table rename
  - alter table 旧テーブル名 rename to 新テーブル名;
- add column
  - alter table テーブル名 add column カラム名 データ型;
  - カラムの削除や変更はできないので注意
## recordの挿入
- insert into (テーブル名s) values (数値s) 
  - prymary key設定している場合は、省略　or　null指定してても連番
  - 文字列はシングルクオテーション。
  - シングルクオテーションのエスケープは''
  - 開業の特殊文字はなし。普通に開業すればOK。
## カラム制約
  - not null
  - check(条件)
  - unique
  - default 数値
```sql
create table  users (
  id integer primary key,
  name text not null,
  score integer default 10 check(score >= 0),
  email text unique 
);
```
## select文と各種オプション
- header表示
  - .headers on
- 別名カラム設定
  - as 別名
- 表示形式変更
  .mode ***
  - line　1カラムずつ改行
  - csv csv形式
  - html htmlのtable形式
  - column
```sql 
.headers on
select id,name as user_name from users;

.mode line
select * from users;

.mode csv
select * from users;

.mode html
select * from users;

.mode column
select * from users;
```

## where条件色々
- < > =(==) <>(!=) >= <=
- and or not
- between
  - where フィールド between 下限 and 上限;
- in 
  - where フィールド in ('値1','値2'...);
- null検索はis / is not
```sql
select * from users where score > 50 and score < 80;
select * from users where score between 50 and 80;
select * from users where name in ('taguchi','fkoji');
select * from users where score is null;
select * from users where score is not null;
```
## LIKE演算子による検索
- 検索文字列をジャスト検索するときは大文字小文字区別
- だけど、likeでは小文字無視
- _は1文字ワイルドカード
```sql
select * from users where name like 's___';
select * from users where name like 'S___';
```
- %は0文字以上ワイルドカード
```sql
select * from users where name like '%i';
```
- %をエスケープしたいときは、文末でescapeキーワードを使って、
エスケープする
```sql
select * from users where name like '%\%' escape '\';
```

## glob検索
露骨にLIKEの上位版
- 大文字小文字を区別
- ?...一文字、　＊ ...任意文字数
- 正規表現も対応 [a-z]とか。
- エスケープは[]で囲む。<-正規表現ルールやな。
```sql
select * from users where name glob '*i*';
select * from users where name glob '*I*';
select * from users where name glob '*[ts]*';
select * from users where name glob '[a-m]*';
select * from users where name glob '*[*]';
```
## oerder by / limit 
- order by フィールド名 昇順
- order by フィールド名 desc 降順
- order by フィールド名 desc limit 3
  - 上位3つ
- order by フィールド名 desc limit 3 offset 2
  - 上位二つを飛ばして、3つぶん（3~5位）
- order by フィールド名 desc limit 2,3 も同じ意味
```sql 
select * from users where score is not null order by score desc limit 3;
select * from users where score is not null order by score desc limit 3 offset 2;
select * from users where score is not null order by score desc limit 2,3;
```
## viewによる検索条件の保存
- create view ビュー名 as 検索条件;
- select * from ビュー名;
- drop view ビュー名;
- drop view if exists ビュー名;
```sql
create view hiscore as select * from users where score is not null order by score desc limit 5;
select * from hiscore;
drop view hiscore;
drop view if exsits hiscore;
```

## 演算関連
- 演算はselect直下で可能
- 文字列連結 || でできる
```sql 
select id, name, score+10 as new_score from users;
select 'Name:' || name as my_name, score+10 as new_score from users;
```

## group byによる演算
- avgやsumを束ねるのはgroup by
- group byした結果をソートしたいときはhaving句を使う
- group byする前が欲しいときは、where句
- distinctは重複削除する。keysメソッド的な。
- count(distcinct フィールド名)だったら、レコードの種類を取得できる
```sql
select team,avg(score) from users group by team;
-- having は集計後の結果をソートする
select team,avg(score) from users group by team having avg(score) > 50;
-- whereは集計前のレコードをソートする
select team,avg(score) from users where score > 50 group by team;
select distinct team from users;
```

## case文
条件分岐して別名をつけるような場合
```sql
select id, name, score, 
  case 
    when score > 70 then 'A'
    when score > 50 then 'B'
    else 'C'
  end as rank
from users;

select id,name,team,
  case team
    when 'team-A' then 'Bear'
    when 'team-B' then 'Panda'
    when 'team-C' then 'Python'
    else 'nobody'
  end as mascot
from users ;
```

## update / delete
- 更新
  - update テーブル名 set フィールド = 値,... where 条件;
- 削除
  - delete from フィールド名 where 条件;
```sql
update users set score = 0,name = '*' || name where score < 60;
delete from users where score = 0;
```

## transaction
データの整合性をとる仕組み
```sql 
select * from users;
begin transaction;
update users set score = score + 10 where name = 'fkoji';
update users set score = score - 10 where name = 'taguchi';
commit;
```
ダメだったら途中でとめるしくみ
```sql
begin transaction;
update users set score = score + 10 where name = 'fkoji';
update users set score = score - 10 where name = 'taguchi';
rollback;
select * from users;
```
## Trigger ***要復習***
update/delete/insertされた時に実行される処理を定義できるが**trigger**
begin ~ end;の間はどんな処理もかける.
```sql
drop table if exists messages;
create table messages (message);
create trigger new_winner update of score on users when new.score > 100
begin
  insert into messages(message) values (
    'name' || new.name || ' ' || old.score || '->' || new.score
  );
end;
update users set score = score + 30; --ここでフックされる！
select * from messages;
```

## indxの設定について
- 検索性能の工場のためにindexを設定できる。（ひとつひとつのデータにユニーク番号をはるイメージ？）
```sql
create index score_index on users(score);
```
- ユニークなインデックスを貼ることも可能
```sql
create unique index name_index on users(name);
```
- index自体は.schemaで確認可能
- primary key制約をつけるのはunique制約をつけるのと同じ
- 削除は
```sql
drop index if exists score_index;
drop index if exists name_index;
```

## 日時データの使用
sqliteにおいては、date型もdatetime型も全部numericになってしまう...
文字列をだましだまし使うしかない。
```sql
select datetime('now','+09:00:00');
select date('2015-07-17','+3 months','start of month', '-1 day');
select * from users;
```

## 内部結合について
両方ともデータがあるものをひっぱってくる結合
select 抽出カラム from inner join on (結合条件)
innerは省略可能  
[ベン図による解説](https://doruby.jp/users/kodama/entries/join%E3%82%92%E3%83%99%E3%83%B3%E5%9B%B3%E3%81%A7%E8%A7%A3%E8%AA%AC)
```sql
select * from posts inner join comments on posts.id = comments.post_id;
```

## 外部結合
上記リンク参照
outerは省略可能
```sql
select * from posts left outer join comments on posts.id = comments.post_id;
```

## 交差結合
ぜんぶ持ってくる
```sql
select * from posts cross join comments;
```
## rowidとautoincrement
内部的にレコードに連番をつけているのがrowid
rowidはそのままの設定だと既存の最後のrowidが削除されたら
そこを埋めるように採番される。
途中が抜けても埋まらない。
それが嫌ならautoincrementをつければOK
```sql
drop table if exists users;
create table if not exists users (
  id integer primary key autoincrement,
  name text
);
insert into users (name) values ('a');
insert into users (name) values ('b');
insert into users (name) values ('c');

.headers on
.mode column

select rowid, * from users; -- primary keyを設定するとrowidを参照しにいく
delete from users where name = 'c';
insert into users (name) values ('d');
select rowid, * from users; 
```

## dump
データベースの内容とscrmaを出力することが可能
```sql
.output sample.dump.sql
.dump users
```

## csvの入力、出力
- csvで入力すると、rowidがつかないのでcolumn不足のエラーが出る。
- csv側にidカラムをつくって、nullと入れておいても全部文字列で評価される
- tempのテーブルを作ってそこにid以外のデータを流し込んでincrement作成
- それを insert into users select temp (カラム名)って感じでmergeする。
- insert into はvaluesだけじゃない。
inport側の処理
```sql
.mode csv
create table temp (
  name,
  score
);
.import source.csv temp

insert into users select name, score from temp;
drop table if exists temp;
```
output時の処理
```sql
.header off
.mode csv
.output users_data.csv
select * from users;
```