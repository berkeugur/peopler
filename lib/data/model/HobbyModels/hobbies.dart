import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/core/constants/enums/hobby_types_enum.dart';
import 'package:peopler/data/model/HobbyModels/hobbymodel.dart';

class Hobby {
  stringToHobbyTypes(String? text) {
    switch (text) {
      case "Okçuluk":
        return "archery";
      case "Kamp Yapmak":
        return "camping";
      case "Marangozluk":
        return "carpentry";
      case "Yemek Yapmak":
        return "chef";
      case "Santraç Oynamak":
        return "chess";
      case "Sinemaya Gitmek":
        return "cinema";
      case "Koleksiyon Yapmak":
        return "collections";
      case "Dans Etmek":
        return "dancing";
      case "E-Spor":
        return "eSports";
      case "Balık Tutmak":
        return "fishing";
      case "Vücut Geliştirme":
        return "fitness";
      case "Bahçıvanlık":
        return "gardener";
      case "Resim Yapmak":
        return "makePicture";
      case "Savunma Sanatları":
        return "martialArts";
      case "Origami":
        return "origami";
      case "Enstrüman Çalmak":
        return "playInstrument";
      case "Kitap Okumak":
        return "readingBook";
      case "At Binmek":
        return "rideHorse";
      case "Yüzmek":
        return "swimming";
      case "Fotoğraf Çekmek":
        return "takePhoto";
      case "Tiyatroya Gitmek":
        return "theater";
      case "Seyehat Etmek":
        return "travel";
      case "Gönüllü Çalışmalarda Bulunmak":
        return "volunteerWork";
      case "Yürüyüş Yapmak":
        return "walking";
      case "Film/Dizi İzlemek":
        return "watchingMovie";
      case "Yazı Yazmak":
        return "writing";

      default:
        return "yoga";
    }
  }

  HobbyTypes stringToHobbyTypesModel(String types) {
    switch (types) {
      case "Okçuluk":
        return HobbyTypes.archery;

      case "Kamp Yapmak":
        return HobbyTypes.camping;

      case "Marangozluk":
        return HobbyTypes.carpentry;

      case "Yemek Yapmak":
        return HobbyTypes.chef;

      case "Santraç Oynamak":
        return HobbyTypes.chess;

      case "Sinemaya Gitmek":
        return HobbyTypes.cinema;

      case "Koleksiyon Yapmak":
        return HobbyTypes.collections;

      case "Dans Etmek":
        return HobbyTypes.dancing;

      case "E-Spor":
        return HobbyTypes.eSports;

      case "Balık Tutmak":
        return HobbyTypes.fishing;

      case "Vücut Geliştirme":
        return HobbyTypes.fitness;

      case "Bahçıvanlık":
        return HobbyTypes.gardener;

      case "Resim Yapmak":
        return HobbyTypes.makePicture;

      case "Savunma Sanatları":
        return HobbyTypes.martialArts;

      case "Origami":
        return HobbyTypes.origami;

      case "Enstrüman Çalmak":
        return HobbyTypes.playInstruments;

      case "Kitap Okumak":
        return HobbyTypes.readingBook;

      case "At Binmek":
        return HobbyTypes.rideHorse;

      case "Yüzmek":
        return HobbyTypes.swimming;

      case "Fotoğraf Çekmek":
        return HobbyTypes.takePhoto;

      case "Tiyatroya Gitmek":
        return HobbyTypes.theater;

      case "Seyehat Etmek":
        return HobbyTypes.travel;

      case "Gönüllü Çalışmalarda Bulunmak":
        return HobbyTypes.volunteerWork;

      case "Yazı Yazmak":
        return HobbyTypes.writing;

      default:
        return HobbyTypes.writing;
    }
  }

  String name(HobbyTypes types) {
    switch (types) {
      case HobbyTypes.archery:
        return "Okçuluk";

      case HobbyTypes.camping:
        return "Kamp Yapmak";

      case HobbyTypes.carpentry:
        return "Marangozluk";

      case HobbyTypes.chef:
        return "Yemek Yapmak";

      case HobbyTypes.chess:
        return "Santraç Oynamak";

      case HobbyTypes.cinema:
        return "Sinemaya Gitmek";

      case HobbyTypes.collections:
        return "Koleksiyon Yapmak";

      case HobbyTypes.dancing:
        return "Dans Etmek";

      case HobbyTypes.eSports:
        return "E-Spor";

      case HobbyTypes.fishing:
        return "Balık Tutmak";

      case HobbyTypes.fitness:
        return "Vücut Geliştirme";

      case HobbyTypes.gardener:
        return "Bahçıvanlık";

      case HobbyTypes.makePicture:
        return "Resim Yapmak";

      case HobbyTypes.martialArts:
        return "Savunma Sanatları";

      case HobbyTypes.origami:
        return "Origami";

      case HobbyTypes.playInstruments:
        return "Enstrüman Çalmak";

      case HobbyTypes.readingBook:
        return "Kitap Okumak";

      case HobbyTypes.rideHorse:
        return "At Binmek";

      case HobbyTypes.swimming:
        return "Yüzmek";

      case HobbyTypes.takePhoto:
        return "Fotoğraf Çekmek";

      case HobbyTypes.theater:
        return "Tiyatroya Gitmek";

      case HobbyTypes.travel:
        return "Seyehat Etmek";

      case HobbyTypes.volunteerWork:
        return "Gönüllü Çalışmalarda Bulunmak";

      case HobbyTypes.writing:
        return "Yazı Yazmak";
    }
  }

  bool isHobbyHas(String selectedHobbyName) {
    int counter = 0;
    List.generate(UserBloc.user!.hobbies.length, (index) {
      HobbyModel hobbyItem = HobbyModel.fromJson(UserBloc.user!.hobbies[index]);
      hobbyItem.title == selectedHobbyName ? counter++ : null;
    });
    if (counter == 0) {
      return false;
    } else {
      return true;
    }
  }

  List<String>? subHobby(HobbyTypes types) {
    switch (types) {
      case HobbyTypes.archery:
        return [
          "Modern Okçuluk",
          "Geleneksel Okçuluk",
        ];

      case HobbyTypes.camping:
        return [
          "Araba Kampı",
          "Vahşi Doğa Kampı",
          "Kış Kampı",
        ];

      case HobbyTypes.carpentry:
        return [
          "İleri Düzey",
          "Orta Düzey",
          "Başlangıç Aşaması",
        ];

      case HobbyTypes.chef:
        return [
          "Dünya Mutfakları",
          "Eğlenceli Tarifler",
          "Sporcu Tarifleri",
        ];

      case HobbyTypes.chess:
        return [
          "İleri Düzey",
          "Orta Düzey",
          "Başlangıç Aşaması",
        ];

      case HobbyTypes.cinema:
        return [
          "Aksiyon Filmleri",
          "Anime Filmler",
          "Sanat Filmleri",
          "Belgeseller",
          "Bilim Kurgu Filmleri",
          "Çocuk ve Aile",
          "Dramalar",
          "Fantastik Kurgular",
          "Gerilim Filmleri",
          "Kısa Filmler",
          "Klasikler",
          "Komediler",
          "Korku Filmleri",
          "Müzikaller",
          "Romantizm",
          "Yerli Filmler",
          "Biyografi",
        ];

      case HobbyTypes.collections:
        return [
          "Pullar",
          "Madeni Paralar",
          "Anı",
          "Oyunlar",
          "Kitaplar",
          "Deniz Kabukları",
          "DVD'ler",
          "Peçeteler",
          "Kartpostallar",
          "Kapaklar",
          "Rozet",
          "Antika",
        ];

      case HobbyTypes.dancing:
        return [
          "Bale",
          "Salsa",
          "Breakdance",
          "Modern Dans",
          "Kalipso",
          "Samba",
          "Tango",
          "Vals",
          "Zumba",
          "Zeybek",
        ];

      case HobbyTypes.eSports:
        return [
          "CS:GO",
          "League of Legends",
          "Dota 2",
          "PUBG",
          "Fortnite",
          "Overwatch",
          "Call of Duty",
          "Hearthstone",
          "PES",
          "FIFA",
        ];

      case HobbyTypes.fishing:
        return [
          "Olta",
          "Zıpkın",
          "Ağ",
        ];

      case HobbyTypes.fitness:
        return [
          "Power Lifting",
          "Body Building",
          "Cross Fit",
          "Profesyonel",
        ];

      case HobbyTypes.gardener:
        return [
          "İleri Seviye",
          "Orta Seviye",
          "Başlangıç Aşaması",
        ];

      case HobbyTypes.makePicture:
        return [
          "Portre Resim",
          "Figür Resim",
          "Nü Resim",
          "Perspektif",
          "Pastoral",
          "Grafiti",
        ];

      case HobbyTypes.martialArts:
        return [
          "Karete",
          "Tekvando",
          "Judo",
          "Aikido",
          "Jujutsu",
        ];

      case HobbyTypes.origami:
        return [
          "Parçalı Origami",
          "Klasik Origami",
        ];

      case HobbyTypes.playInstruments:
        return [
          "Keman",
          "Bateri",
          "Piyano",
          "Ney",
          "Gitar",
          "Saz",
        ];

      case HobbyTypes.readingBook:
        return [
          "Kişisel Gelişim",
          "Bilim Kurgu",
          "Fantastik Kurgu",
          "Hikaye",
          "Roman",
          "Şiir",
          "Biyografi",
          "Tarih",
          "Felsefe",
          "Mitoloji",
        ];

      case HobbyTypes.rideHorse:
        return [
          "İleri Seviye",
          "Orta Seviye",
          "Başlangıç Aşaması",
        ];

      case HobbyTypes.swimming:
        return [
          "İleri Seviye",
          "Orta Seviye",
          "Başlangıç Aşaması",
        ];

      case HobbyTypes.takePhoto:
        return [
          "İleri Seviye",
          "Orta Seviye",
          "Başlangıç Aşaması",
        ];

      case HobbyTypes.theater:
        return [
          "Trajedi",
          "Komedi",
          "Drama",
          "Opera",
          "Pandomim",
          "Müzikal",
        ];

      case HobbyTypes.travel:
        return null;

      case HobbyTypes.volunteerWork:
        return null;

      case HobbyTypes.writing:
        return [
          "İleri Seviye",
          "Orta Seviye",
          "Başlangıç Aşaması",
        ];
    }
  }

  ///return yoga, writing, playInstruments uzantısını kendin eklemelisin.
  String photo(HobbyTypes types) {
    return types.toString().replaceAll("HobbyTypes.", "");
  }

  List<String> hobbiesNameList() {
    return [
      Hobby().name(HobbyTypes.archery),
      Hobby().name(HobbyTypes.camping),
      Hobby().name(HobbyTypes.carpentry),
      Hobby().name(HobbyTypes.chef),
      Hobby().name(HobbyTypes.chess),
      Hobby().name(HobbyTypes.cinema),
      Hobby().name(HobbyTypes.collections),
      Hobby().name(HobbyTypes.dancing),
      Hobby().name(HobbyTypes.eSports),
      Hobby().name(HobbyTypes.fishing),
      Hobby().name(HobbyTypes.fitness),
      Hobby().name(HobbyTypes.gardener),
      Hobby().name(HobbyTypes.makePicture),
      Hobby().name(HobbyTypes.martialArts),
      Hobby().name(HobbyTypes.origami),
      Hobby().name(HobbyTypes.playInstruments),
      Hobby().name(HobbyTypes.readingBook),
      Hobby().name(HobbyTypes.rideHorse),
      Hobby().name(HobbyTypes.swimming),
      Hobby().name(HobbyTypes.takePhoto),
      Hobby().name(HobbyTypes.theater),
      Hobby().name(HobbyTypes.travel),
      Hobby().name(HobbyTypes.volunteerWork),
      Hobby().name(HobbyTypes.writing),
    ];
  }
}
