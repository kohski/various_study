# 関連gemのインストール
  gem install sinatra sinatra-contib activerecord sqlite3 --no-document
# rootの設定
  - app.rbを作成
  - sinatraをrequire
  - getメソッドに'/'を設定。ブロックでメッセージを追加。
  ```rb
  get '/' do
  'Hello World'
  end
  ```
# /helloルートの作成
  - /helloをgetで指定
  - reloadされないので、sinatraのsinatra/reloaderをrequireする
  ```rb
  get '/hello/' do
    "hello 10000"
  end
  ```

# paramsの扱い
  ```rb
  # url上はシンボルで受ける.paramsメソッドで反映
  get '/hello/:name' do
    "hello #{params[:name]}"
  end

  # シンボルで受けて、ブロックでさばくパターン。こっちの方がこなれてる。
  get '/hello/:name' do |name|
    "hello #{name}"
  end

  # 複数パターンはこう
  get '/hello/:f/:l' do |f,l|
    "hello #{f} #{l}"
  end
  
  # 必須じゃなければ?をつける。/?としないと、/省略できない。
  get '/hello/:f/?:l?' do |f,l|
    "hello #{f} #{l}"
  end
  ```
# ワイルカードと正規表現
  ```rb
  # ワイルドカードで取得。ブロック引数を用意。
  get '/hello/*/*' do |f,l|
    "hello #{f} #{l}"
  end

  get '/hello/*/*' do
    #params[:splat]で配列で取得
    #{"splat"=>["aaa", "bbb"]}って感じで入るので、
    "hello #{params[:splat][0]} #{params[:splat][1]}"
  end

  # 正規表現は//で基本いけるけど、URLの使用文字列とかぶるので、%rで明示的に宣言している。
  get %r{/users/([0-9]*)} do
    # 正規表現でキャプチャー。()でキャッチできたやつ。配列になる。
    # {"captures"=>["12234"]}
    "user_id = #{params[:captures][0]}"
  end
  ```
# ビューの設定
## フォルダ作成
ルートディレクト直下に「views」を作成
## ビューへの転送
```rb
get '/' do
  erb :index
end

get '/about' do
  erb :about
end
```
## viewsに同名ファイルを作成
index.erb / about.erb
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Document</title>
</head>
<body>
  <h1>Hello</h1>
</body>
</html>
```

# layout.erb
/views/layout.erbと命名すると、sinatraがテンプレートとして認識してくれる。
共通コードだけ抜き出す
```rb
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title><%= @title %></title>
</head>
<body>
  <%= yield %>
</body>
</html>
```
# css適用
cssやjsはpublic/css やpublic/javascriptにて作成
template側ではpublicをルートとしてlinkタグを書く
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title><%= @title %></title>
  <link rel="stylesheet" href="css/styles.css">
</head>
<body>
  <div class="container">
    <%= yield %>
  </div>
</body>
</html>
```
# sqlite3の準備
seeds.sqlを作成して、
```rb
drop table if exists comments;

create table comments (
  id integer primary key,
  body text
);
insert into comments (body) values ('comment 1');
insert into comments (body) values ('comment 2');
insert into comments (body) values ('comment 3');
```
ターミナルにて、
$ sqlite3 bbs.db < seeds.db
$ sqlite3 bbs.db
sqlite3 => select * from comments
; 忘れ多発...

# active_recordの設定
app.rbにて
```rb
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: './bbs.db'
)

class Comment < ActiveRecord::Base
end
```
あとは、routingのところでデータ設定
```rb
get '/' do
  @title = 'My BBS'
  @comments = Comment.all
  erb :index
end
```
@commentsをview側でループしてキャッチ
```rb
<ul>
  <% @comments.each do |comment|%>
    <li><%= comment.body %></li>
  <% end %>
</ul>
```
# XSS対策とvalidation
view側でのrender時に、jsなどが実行されてしまうので、
Rack::Utilsで定義されているescape_htmlを使ってエスケープ
```rb
<ul>
  <% @comments.each do |comment|%>
    <li><%= Rack::Utils.escape_html(comment.body) %></li>
  <% end %>
</ul>
```
# コメント削除
## Ajax対応
1. mdn読み込み
2. main.js　作成
  jQueryでAjaxとばす練習は必要かも...
  ```js
  $(function(){
    $('.delete').on("click",function(){
      var li = $(this).parent()
      if (!confirm('sure?')) {
        return;
      }
      $.post('/destroy',{
        id: li.data('id'),
        _csrf: li.data('token')
      }, function(){
        li.fadeOut(300)
      })
    })
  })
  ```
## XSRF対策
いろいろ難しいんだけど、  
1. gem install rack_csrf
2. require 'rack/csrf'
  ここでserver再起動
3. app.rb内にてRack::Csrfの宣言をする。
```rb
require 'rack/csrf'

use Rack::Session::Cookie, secret: "thissisomethingsecret"
use Rack::Csrf, raise: true
```
4. createの箇所にはcsrf_tagを設置
これでhidden_input fieldができる
```rb
Rack::Csrf.csrf_tag(env)
```
5. deleteはajaxで実装されているので、csrf_tokenを使用

ajaxで送信される li に入れ込むために、data-tokenに入れ込む。
```html
<ul>
  <% @comments.each do |comment| %>
    <li data-id="<%= comment.id %>" data-token="<%= Rack::Csrf.csrf_tag(env) %>" >
    <%= h(comment.body) %>
    <span class="delete">[ｘ]</span></li>
  <% end %>
</ul>
```
jsがわで、data-tokenを受け取る
_csrfの記述がそう
```js
$(function(){
  $('.delete').on("click",function(){
    var li = $(this).parent()
    if (!confirm('sure?')) {
      return;
    }
    $.post('/destroy',{
      id: li.data('id'),
      _csrf: li.data('token')
    }, function(){
      li.fadeOut(300)
    })
  })
})
```
これでrequestに固有のハッシュ数値を入れ込んで、req <=> resが
ちゃんと対応しているか確認できる

# ヘルパー使用
app.rb内に定義
```rb
helpers do
  # 処理
end
```
記述後はあまねくhelperが行き渡る




