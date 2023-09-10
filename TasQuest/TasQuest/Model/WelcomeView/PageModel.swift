//
//  Page.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/10.
//

import Foundation

struct Page: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var description: String
    var imageUrl: String
    var tag: Int
    
    static var samplePage = Page(name: "Title Example", description: "This is a sample description for the purpose of debugging", imageUrl: "work", tag: 0)
    
    static var samplePages: [Page] = [
        Page(name: "ようこそ、冒険者！", description: "TasQuestはあなたの目標達成を一つの冒険として捉えます。一緒に壮大な旅を始めましょう！", imageUrl: "tag0", tag: 0),
        Page(name: "目標をセット！", description: "目標ごとにタスクをグループ化し、それぞれの冒険を計画的に進めましょう。", imageUrl: "tag1", tag: 1),
        Page(name: "敵を倒そう！", description: "日々のタスクは冒険の中での敵です。進捗をつけることで敵を倒し、目標に一歩近づきます。", imageUrl: "tag2", tag: 2),
        Page(name: "攻撃で前進！", description: "タスクに対する進捗は攻撃となります。力強い攻撃で敵を一掃しましょう！", imageUrl: "tag3", tag: 3),
        Page(name: "報酬でモチベーションUP！", description: "敵を倒すごとに報酬が得られます。報酬を使って更に強力な装備やスキルを手に入れましょう！", imageUrl: "tag4", tag: 4),
        Page(name: "最終目標に挑戦！", description: "各目標ごとにはボスが存在します。準備ができたら最終目標に挑戦し、栄光を手に入れましょう！", imageUrl: "tag5", tag: 5)
    ]
}
