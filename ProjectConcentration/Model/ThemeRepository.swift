//
//  EmojiChoices.swift
//  ProjectConcentration
//
//  Created by Ilia Tsikelashvili on 27.01.22.
//

import Foundation

class ThemeRepository {
    //Used dictionary [Int: [String]] to reach emojis and [Int:String] to reach backgroundColors with the index
    let emojiForTheme =
    [
    [0: ["🐝","🐒","🐍","🦂","🦕","🦞","🪱","🦃","🐋","🦌","🦚","🐩","🦒","🐕‍🦺","🦤","🦔"]],
    [1: ["🇧🇷","🇧🇪","🇬🇪","🇩🇪","🇪🇸","🇺🇸","🏴󠁧󠁢󠁷󠁬󠁳󠁿","🏴󠁧󠁢󠁳󠁣󠁴󠁿","🇿🇦","🇳🇴","🇳🇿","🇲🇽","🇮🇹","🇯🇵","🇮🇩","🇬🇷"]],
    [2: ["🍏","🍎","🍐","🍇","🍒","🍓","🥐","🍗","🫑","🧀","🥑","🧁","🍫","🍿","🥗","🫐"]]
    ]
    
    let colorForTheme: [Int: String] =
    [
        0: "Orange",
        1: "Green",
        2: "Purple"
    ]
    
    //We are returning Array of emojis and background color from the current index
    func getThemeEmoji(with index: Int) -> ([String]?, String?){
        return (emojiForTheme[index][index], colorForTheme[index])
    }
}

