// lib/manager/hotel_manager.dart

class Hotel {
  String name;
  String city;
  int rating; // 4 atau 5
  String description;
  String address;
  String price;
  String imageAsset;
  List<String> imageUrls;

  Hotel({
    required this.name,
    required this.city,
    required this.rating,
    required this.description,
    required this.address,
    required this.price,
    required this.imageAsset,
    required this.imageUrls,
  });
}

// ==========================================
//  FUNGSI PENTING YANG DITAMBAHKAN
// ==========================================
List<Hotel> getAllHotels() {
  return [...worldHotelList, ...indonesiaHotels];
}

// ======================
// DATA HOTEL
// ======================

var worldHotelList = [
  Hotel(
    name: 'Burj Al Arab',
    city: 'Dubai',
    rating: 5,
    description: 'Hotel mewah ikonik berbentuk layar di Dubai.',
    address: 'Jumeirah St, Dubai, UAE',
    price: 'Rp 25.000.000 / malam',
    imageAsset: 'images/burj.jpg',
    imageUrls: [
      'https://cdn.britannica.com/68/250068-050-B0AD857A/Burj-Al-Arab-luxury-hotel-Dubai.jpg',
      'https://media.admiddleeast.com/photos/674caab1f5753e365580cdd9/16:9/w_2560%2Cc_limit/GettyImages-1246467538.jpg',
      'https://media.architecturaldigest.com/photos/56cf05a762d56bfa39d876a3/master/pass/burj-al-arab-jumeirah-dubai.jpg',
    ],
  ),
  Hotel(
    name: 'The St. Regis Bali Resort',
    city: 'Bali',
    rating: 5,
    description:
        'Resort mewah dengan layanan kelas dunia, pantai pribadi, dan pengalaman kuliner premium.',
    address: 'Kawasan Pariwisata Nusa Dua, Bali',
    price: 'Rp 6.500.000 / malam',
    imageAsset: 'images/st-regis-bali.jpg',
    imageUrls: [
      'https://cdn.1001malam.com/uploads/hotels/stregisbaliresort_swimmingpool_1153925.jpg',
      'https://www.theluxevoyager.com/wp-content/uploads/2018/02/St-Regis-Bali-600x450.jpg',
    ],
  ),
  Hotel(
    name: 'The Westin Resort Nusa Dua',
    city: 'Bali',
    rating: 5,
    description:
        'Hotel bintang lima yang terkenal dengan suasana santai dan fasilitas lengkap untuk keluarga.',
    address: 'ITDC Nusa Dua, Bali',
    price: 'Rp 4.200.000 / malam',
    imageAsset: 'images/westin-nusa-dua.jpg',
    imageUrls: [
      'https://pbs.twimg.com/media/FGpT1zaVEAEkY7v.jpg',
      'https://www.lantaikayu.biz/wp-content/uploads/2022/09/westin-resort-nusa-dua.jpg',
    ],
  ),
  Hotel(
    name: 'Padma Resort Legian',
    city: 'Bali',
    rating: 5,
    description:
        'Resor pinggir pantai dengan kolam renang luas dan fasilitas mewah di pusat Legian.',
    address: 'Jl. Padma No.1, Legian, Bali',
    price: 'Rp 3.800.000 / malam',
    imageAsset: 'images/padma-legian.jpg',
    imageUrls: [
      'https://y.cdrst.com/foto/hotel-sf/56f7/granderesp/padma-resort-legian-servicios-124a8159.jpg',
      'https://indonesiaimpressiontour.com/wp-content/uploads/2020/02/Padma-Resort-Legian-02.jpg',
    ],
  ),
  Hotel(
    name: 'Four Seasons Hotel George V, Paris',
    city: 'Paris',
    rating: 5,
    description:
        'Hotel paling ikonik di dunia dengan Pemandangan menara elift.',
    address: 'Four Seasons Hotel George V, Paris',
    price: 'Rp 25.000.000 / malam',
    imageAsset: 'images/Four-Seasons-Hotel-George-V.jpg',
    imageUrls: [
      'https://static.prod.r53.tablethotels.com/media/hotels/slideshow_images_staged/large/1254184.jpg',
      'https://media.cntraveller.com/photos/61b9d4e012c2490bd42fed18/4:3/w_3256,h_2442,c_limit/Eiffel-Tower-Suite-146-four%20seasons%20george-nov21--pr.jpeg',
    ],
  ),
  Hotel(
    name: 'The Venetian Resort',
    city: 'Las Vegas',
    rating: 5,
    description:
        'Resort mewah bertema Venesia dengan kanal buatan dan pusat hiburan terbesar.',
    address: '3355 S Las Vegas Blvd, Las Vegas',
    price: 'Rp 7.800.000 / malam',
    imageAsset: 'images/venetian-las-vegas.jpg',
    imageUrls: [
      'https://www.watg.com/wp-content/uploads/1998/01/AdobeStock_370110257_Editorial_Use_Only-scaled.jpeg',
      'https://www.hotel-scoop.com/wp-content/uploads/2022/07/VenetianLVGondolaOutside640x480.jpg',
    ],
  ),
  Hotel(
    name: 'Park Hyatt Shanghai',
    city: 'Shanghai',
    rating: 5,
    description:
        'Hotel tertinggi di dunia dengan pemandangan kota Shanghai dari ketinggian.',
    address: '100 Century Ave, Shanghai',
    price: 'Rp 9.500.000 / malam',
    imageAsset: 'images/park-hyatt-shanghai.jpg',
    imageUrls: [
      'https://thegoodlife.fr/wp-content/uploads/sites/2/2016/12/tgl-p-hs-shangai-132-c-01.jpg',
      'https://www.theluxevoyager.com/wp-content/uploads/2019/06/Park-hyatt-shanghai-exterior-971x546.jpg',
    ],
  ),
  Hotel(
    name: 'Hotel Adlon Kempinski',
    city: 'Berlin',
    rating: 5,
    description:
        'Hotel legendaris di depan Brandenburg Gate dengan sejarah panjang dan layanan terbaik.',
    address: 'Unter den Linden 77, Berlin',
    price: 'Rp 8.200.000 / malam',
    imageAsset: 'images/adlon-kempinski.jpg',
    imageUrls: [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSRQ78J9iB6djjJ2RHCFcEjMfIOKSDVtPryQ&s',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Hotel_Adlon_%28Berlin%29.jpg/330px-Hotel_Adlon_%28Berlin%29.jpg',
    ],
  ),
  Hotel(
    name: 'The Peninsula Tokyo',
    city: 'Tokyo',
    rating: 5,
    description:
        'Hotel megah di pusat Tokyo dengan layanan kelas dunia dan interior modern elegan.',
    address: '1-8-1 Yurakucho, Tokyo',
    price: 'Rp 10.000.000 / malam',
    imageAsset: 'images/peninsula-tokyo.jpg',
    imageUrls: [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT3uskFJV6cQ8zphvEYPRM5Bfz-oXC9IZBbmQ&s',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFM2x86oJ1ddGt7og2zTT0qq3O56XVWXQizQ&s',
    ],
  ),
  Hotel(
    name: 'Marina Bay Sands',
    city: 'Singapore',
    rating: 5,
    description: 'Hotel ikonik dengan infinity pool terbesar di dunia.',
    address: '10 Bayfront Avenue, Singapore',
    price: 'Rp 18.000.000 / malam',
    imageAsset: 'images/marinabay.jpg',
    imageUrls: [
      'https://www.visitsingapore.com/content/dam/desktop/global/see-do-singapore/recreation-leisure/marina-bay-sands-carousel01-rect.jpg',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQz8uO1iqyBF244_qIA8Q8-9qwRkJvxLN5Zw&s',
    ],
  ),
  Hotel(
    name: 'The Plaza Hotel',
    city: 'New York',
    rating: 5,
    description: 'Hotel legendaris di Manhattan dengan desain klasik mewah.',
    address: '768 5th Ave, New York, USA',
    price: 'Rp 22.000.000 / malam',
    imageAsset: 'images/plaza.jpg',
    imageUrls: [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShv6lJtLcIf2LOMrk6rgY1SN_CJBb1IowpAg&s',
      'https://m.ahstatic.com/is/image/accorhotels/aja_p_6011-61:4by3?fmt=jpg&op_usm=1.75,0.3,2,0&resMode=sharp2&iccEmbed=true&icc=sRGB&dpr=on,1.5&wid=335&hei=251&qlt=80',
    ],
  ),
  Hotel(
    name: 'The Ritz London',
    city: 'London',
    rating: 5,
    description: 'Hotel klasik bergaya aristokrat di jantung kota London.',
    address: '150 Piccadilly, London',
    price: 'Rp 20.000.000 / malam',
    imageAsset: 'images/ritz-london.jpg',
    imageUrls: [
      'https://media.architecturaldigest.com/photos/55e796eb302ba71f3018054d/16:9/w_1280,c_limit/dam-images-homes-2002-05-ritz-hoar01_ritz.jpg',
      'https://images.trvl-media.com/lodging/1000000/30000/28200/28146/ba763306.jpg?impolicy=resizecrop&rw=575&rh=575&ra=fill',
    ],
  ),
  Hotel(
    name: 'Four Seasons Hotel Sydney',
    city: 'Sydney',
    rating: 5,
    description: 'Hotel premium dengan pemandangan Opera House.',
    address: '199 George St, Sydney',
    price: 'Rp 16.000.000 / malam',
    imageAsset: 'images/fourseasonssydney.jpg',
    imageUrls: [
      'https://cf.bstatic.com/xdata/images/hotel/max1024x768/227683814.jpg?k=6ea4df5cd0684bf3aa89b0052873caf0bf47e98492fdd91d9e399c7d9121d135&o=',
      'https://static.toiimg.com/thumb/53868289/Four-Seasons-Hotel-1.jpg?width=1200&height=900',
    ],
  ),
  Hotel(
    name: 'Atlantis The Palm',
    city: 'Dubai',
    rating: 5,
    description: 'Resor mewah dengan taman laut dan waterpark raksasa.',
    address: 'Palm Jumeirah, Dubai',
    price: 'Rp 19.000.000 / malam',
    imageAsset: 'images/atlantis.jpg',
    imageUrls: [
      'https://images.trvl-media.com/lodging/3000000/2240000/2235400/2235336/c53f8609.jpg?impolicy=resizecrop&rw=575&rh=575&ra=fill',
      'https://www.watg.com/wp-content/uploads/2008/06/034063_N10_highres-scaled.jpg',
    ],
  ),
  Hotel(
    name: "The Savoy Hotel",
    city: "London",
    rating: 5,
    description: "Hotel legendaris di London dengan layanan kelas dunia.",
    address: "Strand, London WC2R 0EZ, United Kingdom",
    price: "Rp 9.000.000 / malam",
    imageAsset: "assets/images/savoy.jpg",
    imageUrls: [
      "https://www.ahstatic.com/photos/a597_ho_00_p_1024x768.jpg",
      "https://s1.it.atcdn.net/wp-content/uploads/2015/12/HERO_TheSavoy-800x600.jpg",
    ],
  ),
  Hotel(
    name: "Mandarin Oriental Bangkok",
    city: "Bangkok",
    rating: 5,
    description:
        "Salah satu hotel terbaik di Asia dengan standar pelayanan premium.",
    address: "48 Oriental Ave, Bang Rak, Bangkok, Thailand",
    price: "Rp 8.500.000 / malam",
    imageAsset: "assets/images/mandarinbkk.jpg",
    imageUrls: [
      "https://upload.wikimedia.org/wikipedia/commons/e/e5/Mandarin_Oriental_Bangkok_Bang_Rak.jpg",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQK0gQ9rNAXMk8-w4aCGKUQvKQxR5CXXZIpRw&s",
    ],
  ),
  Hotel(
    name: "Bulgari Resort Dubai",
    city: "Dubai",
    rating: 5,
    description:
        "Resor megah dengan desain mewah khas Bulgari di pulau buatan.",
    address: "Jumeirah Bay Island, Dubai, UAE",
    price: "Rp 15.000.000 / malam",
    imageAsset: "assets/images/bulgaridubai.jpg",
    imageUrls: [
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSq-cf8J4s3-tr1DACjCzVEyE_4qQmhdXM0lg&s",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhpE_brDKrm4C4AA-z07hVyFI57hh-HKU0KA&s",
    ],
  ),
];

var indonesiaHotels = [
  Hotel(
    name: 'Hotel Indonesia Kempinski',
    city: 'Jakarta',
    rating: 5,
    description: 'Hotel mewah legendaris di pusat Jakarta.',
    address: 'MH Thamrin No.1, Jakarta Pusat',
    price: 'Rp 3.500.000 / malam',
    imageAsset: 'images/kempinski.jpg',
    imageUrls: [
      'https://pix10.agoda.net/hotelImages/148721/0/c567695f6535e403b4418b4a161cc5fa.png?ce=2&s=414x232',
      'https://images.trvl-media.com/lodging/2000000/1950000/1942700/1942665/cbf30868.jpg?impolicy=resizecrop&rw=575&rh=575&ra=fill',
    ],
  ),
  Hotel(
    name: 'The Ritz-Carlton Jakarta',
    city: 'Jakarta',
    rating: 5,
    description: 'Hotel mewah dengan fasilitas kelas dunia.',
    address: 'Mega Kuningan, Jakarta Selatan',
    price: 'Rp 4.200.000 / malam',
    imageAsset: 'images/ritz-jakarta.jpg',
    imageUrls: [
      'https://cache.marriott.com/is/image/marriotts7prod/rz-jktrt-exterior-4009-36279:Wide-Hor?wid=1336&fit=constrain',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ef/Ritz_Carlton_Pacific_Place_%28Nov_2024%29.jpg/330px-Ritz_Carlton_Pacific_Place_%28Nov_2024%29.jpg',
    ],
  ),
  Hotel(
    name: 'Shangri-La Jakarta',
    city: 'Jakarta',
    rating: 5,
    description: 'Hotel bisnis mewah dengan pelayanan premium.',
    address: 'Kota BNI, Jakarta Pusat',
    price: 'Rp 3.200.000 / malam',
    imageAsset: 'images/shangrila.jpg',
    imageUrls: [
      'https://cf.bstatic.com/xdata/images/hotel/max1024x768/190617708.jpg?k=5c157dccda7e967505e0ca98dce7f6b7bf5b71fdcbab028d2e6f6bac953c3114&o=',
      'https://sitecore-cd-imgr.shangri-la.com/MediaFiles/F/E/4/%7BFE45156C-55B0-458F-A2CD-3DF17C2FA746%7D220630_SLJ_Banner_Awards.jpg?width=630&height=480&mode=crop&quality=100&scale=both',
    ],
  ),
  Hotel(
    name: 'Grand Hyatt Jakarta',
    city: 'Jakarta',
    rating: 5,
    description:
        'Hotel bintang 5 dengan akses langsung ke pusat perbelanjaan elite.',
    address: 'MH Thamrin, Jakarta Pusat',
    price: 'Rp 3.800.000 / malam',
    imageAsset: 'images/grandhyatt.jpg',
    imageUrls: [
      'https://assets.hyatt.com/content/dam/hyatt/hyattdam/images/2025/03/17/0501/JAKGH-P1330-Building-Exterior-Sky.jpg/JAKGH-P1330-Building-Exterior-Sky.4x3.jpg',
      'https://q-xx.bstatic.com/xdata/images/hotel/max500/506520061.jpg?k=bc02d361ad836651bd42927019d15d1517f423231bbd63d6fc6a5db35a206ea0&o=',
    ],
  ),
  Hotel(
    name: 'The Trans Luxury Hotel',
    city: 'Bandung',
    rating: 5,
    description: 'Hotel mewah dengan waterpark indoor.',
    address: 'Gatot Subroto, Bandung',
    price: 'Rp 2.700.000 / malam',
    imageAsset: 'images/transluxury.jpg',
    imageUrls: [
      'https://tourism.bandung.go.id/assets/admin/img/cover/thetrans.jpg',
      'https://images.trvl-media.com/lodging/6000000/5130000/5126900/5126834/0a42e18c.jpg?impolicy=resizecrop&rw=575&rh=575&ra=fill',
    ],
  ),
  Hotel(
    name: "Hilton Bandung",
    city: 'Bandung',
    rating: 5,
    description: 'Hotel modern dekat Stasiun Bandung.',
    address: 'Jl. HOS Tjokroaminoto, Bandung',
    price: 'Rp 1.800.000 / malam',
    imageAsset: 'images/hiltonbdg.jpg',
    imageUrls: [
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-mobile/tix-hotel/images-web/2023/02/16/9e7e49fa-5f4e-4631-b2ee-f45c69ce1e73-1676509766655-9dfa11dd843291e2bfaefc9a7c51f1c3.jpg',
      'https://liandamarta.com/wp-content/uploads/2012/07/img_7162.jpg',
    ],
  ),
  Hotel(
    name: 'Padma Hotel Bandung',
    city: 'Bandung',
    rating: 5,
    description: 'Hotel view lembah yang menenangkan.',
    address: 'Ciumbuleuit, Bandung',
    price: 'Rp 2.500.000 / malam',
    imageAsset: 'images/padma.jpg',
    imageUrls: [
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-dskt/tix-hotel/images-web/2025/01/22/c5c0a58a-bd66-4556-a5a8-a62030c5725b-1737543304047-895e761104e6615236513295b67a456a.jpg',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfxaQT5bbEEAz5Gb5062riyG4Anc8sCTwnmg&s',
    ],
  ),
  Hotel(
    name: 'InterContinental Bandung Dago Pakar',
    city: 'Bandung',
    rating: 5,
    description: 'Hotel elegan dengan pemandangan pegunungan.',
    address: 'Dago Pakar, Bandung',
    price: 'Rp 2.900.000 / malam',
    imageAsset: 'images/interconti.jpg',
    imageUrls: [
      'https://cdn-63f9c0f2c1ac18d2aca8934b.closte.com/wp-content/uploads/2023/04/photo-intro.jpg',
      'https://q-xx.bstatic.com/xdata/images/hotel/max500/183597766.jpg?k=97d786067926a9e94034b131ac90f387be3aa33edc4c7029faac2e48e01e0ba9&o=',
    ],
  ),
  Hotel(
    name: "Novotel Bandung",
    city: "Bandung",
    rating: 4,
    description:
        "Hotel ikonik Bandung dengan layanan baik dan dekat dengan kota bandung",
    address:
        "Jl. Cihampelas No.23 25, Pasir Kaliki, Kec. Cicendo, Kota Bandung",
    price: "Rp 580.000 / malam",
    imageAsset: "assets/images/Novotel_Bandung.jpg",
    imageUrls: [
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-mobile/tix-hotel/images-web/2024/07/31/e8fc3854-5b27-433d-9bef-5a00c6a9037e-1722419123479-959d149e2f7ae9fb5419a15a3e0dece8.jpg',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpQyLo0ZJFPkwp5SmcMsUmX-0RFaC_mqL_0g&s',
    ],
  ),
  Hotel(
    name: "Hotel Savoy Homann Bandung",
    city: "Bandung",
    rating: 5,
    description: "Hotel modern klasik dan fasilitas bisnis terbaik.",
    address: "Jl. Asia Afrika No.112, Cikawao, Kec. Lengkong, Kota Bandung",
    price: "Rp 970.000 / malam",
    imageAsset: "assets/images/Hotel_Savoy_Homann.jpg",
    imageUrls: [
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-dskt/tix-hotel/images-web/2021/01/18/5cf48e2c-3319-4a26-b5c7-c494301e2106-1610946339759-fdcf02961a2a95da4111099361dafec9.jpg',
      'https://pix10.agoda.net/property/49768/0/cd7b45aba3d2ee2df0ade28bdbc92e6b.jpeg?ce=0&s=414x232',
    ],
  ),
  Hotel(
    name: 'JW Marriott Surabaya',
    city: 'Surabaya',
    rating: 5,
    description: 'Hotel megah dengan layanan premium.',
    address: 'Embong Malang, Surabaya',
    price: 'Rp 2.300.000 / malam',
    imageAsset: 'images/jwmarriott.jpg',
    imageUrls: [
      'https://ik.imagekit.io/tvlk/apr-asset/dgXfoyh24ryQLRcGq00cIdKHRmotrWLNlvG-TxlcLxGkiDwaUSggleJNPRgIHCX6/hotel/asset/10021898-db00f54a9f1a5b7b88db4c1eccd24ec0.jpeg?tr=q-80,c-at_max,w-740,h-500&_src=imagekit',
      'https://ik.imagekit.io/tvlk/apr-asset/dgXfoyh24ryQLRcGq00cIdKHRmotrWLNlvG-TxlcLxGkiDwaUSggleJNPRgIHCX6/hotel/asset/10021898-db00f54a9f1a5b7b88db4c1eccd24ec0.jpeg?tr=q-80,c-at_max,w-740,h-500&_src=imagekit',
    ],
  ),
  Hotel(
    name: 'Shangri-La Surabaya',
    city: 'Surabaya',
    rating: 5,
    description: 'Hotel mewah dengan kolam renang tropis.',
    address: 'Mayjen Sungkono, Surabaya',
    price: 'Rp 2.600.000 / malam',
    imageAsset: 'images/shangrila-sby.jpg',
    imageUrls: [
      'https://direktori.vokasi.unair.ac.id/wp-content/uploads/2024/05/WhatsApp-Image-2024-05-08-at-06.39.51.jpeg',
      'https://blue.kumparan.com/image/upload/fl_progressive,fl_lossy,c_fill,f_auto,q_auto:best,w_640/v1570702616/ff1pq3fvxuhwrcjqqavi.jpg',
    ],
  ),
  Hotel(
    name: 'Vasa Hotel Surabaya',
    city: 'Surabaya',
    rating: 5,
    description: 'Hotel modern dengan fasilitas lengkap.',
    address: 'Mayjen HR Muhammad, Surabaya',
    price: 'Rp 1.900.000 / malam',
    imageAsset: 'images/vasa.jpg',
    imageUrls: [
      'https://q-xx.bstatic.com/xdata/images/hotel/max500/388656065.jpg?k=3a6806606aad9a891c0d84a40493789cf5f89915a33c55404804b005ebe2ba72&o=',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBK6vCd44z-ol9KjRY1ZcBPhFdec7ClmFHEg&s',
    ],
  ),
  Hotel(
    name: "The Alana Surabaya",
    city: "Surabaya",
    rating: 4,
    description:
        "Hotel mewah, murah dengan fasilitas lengkap dekat dengan perkotaan.",
    address:
        "Jl. Ketintang Baru I No.10-12, Ketintang, Kec. Gayungan, Surabaya",
    price: "Rp 780.000 / malam",
    imageAsset: "assets/images/The_Alana_Surabaya.jpg",
    imageUrls: [
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-mobile/tix-hotel/images-web/2020/10/31/729e4fd7-baee-4c3a-8eb9-7d0d52bb85f2-1604158982009-056fa2cc0f6d953ce3c4b714196a9687.jpg',
      'https://res.klook.com/image/upload/w_750,c_fill,q_85/v1679277836/hotel/myzj3ydmhtu9gkclqznq.jpg',
    ],
  ),
  Hotel(
    name: "Surabaya Suites Hotel",
    city: "Surabaya",
    rating: 5,
    description:
        "Hotel elegan, clasik dengan standar nasional dan fasilitas lengkap.",
    address:
        "Jl. Plaza Boulevard Jl. Pemuda No.33 - 37, Embong Kaliasin, Kec. Genteng",
    price: "Rp 500.000 / malam",
    imageAsset: "assets/images/JSurabaya_Suites.jpg",
    imageUrls: [
      'https://direktori.vokasi.unair.ac.id/wp-content/uploads/2024/04/yi0b366a.png',
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-mobile/tix-hotel/images-web/2021/04/13/2f8977ee-b394-4537-ab5d-1f20dea7c7fc-1618280118644-56be915ea9e184a4b23361d146814a82.jpg',
    ],
  ),
  Hotel(
    name: 'Four Points by Sheraton Manado',
    city: 'Manado',
    rating: 4,
    description: 'Hotel modern dengan pemandangan pantai Manado.',
    address: 'Jl. Piere Tendean, Manado',
    price: 'Rp 1.600.000 / malam',
    imageAsset: 'images/fourpoints-manado.jpg',
    imageUrls: [
      'https://www.manadosafaris.com/wp/wp-content/uploads/2017/05/4-points-main-1.jpg',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQ53g8KCBCPfcTrYlNgHfbqCkTNwDkD_ko9A&s',
    ],
  ),
  Hotel(
    name: 'Novotel Manado',
    city: 'Manado',
    rating: 4,
    description: 'Hotel nyaman dekat bandara dengan fasilitas lengkap.',
    address: 'Jalan AA Maramis, Manado',
    price: 'Rp 1.300.000 / malam',
    imageAsset: 'images/novotel-manado.jpg',
    imageUrls: [
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-dskt/tix-hotel/images-web/2023/03/04/9e56f1f1-410e-44b5-ae3f-043319b9c109-1677935011158-aafdc82b1464baae1ef8a8c2205b3c89.jpg',
      'https://q-xx.bstatic.com/xdata/images/hotel/max500/69933455.jpg?k=f9d76ea43241b7346a55ee1fc54647f99e0c0047f8794bb0465425d8f743c965&o=',
    ],
  ),
  Hotel(
    name: 'The Rinra Makassar',
    city: 'Makassar',
    rating: 5,
    description: 'Hotel mewah tepi pantai dengan ballroom megah.',
    address: 'Metro Tanjung Bunga, Makassar',
    price: 'Rp 2.100.000 / malam',
    imageAsset: 'images/rinra-mks.jpg',
    imageUrls: [
      'https://ik.imagekit.io/tvlk/apr-asset/dgXfoyh24ryQLRcGq00cIdKHRmotrWLNlvG-TxlcLxGkiDwaUSggleJNPRgIHCX6/hotel/asset/10011385-7783e4734c31191d080b7b342e9f7d04.jpeg?tr=q-80,c-at_max,w-740,h-500&_src=imagekit',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROg42_3iMkSfeJHOOtXalwBJht9kCNMRhITQ&s',
    ],
  ),
  Hotel(
    name: 'Claro Hotel Makassar',
    city: 'Makassar',
    rating: 4,
    description: 'Hotel bisnis modern dengan pusat konferensi besar.',
    address: 'Jl. AP Pettarani, Makassar',
    price: 'Rp 1.400.000 / malam',
    imageAsset: 'images/claro-mks.jpg',
    imageUrls: [
      'https://q-xx.bstatic.com/xdata/images/hotel/max500/716042260.jpg?k=aa13183e83f88e7b47662170b0e9a285aea9f267c6219c94e011ce722551d6d1&o=',
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-mobile/tix-hotel/images-web/2020/10/31/87e88203-fc5e-471d-b22c-7b441afc498f-1604134928640-acb3b5c1cb27e8cf2a1bbab5e78b5f21.jpg',
    ],
  ),
  Hotel(
    name: 'JW Marriott Medan',
    city: 'Medan',
    rating: 5,
    description: 'Hotel mewah tertinggi di Medan dengan fasilitas lengkap.',
    address: 'Jl. Putri Hijau No.10, Medan',
    price: 'Rp 2.000.000 / malam',
    imageAsset: 'images/jwmarriott-medan.jpg',
    imageUrls: [
      'https://ik.imagekit.io/tvlk/apr-asset/dgXfoyh24ryQLRcGq00cIdKHRmotrWLNlvG-TxlcLxGkiDwaUSggleJNPRgIHCX6/hotel/asset/67705294-1519x1034-FIT_AND_TRIM-7a19977091a993f01f25167868f27c17.jpeg?tr=q-80,c-at_max,w-740,h-500&_src=imagekit',
      'https://pix10.agoda.net/hotelImages/148825/-1/53c66061df94fa53c6d50225419ee9c8.jpg?ca=9&ce=1&s=414x232',
    ],
  ),
  Hotel(
    name: 'Aryaduta Medan',
    city: 'Medan',
    rating: 4,
    description: 'Hotel premium dengan kolam rooftop besar.',
    address: 'Jl. Kapten Maulana Lubis, Medan',
    price: 'Rp 1.300.000 / malam',
    imageAsset: 'images/aryaduta-medan.jpg',
    imageUrls: [
      'https://ahg-cms.gumlet.io/media/img-e8a08ba0-231c-4868-98b9-200b75faa511.jpg',
      'https://cf.bstatic.com/xdata/images/hotel/max1024x768/136871173.jpg?k=70765b792111e9b8b76344122ca541fe438705a53a8e8668b1daf4ad6365355b&o=',
    ],
  ),
  Hotel(
    name: 'AIHO Hotel Medan',
    city: 'Medan',
    rating: 4,
    description:
        'Hotel bintang empat ternyaman di Medan dengan fasilitas lengkap.',
    address:
        'Jl. H. Adam Malik No.5, Sekip, Kec. Medan Petisah, Kota Medan, Sumatera Utara',
    price: 'Rp 860.000 / malam',
    imageAsset: 'assets/images/AIHO_Hotel.jpg',
    imageUrls: [
      'https://pix10.agoda.net/hotelImages/282/28202280/28202280_211001122300105939525.jpg?s=414x232',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTlarpZAHRvVuMNC-wiVeBuFFB5_6EUSx56YQ&s',
    ],
  ),
  Hotel(
    name: 'The Reiz Suites, ARTOTEL Curated',
    city: 'Medan',
    rating: 4,
    description:
        'Hotel bintang empat Medan dengan kolam renang rooftop terbaik.',
    address:
        'Jl. Tembakau Deli No.1, Kesawan, Kec. Medan Bar., Kota Medan, Sumatera Utara',
    price: 'Rp 600.000 / malam',
    imageAsset: 'assets/images/The_Reiz_Suites.jpg',
    imageUrls: [
      'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2c/19/84/95/caption.jpg?w=900&h=500&s=1',
      'https://pix10.agoda.net/hotelImages/28202280/-1/b79e8f6a2f6d0ae6227cf5f11d10fb9a.jpg?ce=0&s=414x232',
    ],
  ),
  Hotel(
    name: 'The Mulia Bali',
    city: 'Bali',
    rating: 5,
    description: 'Resort mewah di tepi pantai Nusa Dua.',
    address: 'Nusa Dua, Bali',
    price: 'Rp 4.500.000 / malam',
    imageAsset: 'images/mulia-bali.jpg',
    imageUrls: [
      'https://cdn.prod.website-files.com/6624ff6a5db57a668993dd5e/67038eafe9a946b8e90cf9f5_MRB%20-%20Ladies%20Courtyard.webp',
      'https://cdn.prod.website-files.com/6624ff6a5db57a668993dd5e/6731a967b1f1540c73d49ca0_Bonus%20Nights.webp',
    ],
  ),
  Hotel(
    name: "Royal Ambarrukmo Yogyakarta",
    city: "Yogyakarta",
    rating: 5,
    description:
        "Hotel mewah ikonik dengan fasilitas lengkap dan pelayanan premium.",
    address: "Jl. Laksda Adisucipto No.81, Sleman, Yogyakarta",
    price: "Rp 2.500.000 / malam",
    imageAsset: "assets/images/royalambarrukmo.jpg",
    imageUrls: [
      'https://image-tc.galaxy.tf/wijpeg-6jve6rts3zryzwjygpd9kliu0/hotel-facade-royal-ambarrukmo-yogyakarta-medium.jpg?width=1920',
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-mobile/tix-hotel/images-web/2020/10/28/a2241d55-5990-448c-b892-cfdd5ad7a8b1-1603874464401-9f6ff5a14ff33aedc0a81c09e28f9682.jpg',
    ],
  ),
  Hotel(
    name: "Melia Purosani Yogyakarta",
    city: "Yogyakarta",
    rating: 5,
    description:
        "Hotel bintang 5 bernuansa tropis, cocok untuk liburan dan bisnis.",
    address: "Jl. Suryotomo No.31, Gondomanan, Yogyakarta",
    price: "Rp 2.300.000 / malam",
    imageAsset: "assets/images/meliapurosani.jpg",
    imageUrls: [
      'https://dam.melia.com/melia/accounts/f8/4000018/projects/127/assets/08/15990/b714d37d68aefc942613d4b9af97bcc4-1600343535.jpg?fp=1771.5,995.5&width=2000&height=1124',
      'https://cf.bstatic.com/xdata/images/hotel/max1024x768/354912696.jpg?k=751970a239d37ff827d6e015fa7d775fa19e4a9e10b6cf6967bb9b124d170e35&o=',
    ],
  ),
  Hotel(
    name: "Gumaya Tower Hotel",
    city: "Semarang",
    rating: 5,
    description:
        "Hotel modern dengan fasilitas lengkap di pusat kota Semarang.",
    address: "Jl. Gajahmada No.59, Semarang Tengah, Semarang",
    price: "Rp 2.200.000 / malam",
    imageAsset: "assets/images/gumaya.jpg",
    imageUrls: [
      'https://kfmap.asia/storage/thumbs/storage/photos/ID.SMG.HT.GTH/ID.SMG.HT.GTH_1.jpg',
      'https://www.mandirikartukredit.com/uploads/media/merchant/rcc-jawa-tengah/hotel/gumaya.jpg',
    ],
  ),
  Hotel(
    name: "Gran Senyiur Hotel",
    city: "Balikpapan",
    rating: 5,
    description:
        "Hotel bintang lima dengan kenyamanan dan lokasi strategis di Balikpapan.",
    address: "Jl. ARS Moh. No.37, Balikpapan",
    price: "Rp 2.000.000 / malam",
    imageAsset: "assets/images/gransenyiur.jpg",
    imageUrls: [
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-mobile/tix-hotel/images-web/2025/09/18/857deab3-eb1b-46c4-b1e3-6bf6d792842f-1758182129781-f4aa306c71e16893908563648ba3a431.jpg',
      'https://gran.senyiurhotels.com/files/images/welcome/thumbnail/i000001bf1ab9396980884595059a859a0afe6e_large.jpg',
    ],
  ),
  Hotel(
    name: "Blue Sky Hotel Balikpapan",
    city: "Balikpapan",
    rating: 4,
    description: "Hotel nyaman dengan fasilitas lengkap di pusat Balikpapan.",
    address: "Jl. Letjen Soeprapto No.1, Balikpapan",
    price: "Rp 1.500.000 / malam",
    imageAsset: "assets/images/bluesky_balikpapan.jpg",
    imageUrls: [
      'https://s3-ap-southeast-1.amazonaws.com/xwork-bucket/buildings/images/281/bluesky%20balikpapan.jpg',
      'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/07/2a/98/cc/kolam-renang-yg-nyaman.jpg?w=900&h=-1&s=1',
    ],
  ),
  Hotel(
    name: "Hermes Palace Hotel Banda Aceh",
    city: "Banda Aceh",
    rating: 5,
    description:
        "Hotel mewah pertama di Banda Aceh dengan fasilitas lengkap dan elegan.",
    address: "Jl. T. Panglima Nyak Makam, Banda Aceh",
    price: "Rp 2.200.000 / malam",
    imageAsset: "assets/images/hermes_aceh.jpg",
    imageUrls: [
      'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0a/bc/cf/8d/hermes-palace-hotel-banda.jpg?w=900&h=500&s=1',
      'https://static.wixstatic.com/media/4eaca8_d2a08f07e4974418b3894c33f3135eb3~mv2.jpg/v1/fill/w_640,h_480,al_c,q_80,usm_0.66_1.00_0.01,enc_avif,quality_auto/4eaca8_d2a08f07e4974418b3894c33f3135eb3~mv2.jpg',
    ],
  ),
  Hotel(
    name: "Kyriad Muraya Hotel Aceh",
    city: "Banda Aceh",
    rating: 4,
    description: "Hotel modern di pusat Banda Aceh dengan layanan terbaik.",
    address: "Jl. Tengku Muhammad Daud Beureueh No.5, Banda Aceh",
    price: "Rp 1.500.000 / malam",
    imageAsset: "assets/images/kyriad_aceh.jpg",
    imageUrls: [
      'https://dialeksis.com/images/web/2024/12/hotel-kyriad-muraya-311224.JPG',
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-dskt/tix-hotel/images-web/2020/10/29/9ef6c083-6e8e-4ed1-967b-2e5d493b758f-1603912152981-d32d3e6ad9729b92745841d36d0ea8dc.jpg',
    ],
  ),
  Hotel(
    name: "The Axana Hotel Padang",
    city: "Padang",
    rating: 4,
    description:
        "Hotel nyaman dekat pusat kota Padang dengan fasilitas lengkap.",
    address: "Jl. Bundo Kanduang No.14-16, Padang",
    price: "Rp 1.400.000 / malam",
    imageAsset: "assets/images/axana_padang.jpg",
    imageUrls: [
      'https://s-light.tiket.photos/t/01E25EBZS3W0FY9GTG6C42E1SE/t_htl-dskt/tix-hotel/images-web/2020/10/28/1b3ec58f-56dd-4c8d-bdef-a0107a6f4ae5-1603880491902-5c986a9443b4f053fe0f83aaa2e61f96.jpg',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShzVVM3-l6dHIa0BfNLAqnjca4VE9mSRYtlw&s',
    ],
  ),
  Hotel(
    name: "Grand Inna Padang",
    city: "Padang",
    rating: 4,
    description: "Hotel berlokasi strategis di pusat kota Padang.",
    address: "Jl. Gereja No. 34, Padang",
    price: "Rp 1.300.000 / malam",
    imageAsset: "assets/images/innapadang.jpg",
    imageUrls: [
      'https://cdn.1001malam.com/uploads/hotels/grandinnamuarapadanghotel_tampilanluar_1208022.jpg',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNY1KOTEjFgmm4Ybbhh89NEows1nChr-ZpeQ&s',
    ],
  ),
  Hotel(
    name: "Grand Jatra Hotel Pekanbaru",
    city: "Pekanbaru",
    rating: 5,
    description:
        "Hotel mewah di pusat kota Pekanbaru dengan fasilitas modern.",
    address: "Jl. Tengku Zainal Abidin, Pekanbaru",
    price: "Rp 2.100.000 / malam",
    imageAsset: "assets/images/grandjatra_pekanbaru.jpg",
    imageUrls: [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_D9EeLYn2U2C2nQoMIgkqfIw-6ALJEEJwWA&s',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_D9EeLYn2U2C2nQoMIgkqfIw-6ALJEEJwWA&s',
    ],
  ),
  Hotel(
    name: "Novotel Pekanbaru",
    city: "Pekanbaru",
    rating: 4,
    description: "Hotel modern dengan standar internasional di Pekanbaru.",
    address: "Jl. Riau No.59, Pekanbaru",
    price: "Rp 1.600.000 / malam",
    imageAsset: "assets/images/novotel_pekanbaru.jpg",
    imageUrls: [
      'https://www.ahstatic.com/photos/9482_ho_00_p_1024x768.jpg',
      'https://www.ahstatic.com/photos/9482_rodbb_00_p_1024x768.jpg',
    ],
  ),
  Hotel(
    name: "Montigo Resorts Nongsa",
    city: "Batam",
    rating: 5,
    description:
        "Resor mewah dengan vila pribadi dan pemandangan laut terbaik di Batam.",
    address: "Jl. Hang Lekir, Nongsa, Batam",
    price: "Rp 3.500.000 / malam",
    imageAsset: "assets/images/montigo_batam.jpg",
    imageUrls: [
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2b/1b/06/43/caption.jpg?w=900&h=-1&s=1",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQn9L8_KjgbrQMWrobdANPlIC90U9Q0oMpFrA&s",
    ],
  ),
  Hotel(
    name: "HARRIS Resort Barelang Batam",
    city: "Batam",
    rating: 4,
    description:
        "Resor modern dekat Jembatan Barelang dengan fasilitas keluarga lengkap.",
    address: "Jl. Trans Barelang, Batam",
    price: "Rp 1.700.000 / malam",
    imageAsset: "assets/images/harris_barelang.jpg",
    imageUrls: [
      'https://pix10.agoda.net/hotelImages/3847734/-1/ee17a29b9c592860e606a66eb8162593.jpg?ca=25&ce=0&s=414x232',
      'https://www.discoverasr.com/content/dam/tal/media/images/properties/indonesia/batam/harris-resort-barelang-batam/overview/HBRL-thumbnail.jpg.transform/ascott-lowres/image.jpg',
    ],
  ),
];