## 検証目的

Docker のコンテナ同士の通信、あるいはコンテナとホストの通信をどのように制限するのかを検証する。

## 3行まとめ

* docker daemon 起動時に --icc=false をつけると、コンテナ間の通信を制限できる
* [linking system](https://docs.docker.com/userguide/dockerlinks/) で特定のコンテナ間のみ通信を許可できる
* コンテナからホストへの通信制限は iptables の INPUT チェーンで DROP する

## 検証の概要

* Vagrant で core-01 と core-02 の 2つの VM を起動
* core-01 上の a0, a1, b0, b1 の 4つのコンテナを作成
  * a0 の 80番ポートはホストの eth1 IP アドレスの 81 番ポートで expose
  * b0 の 80番ポートはホストの eth1 IP アドレスの 82 番ポートで expose
  * docker ps で見ると以下のようになる
  
```
core@core-01 ~ $ docker ps
CONTAINER ID        IMAGE                  COMMAND             CREATED             STATUS              PORTS                     NAMES
e269b354ba62        fedora/apache:latest   "/run-apache.sh"    2 minutes ago       Up 2 minutes        80/tcp                    b1
e81f524a5b78        fedora/apache:latest   "/run-apache.sh"    2 minutes ago       Up 2 minutes        172.17.8.101:82->80/tcp   b0
4940e8ee7158        fedora/apache:latest   "/run-apache.sh"    2 minutes ago       Up 2 minutes        80/tcp                    a1
efabeaecb6c7        fedora/apache:latest   "/run-apache.sh"    2 minutes ago       Up 2 minutes        172.17.8.101:81->80/tcp   a0
```

* linking system より、a1 から a0 の80番ポートへの通信を許可、b1 から b0 の 80 番ポートへの通信を許可する
* iptables によりコンテナの IP アドレス（10.1.0.0/16） から core-01 の eth1 へのパケットを DROPすることにより、expose されたポートへのコンテナからのアクセスを禁止する
* a0 から http://a1:80/ へ通信が通り、http://b0:80/ と http://b1:80/ への通信が通らないことを確認する
* b0 から http://b1:80/ へ通信が通り、http://a0:80/ と http://a1:80/ への通信が通らないことを確認する
* コンテナから http://172.17.8.101:81/ と http://172.17.8.101:82/ への通信が通らないことを確認する
* ホスト core-02 から http://172.17.8.101:81/ と http://172.17.8.101:82/ への通信が通ることを確認する

## 具体的な検証手順

具体的な手順は、[Vagrantfile](Vagrantfile) や [Serverspec によるテストコード](spec/) にコードとして落とし込んであるので参照してください。

以下のコマンドにより検証手順をすべて実行できます。最後の `bundle exec rake spec` が通れば、期待通り動作しています。

```
$ vagrant up
$ bundle install
$ bundle exec rake spec
```
