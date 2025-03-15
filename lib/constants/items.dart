var poojaItems = [
  {
    "id": 1,
    "name": "Karpuram",
    "unit_id": 1, // ✅ Gram (g)
    "unit_count": 50,
    "item_category_id": 1,
    "items_function_ids": [1, 2, 3, 4, 5],
    "mrp": 50,
    "selling_price": 45,
    "img": "https://m.media-amazon.com/images/I/71xLXav2yYL.jpg",
  },
  {
    "id": 2,
    "name": "Kungumam",
    "unit_id": 1, // ✅ Gram (g)
    "unit_count": 100,
    "item_category_id": 2,
    "items_function_ids": [1, 4, 5],
    "mrp": 30,
    "selling_price": 25,
    "img":
        "https://giri.in/cdn/shop/files/42500242_Thazhampoo_Kumkum_Red_50Gms_2_a689995e-95a0-4d1a-ba3d-12ce02835a0e_700x700.webp",
  },
  {
    "id": 3,
    "name": "Deepam Oil",
    "unit_id": 3, // ✅ Liter (l)
    "unit_count": 1,
    "item_category_id": 3,
    "items_function_ids": [1, 2, 3, 4, 5],
    "mrp": 150,
    "selling_price": 140,
    "img": "https://m.media-amazon.com/images/I/61-5tsBEWKL.jpg",
  },
  {
    "id": 4,
    "name": "Turmeric Powder",
    "unit_id": 1, // ✅ Gram (g)
    "unit_count": 200,
    "item_category_id": 4,
    "items_function_ids": [1, 4, 5],
    "mrp": 40,
    "selling_price": 35,
    "img":
        "http://giri.in/cdn/shop/files/42500245_Turmeric_Powder_50Gms_2_700x700.webp",
  },
  {
    "id": 5,
    "name": "Sandal Powder",
    "unit_id": 1, // ✅ Gram (g)
    "unit_count": 50,
    "item_category_id": 5,
    "items_function_ids": [1, 4, 5],
    "mrp": 80,
    "selling_price": 75,
    "img":
        "https://5.imimg.com/data5/XC/YC/MY-29279226/sandal-scented-powder.jpg",
  },
  {
    "id": 6,
    "name": "Cotton Wicks",
    "unit_id": 5, // ✅ Pack
    "unit_count": 10,
    "item_category_id": 6,
    "items_function_ids": [1, 2, 3, 4, 5],
    "mrp": 20,
    "selling_price": 18,
    "img": "https://m.media-amazon.com/images/I/51MZ+ieYUtL._SL1080_.jpg",
  },
  {
    "id": 7,
    "name": "Pooja Pot",
    "unit_id": 7, // ✅ Combo
    "unit_count": 5,
    "item_category_id": 7,
    "items_function_ids": [1, 2, 4, 5],
    "mrp": 250,
    "selling_price": 230,
    "img": "https://m.media-amazon.com/images/I/71ktPIsv51L.jpg",
  },
  {
    "id": 8,
    "name": "Incense Sticks",
    "unit_id": 5, // ✅ Pack
    "unit_count": 1,
    "item_category_id": 8,
    "items_function_ids": [1, 2, 3, 4, 5],
    "mrp": 60,
    "selling_price": 55,
    "img":
        "https://m.media-amazon.com/images/I/71Onjqg+roL._AC_UF894,1000_QL80_.jpg",
  },
  {
    "id": 9,
    "name": "Betel Leaves",
    "unit_id": 9, // ✅ Pack
    "unit_count": 25,
    "item_category_id": 9,
    "items_function_ids": [1, 2, 5],
    "mrp": 250,
    "selling_price": 220,
    "img":
        "https://m.media-amazon.com/images/I/51aoJREzIML._AC_UF1000,1000_QL80_.jpg",
  },
  {
    "id": 10,
    "name": "Coconut",
    "unit_id": 6, // ✅ Piece
    "unit_count": 1,
    "item_category_id": 10,
    "items_function_ids": [1, 2, 3, 4, 5],
    "mrp": 35,
    "selling_price": 30,
    "img":
        "https://tiimg.tistatic.com/fp/1/007/912/commonly-cultivated-semi-husked-medium-sized-matured-fresh-coconut-010.jpg",
  },
  {
    "id": 11,
    "name": "Pancha Pathiram",
    "unit_id": 6, // ✅ Piece
    "unit_count": 1,
    "item_category_id": 7,
    "items_function_ids": [1, 2, 5],
    "mrp": 1200,
    "selling_price": 1100,
    "img":
        "https://5.imimg.com/data5/SELLER/Default/2024/12/470839262/JM/HE/GI/98162716/71-500x500.jpg",
  },
  {
    "id": 12,
    "name": "Navadhaniyam",
    "unit_id": 2, // ✅ Pack
    "unit_count": 1,
    "item_category_id": 11,
    "items_function_ids": [4],
    "mrp": 100,
    "selling_price": 90,
    "img":
        "https://southindiangrocery.com/cdn/shop/products/navadhanya-pooja-set.png",
  },
  {
    "id": 13,
    "name": "Vibuthi",
    "unit_id": 1, // ✅ Gram (g)
    "unit_count": 50,
    "item_category_id": 2,
    "items_function_ids": [1, 4, 5],
    "mrp": 25,
    "selling_price": 20,
    "img":
        "https://m.media-amazon.com/images/I/51-r5rdll4L._AC_UF894,1000_QL80_.jpg",
  },
  {
    "id": 14,
    "name": "Ganga Jal",
    "unit_id": 3, // ✅ Liter (l)
    "unit_count": 1,
    "item_category_id": 3,
    "items_function_ids": [1, 2, 3, 4, 5],
    "mrp": 200,
    "selling_price": 180,
    "img":
        "https://5.imimg.com/data5/VP/EB/MY-63028801/pure-ganga-jal-gangajal-holy-water-100ml-from-rishikesh-himalaya-500x500.jpg",
  },
  {
    "id": 15,
    "name": "Banana Leaf",
    "unit_id": 6, // ✅ Piece
    "unit_count": 1,
    "item_category_id": 10,
    "items_function_ids": [1, 2, 5],
    "mrp": 10,
    "selling_price": 8,
    "img":
        "https://png.pngtree.com/png-vector/20221231/ourmid/pngtree-banana-leaves-green-tropical-leaf-png-image_6545437.png",
  },
];
