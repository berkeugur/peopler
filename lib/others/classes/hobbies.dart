enum HobbyTypes {
  archery,
  camping,
  carpentry,
  chef,
  chess,
  cinema,
  collections,
  dancing,
  eSports,
  fishing,
  fitness,
  gardener,
  makePicture,
  martialArts,
  origami,
  playInstruments,
  readingBook,
  rideHorse,
  swimming,
  takePhoto,
  theater,
  travel,
  volunteerWork,
  walking,
  watchingMovie,
  writing,
  yoga
}

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
      case "Meditasyon Yapmak":
        return "yoga";
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

      case "Yürüyüş Yapmak":
        return HobbyTypes.walking;

      case "Film/Dizi İzlemek":
        return HobbyTypes.watchingMovie;

      case "Yazı Yazmak":
        return HobbyTypes.writing;

      case "Meditasyon Yapmak":
        return HobbyTypes.yoga;
      default:
        return HobbyTypes.yoga;
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

      case HobbyTypes.walking:
        return "Yürüyüş Yapmak";

      case HobbyTypes.watchingMovie:
        return "Film/Dizi İzlemek";

      case HobbyTypes.writing:
        return "Yazı Yazmak";

      case HobbyTypes.yoga:
        return "Meditasyon Yapmak";
    }
  }

  List<String>? subHobby(HobbyTypes types) {
    switch (types) {
      case HobbyTypes.archery:
        return null;

      case HobbyTypes.camping:
        return null;

      case HobbyTypes.carpentry:
        return null;

      case HobbyTypes.chef:
        return [
          "Amerikan Mutfağı",
          "Çin Mutfağı",
          "Fas Mutfağı",
          "Fransız Mutfağı",
          "Hint Mutfağı",
          "İtalyan Mutfağı",
          "Japon Mutfağı",
          "Kore Mutfağı",
          "Lübnan Mutfağı",
          "Meksika Mutfağı",
          "Osmanlı Mutfağı",
          "Türk Mutfağı",
          "Uzakdoğu Mutfağı",
          "Yunan Mutfağı"
        ];

      case HobbyTypes.chess:
        return ["Başlangıç Seviyesi", "Orta Seviye", "İleri Seviye"];

      case HobbyTypes.cinema:
        return [
          "Aksiyon",
          "Komedi",
          "Belgesel",
          "Bilim Kurgu",
          "Dini",
          "Dramatik",
          "Eğitim",
          "Erotik",
          "Fantastik",
          "Gerilim",
          "Korku",
          "Macera",
          "Savaş",
          "Spor",
          "Suç",
          "Tarih",
          "Yaşam Öyküsü"
        ];

      case HobbyTypes.collections:
        return ["Pul", "Madeni Para", "Çizgi Roman", "Anı", "Kartpostal", "Gazoz Kapağı", "Rozet", "Antika"];

      case HobbyTypes.dancing:
        return [
          "Rock",
          "Broadway",
          "Bale",
          "Ça-ça",
          "Disko",
          "Foxtrot",
          "Salsa",
          "Breakdance",
          "Türk halk oyunları",
          "Hip Hop",
          "Jazz",
          "Jive",
          "Tango",
          "Zeybek",
          "Roman"
        ];

      case HobbyTypes.eSports:
        return ["CS:GO", "League of Legends", "Dota 2", "PUBG", "Fortnite"];

      case HobbyTypes.fishing:
        return ["Kıyı balıkçılığı", "Tekne Balıkçılığı", "Kano Balıkçılığı", "Sazan Avı", "Buz Balıkçılığı"];

      case HobbyTypes.fitness:
        return ["Amatör", "Profesyonel"];

      case HobbyTypes.gardener:
        return null;

      case HobbyTypes.makePicture:
        return null;

      case HobbyTypes.martialArts:
        return null;

      case HobbyTypes.origami:
        return null;

      case HobbyTypes.playInstruments:
        return null;

      case HobbyTypes.readingBook:
        return null;

      case HobbyTypes.rideHorse:
        return null;

      case HobbyTypes.swimming:
        return null;

      case HobbyTypes.takePhoto:
        return null;

      case HobbyTypes.theater:
        return null;

      case HobbyTypes.travel:
        return null;

      case HobbyTypes.volunteerWork:
        return null;

      case HobbyTypes.walking:
        return null;

      case HobbyTypes.watchingMovie:
        return null;

      case HobbyTypes.writing:
        return null;

      case HobbyTypes.yoga:
        return null;
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
      Hobby().name(HobbyTypes.walking),
      Hobby().name(HobbyTypes.watchingMovie),
      Hobby().name(HobbyTypes.writing),
      Hobby().name(HobbyTypes.yoga),
    ];
  }
}
