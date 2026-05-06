# SwiftDataのDeleteRuleを確認するもの

## 使い方

### ContentView 内で立ち上げるクラスを指定

```
typealias ModelL = ModelOneOneUnidirL
typealias ModelR = ModelOneOneUnidirR
```

クラスは左と右がセットになっている。
組み合わせは以下の通り。

- ModelOneOneUnidirL / ModelOneOneUnidirR 1対1 片方向
- ModelOneOneBidirL / ModelOneOneBidirR 1対1 双方向
- ModelOneManyUnidir1L / ModelOneManyUnidir1R 1対多 1から多への片方向
- ModelOneManyUnidir2L / ModelOneManyUnidir2R 1対多 多から1への片方向
- ModelOneManyBidirL / ModelOneManyBidirR 1対多 双方向
- ModelManyManyUnidirL / ModelManyManyUnidirR 多対多 片方向参照
- ModelManyManyBidirL / ModelManyManyBidirR 多対多 双方向参照

### クラスの定義でDelete Ruleを設定する

それぞれのクラスでDelete Ruleを指定しているところを書き換える

```
@Relationship(deleteRule: .cascade) var r: ModelOneOneUnidirR?
```

## 注意

多対多 片方向参照 は機能しない。機能しないとこを知るために入れてある。
