//
//  DataFiller.swift
//  Vkontakte
//
//  Created by Simon Pegg on 19.03.2023.
//

import Foundation

class DataFiller {
    
    let avatarNames: [String] = [
        "LeoAvatar", "KateAvatar", "SelenaAvatar", "MarkAvatar", "MikeAvatar", "PeterAvatar"
    ]
    
    let postPictures: [String] = [
        "PostImage0", "PostImage2", "PostImage4"
    ]
    
    let coreManager = CoreDataManager.shared
    
    var avatars: [Picture] = []

    var postImages: [Picture] = []

    func createUsers() {
        self.avatars = coreManager.fillPictures(names: avatarNames)
        var name = "Leonardo"
        var lastName = "Dicaprio"
        var jobTitle = "Actor"
        var nickName = "leoDicaprio"
        coreManager.createUser(name: name, lastName: lastName, jobTitle: jobTitle, nickName: nickName, dateOfBirth: Date(), avatar: avatars[0], isLogged: false)
        name = "Kate"
        lastName = "Winslet"
        jobTitle = "Actor"
        nickName = "kateTitanic"
        coreManager.createUser(name: name, lastName: lastName, jobTitle: jobTitle, nickName: nickName, dateOfBirth: Date(), avatar: avatars[1], isLogged: false)
        name = "Selena"
        lastName = "Gomez"
        jobTitle = "Singer"
        nickName = "ssselllenn"
        coreManager.createUser(name: name, lastName: lastName, jobTitle: jobTitle, nickName: nickName, dateOfBirth: Date(), avatar: avatars[2], isLogged: false)
        name = "Mark"
        lastName = "Wohlberg"
        jobTitle = "Actor"
        nickName = "markovnik"
        coreManager.createUser(name: name, lastName: lastName, jobTitle: jobTitle, nickName: nickName, dateOfBirth: Date(), avatar: avatars[3], isLogged: false)
        name = "Michael"
        lastName = "Jackson"
        jobTitle = "Singer"
        nickName = "mihailPevets"
        coreManager.createUser(name: name, lastName: lastName, jobTitle: jobTitle, nickName: nickName, dateOfBirth: Date(), avatar: avatars[4], isLogged: false)
        name = "Peter"
        lastName = "Jackson"
        jobTitle = "Produsser"
        nickName = "hobbit"
        coreManager.createUser(name: name, lastName: lastName, jobTitle: jobTitle, nickName: nickName, dateOfBirth: Date(), avatar: avatars[5], isLogged: false)
    }

    func createPosts() {
        self.postImages = coreManager.fillPictures(names: postPictures)
        var body = "Второй сезон сериала Amazon Studios «Властелин колец: Кольца власти» снимет полностью женская команда режиссеров. Об этом сообщает Deadline.\nНад новыми сериями будут работать Шарлотта Брандстром, Сана Хамри и Луиза Хупер. Второй сезон будет состоять из восьми эпизодов.\nОтмечается, что Брандстром уже занималась над двумя сериями первого сезона. В этот раз она будет задействована при создании четырех эпизодов, а также выступит исполнительным продюсером шоу. Ее коллеги снимут по две серии проекта.\nВ октябре сообщалось, что в Великобритании стартовали съемки второго сезона сериала «Властелин колец: Кольца власти». В главных ролях выступят Синтия Аддай-Робинсон, Роберт Арамайо, Оуайн Артур, Максим Болдри, Назанин Бониади, Морвед Кларк, Исмаэль Крус Кордова, Чарльз Эдвардс, Тристан Гравель, сэр Ленни Генри, Эма Хорват.\nДействие сериала «Властелин колец: Кольца власти» происходит за тысячи лет до событий, упомянутых в фильмах режиссера Питера Джексона. Первый сезон снимался в Новой Зеландии, съемки второго были перенесены в Великобританию для экономии и удобства."
        var title = "Второй сезон «Властелин колец: Кольца власти» снимет полностью женская команда"
        var author = coreManager.getUserByName(name: "Peter")
        coreManager.createPost(title: title, body: body, image: postImages[0], authorId: (author?.id)!)
        title = "Тайны длиной в 25 лет: раскрыты факты о фильме «Титаник»"
        body = "Например, Джек в исполнении ДиКаприо совершенно рисовать не умел. Все наброски, Роуз в том числе, делал режисер Джеймс Кэмерон. При этом, чтобы создать иллюзию рисования Джеком, картину пришлось перевернуть на монтаже, ведь Леонардо ДиКаприо — левша, а Кэмерон — правша.\nОстов затонувшего корабля под водой был самым настоящим, а не смонтированным. Режисер спускался под воду, где провел 15-17 часов, делая фотографии судна со всех возможных ракурсов.\nА знаменитой песни в конце могло и не быть вовсе. Кэмерон изначально хотел добавить лишь фоновую мелодию, но Джеймс Хорнер тайно договорился с Селин Дион о демо-записи композиции My Heart Will Go On. После прослушивания режисер устоять перед голосом исполнительницы не смог, а фильм обрел легендарный саундтрек — об этом сообщает The Voice."
        author = coreManager.getUserByName(name: "Kate")
        coreManager.createPost(title: title, body: body, image: postImages[1], authorId: (author?.id)!)
        title = "Время не пощадило: в этом лысом мужчине не узнать красавчика-жениха Роуз из «Титаника»"
        body = "Однако актер сумел сохранить былое обаяние.\nБогатого Кэла Хокли, который собирался жениться на Роуз в фильме-катастрофе сыграл Билли Зейн. После съемок в «Титанике» актер проснулся знаменитым. Однако спустя время залег на дно.\nС момента выхода популярной картины прошло уже 45 лет. За это время, понятное дело, все актеры кардинально изменилось. Особенно это коснулось красавчика Хокли. Теперь он совсем не похож на своего экранного героя: соперник Леонардо ДиКаприо лишился подтянутого тела и превратился в полного 56-летнего мужчину с лысиной на голове — от его густой темной шевелюры не осталось и следа.\nОднако, по сообщению The Voice, Зейн не страдает от недостатка внимания. Но все признания поклонниц он рубит на корню — актер живет в гражданском браке с моделью Кэндис Нэйл, которая подарила ему двух дочерей — Аву Катерину и Джию."
        author = coreManager.getUserByName(name: "Leonardo")
        coreManager.createPost(title: title, body: body, image: postImages[2], authorId: (author?.id)!)
    }
}
