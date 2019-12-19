# NAME

CreateDummy - ダミーデータ作成モジュール

システムテストに使えそうな、意味のあるダミーデータを作成する。

# SYNOPSIS

$ pwd
/home/omokawa/my_perl/CreateDummy

ダミーファイル作成(引数にバイト数を与え、指定したサイズのデータを作成）

$ perl -Ilib eg/create_dummy.pl 1000

ドメイン集計(出力したファイルを引数にし、メールアドレスのドメイン数を集計して降順に出力)

$ perl -Ilib eg/summary.pl output/output_1706.csv

完全一致行の出力(出力したファイルを２つ引数にし、ログインIDが完全一致した行を出力)

$ perl -Ilib eg/match.pl output/output_1706.csv output/output_1655.csv

# DESCRIPTION

テスト用ダミーCSVファイルの作成。

以下6カラムから成るCSVを出力する。

1. 1から始まる整数
2. メールアドレス。3:2:1:4の割合でドメインをばらけさせる。4割は完全なランダムドメイン（最低数10）
3. SMTP応答コード
4. 日時(YYYY/MM/DD hh:mm:ss)
5. ログインID
6. 文字列

# LICENSE

Copyright (C) Yasuaki Omokawa.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Yasuaki Omokawa <omokawa@senk-inc.co.jp>
