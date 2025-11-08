//
//  Story.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import Foundation

struct Story: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let startSceneId: String
    let scenes: [StoryScene]
    let characters: [StoryCharacter]
    
    init(title: String, description: String, startSceneId: String, characters: [StoryCharacter], scenes: [StoryScene]) {
        self.title = title
        self.description = description
        self.startSceneId = startSceneId
        self.characters = characters
        self.scenes = scenes
    }
}

struct StoryScene: Identifiable, Codable {
    let id: String
    let title: String
    let content: String
    let choices: [StoryChoice]
    let isEnding: Bool
    let characterInfo: String?
    
    init(id: String, title: String, content: String, choices: [StoryChoice], isEnding: Bool = false, characterInfo: String? = nil) {
        self.id = id
        self.title = title
        self.content = content
        self.choices = choices
        self.isEnding = isEnding
        self.characterInfo = characterInfo
    }
}

struct StoryChoice: Identifiable, Codable {
    let id = UUID()
    let text: String
    let nextSceneId: String?
    let consequence: String?
    
    init(text: String, nextSceneId: String?, consequence: String? = nil) {
        self.text = text
        self.nextSceneId = nextSceneId
        self.consequence = consequence
    }
}

struct StoryCharacter: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let role: String
    
    init(name: String, description: String, role: String) {
        self.name = name
        self.description = description
        self.role = role
    }
}

// Sample data
extension Story {
    static let sampleStories: [Story] = [
        Story(
            title: "Son Katedralin Günahkarları",
            description: "Katedralde mahsur kalan beş kişinin hikayesi",
            startSceneId: "scene_1",
            characters: [
                StoryCharacter(
                    name: "Dr. Altan",
                    description: "Soğukkanlı ve analitik. Gözleri sürekli çevreyi tarıyor, bir çıkış yolu, bir zayıf nokta arıyordu.",
                    role: "Bilim İnsanı"
                ),
                StoryCharacter(
                    name: "İsmail",
                    description: "İri yarı ve pragmatik. Bu durumdan kaba kuvvetle çıkılabileceğine inanıyor gibiydi.",
                    role: "Kasap"
                ),
                StoryCharacter(
                    name: "Cem",
                    description: "Titrek ve solgun. Terliyordu ve gözleri seğiriyordu. Krizin eşiğinde olduğu her halinden belliydi.",
                    role: "Tıp Öğrencisi"
                ),
                StoryCharacter(
                    name: "Peder Elvan",
                    description: "Üzerindeki cübbeye rağmen gözlerinde dünyevi bir kurnazlık vardı. Sakin görünmeye çalışsa da, asıl endişesi farklıydı.",
                    role: "Din Adamı"
                ),
                StoryCharacter(
                    name: "Selin",
                    description: "Telefonunda sinyal olmadığını fark edince yüzü düştü. Dünyayla bağlantısı kopmuştu.",
                    role: "Influencer"
                )
            ],
            scenes: [
                StoryScene(
                    id: "scene_1",
                    title: "İlk Hamle",
                    content: "Dışarıda sirenler kulakları tırmalıyor, ardından gelen sarsıntıyla birlikte devasa katedralin vitray camları zangırdıyordu. Az önce itiraflarını sıralayan günahkârlar ve günah çıkaran Peder, şimdi aynı kaderin mahkumlarıydı. Patlamanın şiddetiyle katedralin devasa ahşap kapıları içeri çökmüş, girişi tonlarca molozla kapatmıştı. Toz bulutu dağıldığında, loş ve tekinsiz bir sessizlik çöktü. Kutsal mekân, artık bir mezardı. Beş kişi, birbirlerine korku ve güvensizlikle bakıyorlardı.",
                    choices: [
                        StoryChoice(
                            text: "Hemen bir çıkış yolu aramaya odaklanalım. Katedralin yapısını inceleyip zayıf bir nokta, bir mahzen veya alternatif bir geçit bulmaya çalışalım.",
                            nextSceneId: "scene_2"
                        ),
                        StoryChoice(
                            text: "Acele etmeyelim. Önce sakinleşip durumu değerlendirelim. Katedralin içinde kullanabileceğimiz su, yiyecek veya ilk yardım malzemesi gibi kaynakları araştıralım.",
                            nextSceneId: "scene_3"
                        )
                    ]
                )
            ]
        )
    ]
}