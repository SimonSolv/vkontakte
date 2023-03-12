////
////  File.swift
////  Vkontakte
////
////  Created by Simon Pegg on 03.03.2023.
////
//
//import UIKit
//
//struct PostStorage {
//    
//    var authors = UserStorage().users
//    
//    var posts: [Post] = []
//
//    init(authors: [User] = UserStorage().users) {
//        self.authors = authors
//        self.posts = [
//            Post(title: "Второй сезон «Властелин колец: Кольца власти» снимет полностью женская команда", body: "Второй сезон сериала Amazon Studios «Властелин колец: Кольца власти» снимет полностью женская команда режиссеров. Об этом сообщает Deadline.\nНад новыми сериями будут работать Шарлотта Брандстром, Сана Хамри и Луиза Хупер. Второй сезон будет состоять из восьми эпизодов.\nОтмечается, что Брандстром уже занималась над двумя сериями первого сезона. В этот раз она будет задействована при создании четырех эпизодов, а также выступит исполнительным продюсером шоу. Ее коллеги снимут по две серии проекта.\nВ октябре сообщалось, что в Великобритании стартовали съемки второго сезона сериала «Властелин колец: Кольца власти». В главных ролях выступят Синтия Аддай-Робинсон, Роберт Арамайо, Оуайн Артур, Максим Болдри, Назанин Бониади, Морвед Кларк, Исмаэль Крус Кордова, Чарльз Эдвардс, Тристан Гравель, сэр Ленни Генри, Эма Хорват.\nДействие сериала «Властелин колец: Кольца власти» происходит за тысячи лет до событий, упомянутых в фильмах режиссера Питера Джексона. Первый сезон снимался в Новой Зеландии, съемки второго были перенесены в Великобританию для экономии и удобства.", author: authors[0], likes: Int(arc4random_uniform(600)), comments: Int(arc4random_uniform(100)), bookmarked: false, image: "PostImage0"),
//            Post(title: "Тайны длиной в 25 лет: раскрыты факты о фильме «Титаник»", body: "Например, Джек в исполнении ДиКаприо совершенно рисовать не умел. Все наброски, Роуз в том числе, делал режисер Джеймс Кэмерон. При этом, чтобы создать иллюзию рисования Джеком, картину пришлось перевернуть на монтаже, ведь Леонардо ДиКаприо — левша, а Кэмерон — правша.\nОстов затонувшего корабля под водой был самым настоящим, а не смонтированным. Режисер спускался под воду, где провел 15-17 часов, делая фотографии судна со всех возможных ракурсов.\nА знаменитой песни в конце могло и не быть вовсе. Кэмерон изначально хотел добавить лишь фоновую мелодию, но Джеймс Хорнер тайно договорился с Селин Дион о демо-записи композиции My Heart Will Go On. После прослушивания режисер устоять перед голосом исполнительницы не смог, а фильм обрел легендарный саундтрек — об этом сообщает The Voice.", author: authors[1], likes: Int(arc4random_uniform(600)), comments: Int(arc4random_uniform(100)), bookmarked: false, image: "PostImage2"),
//            Post(title: "Время не пощадило: в этом лысом мужчине не узнать красавчика-жениха Роуз из «Титаника»", body: "Однако актер сумел сохранить былое обаяние.\nБогатого Кэла Хокли, который собирался жениться на Роуз в фильме-катастрофе сыграл Билли Зейн. После съемок в «Титанике» актер проснулся знаменитым. Однако спустя время залег на дно.\nС момента выхода популярной картины прошло уже 45 лет. За это время, понятное дело, все актеры кардинально изменилось. Особенно это коснулось красавчика Хокли. Теперь он совсем не похож на своего экранного героя: соперник Леонардо ДиКаприо лишился подтянутого тела и превратился в полного 56-летнего мужчину с лысиной на голове — от его густой темной шевелюры не осталось и следа.\nОднако, по сообщению The Voice, Зейн не страдает от недостатка внимания. Но все признания поклонниц он рубит на корню — актер живет в гражданском браке с моделью Кэндис Нэйл, которая подарила ему двух дочерей — Аву Катерину и Джию.", author: authors[2], likes: Int(arc4random_uniform(600)), comments: Int(arc4random_uniform(100)), bookmarked: false, image: "PostImage3"),
//            Post(title: "Пора не пенсию: ДиКаприо возьмется за последнюю работу", body: "Экранизация романов Стивена Кинга — отдельный вид искусства, принять участие в съемках таких картин желает чуть ли не весь Голливуд.\nНа этот раз повезло Леонардо ДиКаприо, который, по всей вероятности, сыграет главного героя Билли Саммерса в экранизации одноименного романа. Режиссером картины выступит Джей Джей Абрамс, о котором долгое время ничего не было слышно.\nИздание Deadline пишет, что Билли — наемный убийца, вынужденный взяться за последнюю работу перед выходом на пенсию. Видимо, Лео скоро предстанет именно в таком образе.", author: authors[1], likes: Int(arc4random_uniform(600)), comments: Int(arc4random_uniform(100)), bookmarked: false, image: "PostImage4"),
//            Post(title: "Что разрушило Селену Гомес: все началось еще в детстве", body: "Селена Гомес испытывает серьезные проблемы с ментальным здоровьем. А повлияло на это одно обстоятельство, с которым звезда столкнулась, будучи ребенком.\nПевица начала работать с малых лет. Пока ее сверстники посещали уроки в школе, она вовсю трудилась на съемочных площадках — снималась в проектах телеканала Disney. В свои семь лет будущая звезда не отставала от взрослых коллег: сидела наравне с ними в гримерках и преображалась для ролей. С маленькой девочкой работали профессиональные визажисты и парикмахеры, которые накладывали ей макияж и делали прически. Тогда юная актриса не видела в этом ничего плохого. Однако став взрослой, она поняла всю плачевность ситуации.\nОказалось, что именно те перевоплощения пошатнули восприятие девушки: она оказалась заложницей моды и бьюти-трендов. На протяжении долгих лет Селена Гомес не могла принять свою природную красоту. Для того, чтобы избавиться от этого, экс-возлюбленная Джастина Бибера работала с психологами и, к счастью, сумела побороть все свои комплексы.", author: authors[4], likes: Int(arc4random_uniform(600)), comments: Int(arc4random_uniform(100)), bookmarked: false, image: "PostImage5"),
//            Post(title: "Как Кейт Уинслет получила роль в «Титанике»", body: "С самого начала поиски исполнительницы на главную роль в фильме «Титаник» не заладились. Когда Джеймс Кэмерон писал сценарий, он представлял героиню с тонкой талией, хрупкую и утонченную, как Одри Хепберн. Он готов был даже пойти на компромисс с собой и просматривал Мадонну, но не сложилось.\nНеожиданно в беспокойную жизнь мэтра ворвалась британская актриса Кейт Уинслет, которая после прочтения сценария, настолько им вдохновилась, что стала забрасывать режиссера письмами с просьбой о прослушивании. Со временем к письмам добавились и звонки. После этого Кэмерон был вынужден сдаться и все-таки устроил просмотр, пишет «Комсомольская правда».", author: authors[2], likes: Int(arc4random_uniform(600)), comments: Int(arc4random_uniform(100)), bookmarked: false, image: "PostImage7"),
//            Post(title: "Половину акций Майкла Джексона захотели продать почти за миллиард долларов", body: "Представители американского певца Майкла Джексона могут продать 50 процентов его акций. Об этом сообщает TMZ.\nУ музыки Джексона может появиться новый совладелец, если между представителями исполнителя и Sony будет заключена сделка на сумму в размере около миллиарда долларов. На данный момент рассматривается возможность продажи половины акций певца примерно за 900 миллионов долларов (около 65,5 миллиарда рублей), включая записи и издательские права. При этом отмечается, что намерения продавать музыкальный каталог исполнителя полностью нет.\nРанее сообщалось, что 26-летний племянник Майкла Джексона Джаафар Джексон сыграет певца в байопике, посвященном его жизни.\nМайкл Джексон умер июне 2009 года из-за передозировки успокоительного препарата пропофола. Личный врач певца Конрад Мюррей, который выписал Джексону этот препарат, в ноябре 2011 года был приговорен к четырем годам тюрьмы.", author: authors[3], likes: Int(arc4random_uniform(600)), comments: Int(arc4random_uniform(100)), bookmarked: false, image: "PostImage8"),
//        ]
//    }
//
//}
