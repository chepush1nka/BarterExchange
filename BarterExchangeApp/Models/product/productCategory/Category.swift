//
//  Category.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 10.02.2024.
//

enum Category: Hashable, Codable {
    case clothingAndAccessories(type: ClothingAndAccessoriesType)
    case electronics(type: ElectronicsType)
    case booksAndMagazines(type: BooksAndMagazinesType)
    case sportsAndOutdoors(type: SportsAndOutdoorsType)
    case homeAndGarden(type: HomeAndGardenType)
    case healthAndBeauty(type: HealthAndBeautyType)
    case musicAndInstruments(type: MusicAndInstrumentsType)
    case collectiblesAndArt(type: CollectiblesAndArtType)
    case craftsAndDIY(type: CraftsAndDIYType)
    case babyAndKids(type: BabyAndKidsType)
    case petSupplies(type: PetSuppliesType)
    case vehiclesAndParts(type: VehiclesAndPartsType)

    func toString() -> String {
        switch self {
        case .clothingAndAccessories(type: _):
            "Одежда и аксессуары"
        case .electronics(type: _):
            "Электроника"
        case .booksAndMagazines(type: _):
            "Книги и журналы"
        case .sportsAndOutdoors(type: _):
            "Спорт и активный отдых"
        case .homeAndGarden(type: _):
            "Дом и сад"
        case .healthAndBeauty(type: _):
            "Красота и здоровье"
        case .musicAndInstruments(type: _):
            "Музыка и инструменты"
        case .collectiblesAndArt(type: _):
            "Искусство"
        case .craftsAndDIY(type: _):
            "Своими руками"
        case .babyAndKids(type: _):
            "Для детей"
        case .petSupplies(type: _):
            "Для животных"
        case .vehiclesAndParts(type: _):
            "Машины и запчасти"
        }
    }

    func toStringSubtypes() -> [String] {
        switch self {
        case let .clothingAndAccessories(type: subtype):
            subtype.allCasesString()
        case let .electronics(type: subtype):
            subtype.allCasesString()
        case let .booksAndMagazines(type: subtype):
            subtype.allCasesString()
        case let .sportsAndOutdoors(type: subtype):
            subtype.allCasesString()
        case let .homeAndGarden(type: subtype):
            subtype.allCasesString()
        case let .healthAndBeauty(type: subtype):
            subtype.allCasesString()
        case let .musicAndInstruments(type: subtype):
            subtype.allCasesString()
        case let .collectiblesAndArt(type: subtype):
            subtype.allCasesString()
        case let .craftsAndDIY(type: subtype):
            subtype.allCasesString()
        case let .babyAndKids(type: subtype):
            subtype.allCasesString()
        case let .petSupplies(type: subtype):
            subtype.allCasesString()
        case let .vehiclesAndParts(type: subtype):
            subtype.allCasesString()
        }
    }

    func toStringSubtype() -> String {
        switch self {
        case let .clothingAndAccessories(type: subtype):
            subtype.rawValue
        case let .electronics(type: subtype):
            subtype.rawValue
        case let .booksAndMagazines(type: subtype):
            subtype.rawValue
        case let .sportsAndOutdoors(type: subtype):
            subtype.rawValue
        case let .homeAndGarden(type: subtype):
            subtype.rawValue
        case let .healthAndBeauty(type: subtype):
            subtype.rawValue
        case let .musicAndInstruments(type: subtype):
            subtype.rawValue
        case let .collectiblesAndArt(type: subtype):
            subtype.rawValue
        case let .craftsAndDIY(type: subtype):
            subtype.rawValue
        case let .babyAndKids(type: subtype):
            subtype.rawValue
        case let .petSupplies(type: subtype):
            subtype.rawValue
        case let .vehiclesAndParts(type: subtype):
            subtype.rawValue
        }
    }

    static func getAllCases() -> [Category] {
        [
            .clothingAndAccessories(type: .bags),
            .electronics(type: .TVs),
            .booksAndMagazines(type: .comics),
            .sportsAndOutdoors(type: .bicycles),
            .homeAndGarden(type: .gardenTools),
            .healthAndBeauty(type: .haircare),
            .musicAndInstruments(type: .CDs),
            .collectiblesAndArt(type: .antiques),
            .craftsAndDIY(type: .craftTools),
            .babyAndKids(type: .strollers),
            .petSupplies(type: .care),
            .vehiclesAndParts(type: .bicycles)
        ]
    }

    static func getAllCasesString() -> [String] {
        [
            Category.clothingAndAccessories(type: .bags).toString(),
            Category.electronics(type: .TVs).toString(),
            Category.booksAndMagazines(type: .comics).toString(),
            Category.sportsAndOutdoors(type: .bicycles).toString(),
            Category.homeAndGarden(type: .gardenTools).toString(),
            Category.healthAndBeauty(type: .haircare).toString(),
            Category.musicAndInstruments(type: .CDs).toString(),
            Category.collectiblesAndArt(type: .antiques).toString(),
            Category.craftsAndDIY(type: .craftTools).toString(),
            Category.babyAndKids(type: .strollers).toString(),
            Category.petSupplies(type: .care).toString(),
            Category.vehiclesAndParts(type: .bicycles).toString()
        ]
    }

    static func mapToCategory(from type: String, with subtype: String) -> Category {
        switch type {
        case "Одежда и аксессуары":
            if let subtypeEnum = ClothingAndAccessoriesType(rawValue: subtype) {
                return .clothingAndAccessories(type: subtypeEnum)
            }
            return .clothingAndAccessories(type: .bags)
        case "Электроника":
            if let subtypeEnum = ElectronicsType(rawValue: subtype) {
                return .electronics(type: subtypeEnum)
            }
            return .electronics(type: .TVs)
        case "Книги и журналы":
            if let subtypeEnum = BooksAndMagazinesType(rawValue: subtype) {
                return .booksAndMagazines(type: subtypeEnum)
            }
            return .booksAndMagazines(type: .comics)
        case "Спорт и активный отдых":
            if let subtypeEnum = SportsAndOutdoorsType(rawValue: subtype) {
                return .sportsAndOutdoors(type: subtypeEnum)
            }
            return .sportsAndOutdoors(type: .bicycles)
        case "Дом и сад":
            if let subtypeEnum = HomeAndGardenType(rawValue: subtype) {
                return .homeAndGarden(type: subtypeEnum)
            }
            return .homeAndGarden(type: .furniture)
        case "Красота и здоровье":
            if let subtypeEnum = HealthAndBeautyType(rawValue: subtype) {
                return .healthAndBeauty(type: subtypeEnum)
            }
            return .healthAndBeauty(type: .haircare)
        case "Музыка и инструменты":
            if let subtypeEnum = MusicAndInstrumentsType(rawValue: subtype) {
                return .musicAndInstruments(type: subtypeEnum)
            }
            return .musicAndInstruments(type: .CDs)
        case "Искусство":
            if let subtypeEnum = CollectiblesAndArtType(rawValue: subtype) {
                return .collectiblesAndArt(type: subtypeEnum)
            }
            return .collectiblesAndArt(type: .antiques)
        case "Своими руками":
            if let subtypeEnum = CraftsAndDIYType(rawValue: subtype) {
                return .craftsAndDIY(type: subtypeEnum)
            }
            return .craftsAndDIY(type: .craftTools)
        case "Для детей":
            if let subtypeEnum = BabyAndKidsType(rawValue: subtype) {
                return .babyAndKids(type: subtypeEnum)
            }
            return .babyAndKids(type: .books)
        case "Для животных":
            if let subtypeEnum = PetSuppliesType(rawValue: subtype) {
                return .petSupplies(type: subtypeEnum)
            }
            return .petSupplies(type: .accessories)
        case "Машины и запчасти":
            if let subtypeEnum = VehiclesAndPartsType(rawValue: subtype) {
                return .vehiclesAndParts(type: subtypeEnum)
            }
            return .vehiclesAndParts(type: .bicycles)
        default:
            return .homeAndGarden(type: .homeDecor)
        }
        return .homeAndGarden(type: .homeDecor)
    }
}
